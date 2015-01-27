


#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <sys/stat.h>


#include "channelflow/utilfuncs.h"
#include "channelflow/flowfield.h"
#include "channelflow/diffops.h"
#include "channelflow/vector.h"

using namespace std;
using namespace channelflow;

//FlowDist object stores the minimum distance between two flow fields, as well as the phase angles of x-z shifts that give that minimum distance
struct FlowDist {
  Real dist;
  Real xphase;
  Real zphase;
};

FlowDist XZSymmetricDist(FlowField u, FlowField v,Real axmin, Real axmax, Real dax, Real azmin, Real azmax, Real daz);
FlowDist ZSymmetricDist(FlowField u, FlowField v,Real azmin, Real azmax, Real daz);
FlowDist XSymmetricDist(FlowField u, FlowField v,Real axmin, Real axmax, Real dax);
FlowDist SymmetricDistance(FlowField u, FlowField v,bool ax, bool az, Real axmin, Real axmax, Real dax, Real azmin, Real azmax, Real daz);
FlowDist NullSymmetricDist(FlowField u, FlowField v);
FlowField FieldShift(Real x, Real z, FlowField v);

int main(int argc, char* argv[]){

  string purpose("compute the recurrence graph of a trajectory (||u(t+T) - u(t)||) and save the data to disk.");

  ArgList args(argc,argv,purpose);

   const Real T0 = args.getreal("-T0","--T0",0.0, "start time");
   const Real T1 = args.getreal("-T1","--T1",100.0, "end time");
   const Real TRec = args.getreal("-TR","--TRec",10.0,"Maximum value of T in u(t+T). Make sure the phase space trajectory has been calculated from u(T0) to u(T1+TRec)");
   const Real dT = args.getreal("-dT","--dT",1.0, "save interval for recurrence time");
   const Real dt = args.getreal("-dt","--dt",1.0, "save interval for start time");
   const string outdir = args.getpath("-o","--out","", "output directory");
   const string indir = args.getpath("-d","--data","data/", "directory containing flow fields");
   const string label = args.getstr("-l","--label","u", "input field prefix");
   const string symmstr = args.getstr("-symms","-symmetries","","constrain u(t) to an invariant symmetric subspace, argument is the filename for the generators of the isotropy group");
   const string recname = args.getstr(1,"<flowfield>", "name of outpt file");
   const bool ax = args.getflag("-ax",  "--brokensymmetryX", "signals that streamwise symmetry has been broken, allows the algorithm to make streamwise displacements of the field ");
   const bool az = args.getflag("-az",  "--brokensymmetryZ", "signals that spanwise symmetry has been broken, allows the algorithm to make spanwise displacements of the field ");
   const Real axmin = args.getreal("-axmin","--axmin",-0.5, "lower bound for tested streamwise displacements");
   const Real axmax = args.getreal("-axmax","--axmax",0.5, "upper bound for tested streamwise displacements");
   const Real dax = args.getreal("-dax","--dax",0.01, "increment for tested streamwise displacements");
   const Real azmin = args.getreal("-azmin","--azmin",-0.5, "lower bound for tested spanwise displacements");
   const Real azmax = args.getreal("-azmax","--azmax",0.5, "upper bound for tested spanwise displacements");
   const Real daz = args.getreal("-daz","--daz",0.01, "increment for tested spanwise displacements");


   args.check();
   args.save("./");
   mkdir(outdir);
   const bool inttime = (abs(dT - int(dT)) < 1e-12) ? true : false;
   FlowField difference;
   FlowDist distPhase;
   string recnameI = recname+".csv";
   FILE* outfile = fopen(recnameI.c_str(),"w");
   FILE* xPhase = fopen("xphase.csv","w");
   FILE* zPhase = fopen("zphase.csv","w");

   for (Real t=T0; t<=T1; t+=dt){
     string ts =t2s(t,inttime);
     FlowField u(indir + label + ts);
     FlowField v(indir + label + t2s(dT+t,inttime));
     distPhase = SymmetricDistance(u,v,ax,az,axmin,axmax,dax,azmin,azmax,daz);
     fprintf(outfile,"%f",distPhase.dist);
     fprintf(xPhase,"%f",distPhase.xphase);
     fprintf(zPhase,"%f",distPhase.zphase);
     cout << "Computing recurrence graph for t = "<<t<<endl;
     for(Real tp=2*dT; tp<=TRec; tp+=dT){
       string tps= t2s(tp+t,inttime);
       FlowField v(indir + label + tps);
       distPhase = SymmetricDistance(u,v,ax,az,axmin,axmax,dax,azmin,azmax,daz);
       fprintf(outfile,", ");
       fprintf(outfile,"%f",distPhase.dist);
       fprintf(xPhase,", ");
       fprintf(xPhase,"%f",distPhase.xphase);
       fprintf(zPhase,", ");
       fprintf(zPhase,"%f",distPhase.zphase);

     }
     fprintf(outfile,"\n");
   }
   fclose(outfile);
}


