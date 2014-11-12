
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


   const string label = args.getstr("-l","--label","u", "input field prefix");
   const string recname = args.getstr(1,"<flowfield>", "name of outpt file");

   args.check();
   FlowField u(label);
   FlowField v(recname);
   Real norm = L2Dist(u,v);
   cout << norm << endl;
}
