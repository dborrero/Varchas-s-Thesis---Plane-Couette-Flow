load x.asc
load y.asc
load z.asc

savemovie=true;
moviename = 'couette.avi';
fps = 10;

Nx = length(x);
Nz = length(z);

umag = 1.05;
ulim = [-umag:umag/30:umag];

vmag = 0.6;
vlim = [-vmag:vmag/5:vmag];

omag = 2.5;
olim = [-omag:omag/5:omag];

dmag = 6.0;


T0 = 0;
dT = 0.82720565820370012;
T1 = 99*T0;

F0 = 1;
dF = 1;
F1 = 100;

U_yz = y * ones(1,Nz);
Ny = length(y);
ny2 = 1:2:Ny;

N = floor((F1-F0)/dF)+1;
if (savemovie)
  %aviobj = avifile(moviename, 'fps', fps);
  TheMovie = moviein(N);
else
  %clear avifile;
  clear TheMovie;
end

xmax = max(x);
xmin = min(x);
ymax = max(y);
ymin = min(y);
zmax = max(z);
zmin = min(z);


basedrag = ones(Nx, Nz);

for t = T0:dT:T1
  f = num2str(t);
  st = num2str(t);
  
  u_yz = load(strcat('u', f, '_u_yz.asc'));
  v_yz = load(strcat('u', f, '_v_yz.asc'));
  w_yz = load(strcat('u', f, '_w_yz.asc'));

  vort_yz = load(strcat('u', f, '_vort_yz.asc'));
  %drag_xz = load(strcat('u', f, '_drag_xz.asc'));

  subplot(221);
  yzframe(U_yz + u_yz, v_yz, w_yz, umag, y, z);
  title(strcat('velocity t = ', st));
  
  subplot(223);
  %vort_yz = vort_yz, omag);
  vortframe(vort_yz, omag, y, z);
  title('vorticity');
  
  subplot(122)
  u_xz = load(strcat('u', f, '_u_xz.asc'));
  v_xz = load(strcat('u', f, '_v_xz.asc'));
  w_xz = load(strcat('u', f, '_w_xz.asc'));
  zxframe(u_xz, v_xz, w_xz, 2/3 * umag, x, z, 2, 2);
  title('midplane velocity')
  
  %subplot(133)
  %dragframe(basedrag+drag_xz, dmag, x, z);
  %title('upper wall drag')
  
  
  n = t-T0+1;
  if (savemovie)
    %frame = getframe(gca);
    %aviobj = addframe(aviobj, frame);
    TheMovie(:,n) = getframe(gcf);
  end

  if t == T0
    print -depsc 'frame0.eps'
  end

  pause(0.01);
end

%aviobj = close(aviobj);

% plot xy slice, uv with quiver, w with color, 
% x horizonatal, y vertical
 repeat = 1;
 psearch = 0; 1 % 0,1,2
 bsearch = 1;  % 0,1,2
 refframe = 1;  % 0,1
 pixrange = 5; % >0
 ifqscale = 4; % 1-31
 pfqscale = 5;  % 1-31
 bfqscale = 12;  % 1-31

 options = [repeat, psearch, bsearch, refframe, pixrange, ifqscale, pfqscale, bfqscale];

%mpgwrite(TheMovie, jet, 'couette.mpg',options);

