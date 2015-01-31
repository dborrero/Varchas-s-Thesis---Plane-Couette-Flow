


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

  const string uA = args.getstr(1,"<flowfield>", "name of outpt file");
  const string uB = args.getstr(2,"<flowfield>", "name of outpt file");
  const Real xshift = args.getreal("-ax","--ax",0.0,"streamwise shift of the second field before calculating the distance");
  const Real zshift = args.getreal("-az","--az",0.0,"spanwise shift of the second field before calculating the distance");
  
  

   args.check();
   args.save("./");
   FlowField ua(uA);
   
   FlowField ub(uB);
   FieldSymmetry tau = FieldSymmetry(1,1,1,xshift,zshift);
   ub = tau(ub);
   Real dist = L2Dist(ua,ub);
   cout << dist << endl;
   return 1; 
}