//SymmetricDistance is a master function that runs one of four versions of the distance finder, depending on what shifts are allowed

FlowDist SymmetricDistance(FlowField u, FlowField v,bool ax, bool az, Real axmin, Real axmax, Real dax, Real azmin, Real azmax, Real daz){
  FlowDist distPhase;
  if (ax && az) // xz shift
    distPhase = XZSymmetricDist(u,v,axmin,axmax,dax,azmin,azmax,daz);
  else if (ax)    // x shift only
    distPhase = XSymmetricDist(u,v,axmin,axmax,dax);
  else if (az)
    // z shift only
    distPhase = ZSymmetricDist(u,v,azmin,azmax,daz);
  else
    // no shifts
    distPhase = NullSymmetricDist(u,v);
    
  
  return distPhase;
}

FlowDist XZSymmetricDist(FlowField u, FlowField v, Real axmin, Real axmax, Real dax, Real azmin, Real azmax, Real daz){
  FlowField vshift;
  FlowDist minDistPhase;
  Real currentDist;
  minDistPhase.dist = 10.0;
  for(Real i = axmin; i <= axmax; i+= dax){
    for(Real j = azmin; j <= azmax; j+= daz){
      // there should be a function that actually does this, find it
      vshift = FieldShift(i,j,v);

      currentDist = L2Dist(u,vshift);
      if( currentDist < minDistPhase.dist){
	minDistPhase.dist = currentDist;
	minDistPhase.xphase = i;
	minDistPhase.zphase = j;
      }

    }
   
  }
  return minDistPhase;
}

FlowDist XSymmetricDist(FlowField u, FlowField v, Real axmin, Real axmax, Real dax){
  FlowField vshift;
  FlowDist minDistPhase;
  Real currentDist;
  minDistPhase.dist = 10.0;
  for(Real i = axmin; i <= axmax; i+= dax){
    vshift = FieldShift(i,0,v);
    currentDist = L2Dist(u,vshift);
    if( currentDist < minDistPhase.dist){
      minDistPhase.dist = currentDist;
      minDistPhase.xphase = i;
      minDistPhase.zphase = 0.0;
    }
  }
  return minDistPhase;
}
FlowDist ZSymmetricDist(FlowField u, FlowField v, Real azmin, Real azmax, Real daz){
  FlowField vshift;
  FlowDist minDistPhase;
  Real currentDist;
  minDistPhase.dist = 10.0;
  for(Real j = azmin; j <= azmax; j+= daz){
    vshift = FieldShift(0,j,v);   
    currentDist = L2Dist(u,vshift);
    if( currentDist < minDistPhase.dist){
      minDistPhase.dist = currentDist;
      minDistPhase.xphase = 0.0;
      minDistPhase.zphase = j;
    }
  }
  return minDistPhase;
}
FlowDist NullSymmetricDist(FlowField u, FlowField v){
  FlowDist distPhase;
  distPhase.dist = L2Dist(u,v);
  distPhase.xphase = 0.0;
  distPhase.zphase = 0.0;
  return distPhase;
}

FlowField FieldShift(Real x, Real z, FlowField v){
  FieldSymmetry tau;
  FlowField vshift;
  tau = FieldSymmetry(1,1,1,x,z);
  vshift = tau(v);
  return vshift;
}
