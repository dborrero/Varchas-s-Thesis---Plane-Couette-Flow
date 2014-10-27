
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

int main(int argc, char* argv[]){

  string purpose("compute the recurrence graph of a trajectory (||u(t+T) - u(t)||) and save the data to disk.");

  ArgList args(argc,argv,purpose);

   const Real T0 = args.getreal("-T0","--T0",0.0, "start time");
   const Real T1 = args.getreal("-T1","--T1",100.0, "end time");
   const Real TRec = args.getreal("-TR","--TRec",10.0,"Maximum value of T in u(t+T). Make sure the phase space trajectory has been calculated from u(T0) to u(T1+TRec)");
   const Real dT = args.getreal("-dT","--dT",1.0, "save interval");
   const string outdir = args.getpath("-o","--out","", "output directory");
   const string indir = args.getpath("-d","--data","data/", "directory containing flow fields");
   const string label = args.getstr("-l","--label","u", "input field prefix");
   const string recname = args.getstr(1,"<flowfield>", "name of outpt file");

   args.check();
   args.save("./");
   mkdir(outdir);
   const bool inttime = (abs(dT - int(dT)) < 1e-12) ? true : false;
   FlowField difference;
   Real norm;
   FILE* outfile = fopen(recname.c_str(),"w");
   cout << "Beginning computation of recurrence graph..." << endl;
   
   for (Real t=T0; t<=T1; t+=dT){
     string ts =t2s(t,inttime);
     FlowField u(indir + label + ts);
     fprintf(outfile,"%d",0);
     cout << "Computing recurrence graph for t = " << t << endl;
     for(Real tp=dT; tp<=TRec; tp+=dT){
       string tps= t2s(tp+t,inttime);
       FlowField v(indir + label + tps);
       norm = L2Dist(u,v);
       fprintf(outfile,", ");
       fprintf(outfile,"%f",norm);
     }
     fprintf(outfile,"\n");
   }

     fclose(outfile);
}
