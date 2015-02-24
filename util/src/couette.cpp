// License declaration at end of file

#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <sys/stat.h>

#include "channelflow/flowfield.h"
#include "channelflow/vector.h"
#include "channelflow/chebyshev.h"
#include "channelflow/tausolver.h"
#include "channelflow/dns.h"
#include "channelflow/utilfuncs.h"
#include "channelflow/symmetry.h"

using namespace std;
using namespace channelflow;


void printdiagnostics(FlowField& u, const DNS& dns, Real t, const TimeStep& dt, Real nu, Real umin,
		      Real term, bool vardt, bool pl2norm, bool pchnorm, bool pdissip, bool pshear,
		      bool pdiverge, bool pUbulk, bool pubulk, bool pdPdx, bool pcfl);

int main(int argc, char* argv[]) {

  string purpose("integrate plane Couette or channel flow from a given "
		 "initial condition and save velocity fields to disk.");

  ArgList args(argc, argv, purpose);

  const Real Reynolds = args.getreal("-R", "--Reynolds", 400,  "pseudo-Reynolds number == 1/nu");
  const Real nuarg    = args.getreal("-nu", "--nu",       0,  "kinematic viscosity (takes precedence over Reynolds, if nonzero)");
  const string meanstr= args.getstr ("-mc", "--meanconstraint", "gradp", "gradp|bulkv : hold one fixed");
  const Real dPdx     = args.getreal("-dPdx", "--dPdx",   0.0, "imposed pressure gradient, x-dir");
  const Real dPdz     = args.getreal("-dPdz", "--dPdx",   0.0, "imposed pressure gradient, z-dir");
  const Real Ubulk    = args.getreal("-Ubulk", "--Ubulk",  0.0, "imposed bulk u velocity");
  const Real Wbulk    = args.getreal("-Wbulk", "--Wbulk",  0.0, "imposed bulk w velocity");
  const Real Uwall    = args.getreal("-Uwall", "--Uwall",  1.0, "magnitude of imposed wall velocity, +/-Uwall at y = +/-h");
  const Real theta    = args.getreal("-theta", "--theta",  0.0, "angle of wall velocity to x axis");
  const string basestr= args.getstr ("-bf", "--baseflow", "laminar", "laminar|zero|linear|parabolic, set base flow to one of these");

  //const string velstr = args.getstr("-vs", "--velocityscale",  "wall", "wall|parab : velocity scale for Reynolds");
  //const string Ubase  = args.getstr("-Ubase", "--Ubase",  "", "filename for base flow, otherwise");

  const Real T0       = args.getreal("-T0", "--T0", 0.0, "start time");
  const Real T1       = args.getreal("-T1", "--T1", 100, "end time");
  const bool vardt    = args.getflag("-vdt", "--variabledt", "adjust dt to keep CFLmin<=CFL<CFLmax");
  const Real dtarg    = args.getreal("-dt",     "--dt", 0.03125, "timestep");
  const Real dtmin    = args.getreal("-dtmin",  "--dtmin", 0.001, "minimum time step");
  /***/ Real dtmax    = args.getreal("-dtmax",  "--dtmax", dtarg,  "maximum time step");
  /***/ Real dT       = args.getreal("-dT",     "--dT", 1.0, "CFL adjust interval");
  /***/ Real sF      = args.getreal("-sF",     "--saveFactor", 1.0, "Save to disk interval multiplier, so that it saves to disk every dT*sF time units");
  const bool adjustdT = args.getflag("-adT",    "--adjustdT", "tweak dT so that it evenly divides (T1-T0)");
  const Real CFLmin   = args.getreal("-CFLmin", "--CFLmin", 0.40, "minimum CFL number");
  const Real CFLmax   = args.getreal("-CFLmax", "--CFLmax", 0.60, "maximum CFL number");
  const bool dealias  = args.getbool("-dealias", "--dealias", true, "use 2/3-style dealiasing in x,z");

  const string stepstr= args.getstr ("-ts", "--timestepping", "sbdf3", "timestepping algorithm, "
				     " one of [cnfe1 cnab2 cnrk2 smrk2 sbdf1 sbdf2 sbdf3 sbdf4]");
  const string initstr= args.getstr ("-is", "--initstepping", "smrk2", "timestepping algorithm for initializing multistep algorithms, "
				     " one of [cnfe1 cnrk2 smrk2 sbdf1]");
  const string nonlstr= args.getstr ("-nl", "--nonlinearity", "rot", "method of calculating "
				     "nonlinearity, one of [rot conv div skew alt]");
  const string symmstr= args.getstr ("-symms","--symmetries", "", "constrain u(t) to invariant "
				     "symmetric subspace, argument is the filename for a file "
				     "listing the generators of the isotropy group");
  const string outdir = args.getpath("-o", "--outdir", "data/", "output directory");
  const string label  = args.getstr ("-l", "--label", "u", "output field prefix");
  const bool   savep  = args.getflag("-sp", "--savepressure", "save pressure fields");

  const bool pcfl     = args.getflag("-cfl", "--cfl",         "print CFL number each dT");
  const bool pl2norm  = args.getflag("-l2",  "--l2norm",      "print L2Norm(u) each dT");
  const bool pchnorm  = args.getbool("-ch", "--chebyNorm", true, "print chebyNorm(u) each dT");
  const bool pdissip  = args.getflag("-D",  "--dissipation",  "print dissipation each dT");
  const bool pshear   = args.getflag("-I",  "--input",        "print wall shear power input each dT");
  const bool pdiverge = args.getflag("-dv", "--divergence",   "print divergence each dT");
  const bool pubulk   = args.getflag("-u",  "--ubulk",        "print ubulk each dT");
  const bool pUbulk   = args.getflag("-Up", "--Ubulk-print",  "print Ubulk each dT");
  const bool pdPdx    = args.getflag("-p",  "--pressure",     "print pressure gradient each dT");
  const Real umin     = args.getreal("-u",  "--umin",   0.0,  "stop if chebyNorm(u) < umin");
  const Real term     = args.getreal("-term",  "--terminate",   0.0,  "stop if L2Norm(u) < umin");
  //const bool hdf5out  = args.getflag("-h5",  "--hdf5",     "output fields as HDF5 files");
  const string uname  = args.getstr (1, "<flowfield>", "initial condition");

  args.check();
  args.save("./");
  args.save(outdir);
  mkdir(outdir);

  cout << "Constructing u,q, and optimizing FFTW..." << endl;
  FlowField u(uname);
  //u.optimizeFFTW(FFTW_MEASURE);

  const int Nx = u.Nx();
  const int Ny = u.Ny();
  const int Nz = u.Nz();
  const Real Lx = u.Lx();
  const Real Lz = u.Lz();
  const Real a = u.a();
  const Real b = u.b();
  //const Real h = (b-a)/2;

  FlowField q(Nx,Ny,Nz,1,Lx,Lz,a,b);
  TimeStep dt(dtarg, dtmin, dtmax, dT, CFLmin, CFLmax, vardt);
  if (adjustdT) {
    dt.adjust_for_T(T1-T0, true);
    cout << setprecision(16);
    cout << "Adjusting time steps to evenly divide T1-T0:\n";
    cout << "dt == " << dt.dt() << endl;
    cout << "dT == " << dt.dT() << endl;
    cout << setprecision(6);    
  }
  dT = dt.dT();

  const bool inttime = (abs(dT - int(dT)) < 1e-12) && (abs(T0 - int(T0)) < 1e-12) ? true : false;
  
  SymmetryList symms;
  if (symmstr.length() > 0) {
    symms = SymmetryList(symmstr);
    cout << "Restricting flow to invariant subspace generated by symmetries" << endl;
    cout << symms << endl;
  }
  
  cout << "Uwall == " << Uwall << endl;
  cout << "theta == " << theta << endl;

  //VelocityScale vscale = s2velocityscale(velstr);
  
  // Construct time-stepping algorithm
  DNSFlags flags;
  flags.initstepping = s2stepmethod(initstr);
  flags.timestepping = s2stepmethod(stepstr);
  flags.nonlinearity = s2nonlmethod(nonlstr);
  flags.constraint   = s2constraint(meanstr);
  flags.baseflow     = s2baseflow(basestr);
  flags.dealiasing   = dealias ? DealiasXZ : NoDealiasing;
  flags.ulowerwall   = -Uwall*cos(theta);
  flags.uupperwall   =  Uwall*cos(theta);
  flags.wlowerwall   = -Uwall*sin(theta);
  flags.wupperwall   =  Uwall*sin(theta);
  flags.nu           = (nuarg != 0) ? nuarg : 1.0/Reynolds;
  flags.dPdx         = dPdx;
  flags.dPdz         = dPdz;
  flags.Ubulk        = Ubulk;
  flags.Wbulk        = Wbulk;
  flags.t0           = T0;
  flags.dt           = dt;

  cout << "dnsflags == " << flags << endl;
  if (symmstr.length() > 0) {
    SymmetryList symms(symmstr);
    cout << "Restricting flow to invariant subspace generated by symmetries" << endl;
    cout << symms << endl;
    flags.symmetries = symms;
  }
  flags.save("dnsflags");

  cout << "constructing DNS..." << endl;
  DNS dns(u, flags);
  u.setnu(flags.nu);

  dns.Ubase().save(outdir + "Ubase");
  dns.Wbase().save(outdir + "Wbase");

  ChebyCoeff Ubase =  laminarProfile(flags.nu, flags.constraint, flags.dPdx, flags.Ubulk, 
				     u.a(), u.b(), flags.ulowerwall, flags.uupperwall, u.Ny());
  int saveCounter = 0;
  for (Real t=T0; t<=T1+dT/2; t += dT) { // just to make sure t==T1 is computed

    printdiagnostics(u, dns, t, dt, flags.nu, umin, term, vardt, pl2norm, pchnorm, pdissip,
		     pshear, pdiverge, pUbulk, pubulk, pdPdx, pcfl);

    if(saveCounter % iround(sF) == 0){
      cout << "Saving u("<<t<<") to disk" << endl;
      u.save(outdir + label + t2s(t, inttime));
    }
    if (savep)
      q.save(outdir + "p" + t2s(t, inttime));      

    dns.advance(u, q, dt.n());

    if (vardt && dt.adjust(dns.CFL()))
      dns.reset_dt(dt);
    saveCounter++;
  }
  cout << "Couette completed integrationn sucessfully at time t = " << T1 << endl;
}

