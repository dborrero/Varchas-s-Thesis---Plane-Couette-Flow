function makeavi(F0, dF, F1, T0, dT, fps, moviename);
% function makeavi(F0, dF, F1, T0, dT, fps, moviename);
%   make an AVI animation from slices of velocity fields
%
%   F0 : initial frame number
%   dF : increment for frame number
%   F1 : final frame number
%   T0 : initial time
%   dT : time increment between frames
%  fps : frames per second
%  moviename : AVI filename
%
% convert to MPEG by running (vbitrate=3200 hi-res, 800 lo-res)
%
%   mencoder couette.avi -of mpeg -ovc lavc -lavcopts vcodec=mpeg2video:vbitrate=3200 -o couette.mpg

% The Linux utility mencoder can convert the AVI file to a compressed MPEG
% You might need to install w32codecs for this to work.

load x.asc
load y.asc
load z.asc

savemovie=true;
%fps = 10;

Nx = length(x);
Nz = length(z);

umag = 1.05;
ulim = [-umag:umag/30:umag];

vmag = 0.6;
vlim = [-vmag:vmag/5:vmag];

omag = 1.5;
olim = [-omag:omag/5:omag];

dmag = 6.0;


U_yz = y * ones(1,Nz);
Ny = length(y);

if (savemovie)
  aviobj = avifile(moviename, 'fps', fps);
else
  clear avifile;
end

xmax = max(x);
xmin = min(x);
ymax = max(y);
ymin = min(y);
zmax = max(z);
zmin = min(z);


basedrag = ones(Nx, Nz);

fps

for f = F0:dF:F1
  t = T0 + (f-F0)*dT;
  fs = num2str(f);
  ts = num2str(t,'%0.1f');
  
  u_yz = load(strcat('u', fs, '_u_yz.asc'));
  v_yz = load(strcat('u', fs, '_v_yz.asc'));
  w_yz = load(strcat('u', fs, '_w_yz.asc'));

  vort_yz = load(strcat('u', fs, '_vort_yz.asc'));
  %drag_xz = load(strcat('u', fs, '_drag_xz.asc'));

  subplot(221);
  yzframe(U_yz + u_yz, v_yz, w_yz, umag, y, z);
  %title(strcat('velocity t = ', ts, ' f = ', num2str(f-F0)));
  title(strcat('velocity t = ', ts));
  
  subplot(223);
  %vort_yz = vort_yz, omag);
  vortframe(vort_yz, omag, y, z);
  title('vorticity');
  
  subplot(122)
  u_xz = load(strcat('u', fs, '_u_xz.asc'));
  v_xz = load(strcat('u', fs, '_v_xz.asc'));
  w_xz = load(strcat('u', fs, '_w_xz.asc'));
  zxframe(u_xz, v_xz, w_xz, 2/3 * umag, x, z, 2, 2);
  title('midplane velocity')
  
  %subplot(133)
  %dragframe(basedrag+drag_xz, dmag, x, z);
  %title('upper wall drag')
  
  
  if (savemovie)
    frame = getframe(gcf);
    aviobj = addframe(aviobj, frame);
  end

  if (f == F0 | f == F1)
    print -depsc strcat('frame', num2str(f), '.eps')
  end

  pause(0.01);
end

aviobj = close(aviobj);