void printdiagnostics(FlowField& u, const DNS& dns, Real t, const TimeStep& dt, Real nu,
		      Real umin, Real term, bool vardt, bool pl2norm, bool pchnorm, bool pdissip, bool pshear,
		      bool pdiverge, bool pUbulk, bool pubulk, bool pdPdx, bool pcfl) {

    // Printing diagnostics
    cout << "           t == " << t << endl;
    if (vardt)    cout << "          dt == " << Real(dt) << endl;
    if (pl2norm)  cout << "   L2Norm(u) == " << L2Norm(u) << endl;

    if (pchnorm || umin !=0.0) {
      Real chnorm = chebyNorm(u);
      cout << "chebyNorm(u) == " << chnorm << endl;
      if (chnorm < umin) {
	cout << "Exiting: chebyNorm(u) < umin." << endl;
	exit(0);
      }
      if (L2Norm(u) < term){
	cout << "Exiting: L2Norm(u) < term at time t = " << t << endl;
	exit(0);
      }
    }
    Real h = 0.5*(u.b()-u.a());
    u += dns.Ubase();
    if (pl2norm)  cout << "   energy(u+U) == " << 0.5*L2Norm(u) << endl;
    if (pdissip)  cout << "   dissip(u+U) == " << dissipation(u) << endl;
    if (pshear)   cout << "wallshear(u+U) == " << abs(wallshearLower(u)) + abs(wallshearUpper(u)) << endl;
    if (pdiverge) cout << "  divNorm(u+U) == " << divNorm(u) << endl;
    if (pUbulk)   cout << "mean u+U Ubulk == " << dns.Ubulk() << endl;
    u -= dns.Ubase();
    if (pubulk)   cout << "         ubulk == " << Re(u.profile(0,0,0)).mean() << endl;
    if (pdPdx)    cout << "          dPdx == " << dns.dPdx() << endl;
    if (pl2norm)  cout << "     L2Norm(u) == " << L2Norm(u) << endl;
    if (pl2norm)  cout << "   L2Norm3d(u) == " << L2Norm3d(u) << endl;
    
    ChebyCoeff U = dns.Ubase();
    ChebyCoeff W = dns.Wbase();
    
    U.makeSpectral();
    U += Re(u.profile(0,0,0));
    Real Ucenter = U.eval(0.5*(u.a() + u.b()));
    Real Uwall   = pythag(0.5*(U.eval_b() - U.eval_a()), 0.5*(W.eval_b() - W.eval_a()));
    Real Umean   = U.mean();
    cout << "        1/nu == " << 1/nu << endl;
    cout << "  Uwall h/nu == " << Uwall*h/nu << endl;
    cout << "  Ubulk h/nu == " << dns.Ubulk()*h/nu << endl;
    cout << "  Umean h/nu == " << Umean*h/nu << endl;
    cout << " Uparab h/nu == " << 1.5*dns.Ubulk()*h/nu << endl;
    cout << "Ucenter h/nu == " << Ucenter*h/nu << endl;
    cout << "         CFL == " << dns.CFL() << endl;
}

/* couette.cpp: time-integration class for spectral Navier-Stokes simulator
 * channelflow-1.1
 *
 * Copyright (C) 2001-2009  John F. Gibson
 *
 * gibson@cns.physics.gatech.edu  johnfgibson@gmail.com
 *
 * Center for Nonlinear Science
 * School of Physics
 * Georgia Institute of Technology
 * Atlanta, GA 30332-0430
 * 404 385 2509
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, U
 */
