function boxframe(x,y,z, u_yz, v_yz, w_yz, u_xy, v_xy, u_xz, w_xz, xstride, ystride, zstride, baseflow, quivscale, perspect)
% function boxframe(x,y,z, u_yz, v_yz, w_yz, u_xy, v_xy, u_xz, w_xz,
%                   xstride, ystride, zstride, baseflow, quivscale, perspect)
% plot a 3D plane Couette velocity field
% x,y,z       : vectors containing x,y,z coordinates of gridpoints
% u_yz etc    : files of [u,v,w] in y,z  x,z  x,y planes
% xstride     : make quiver plots using every xstride-th etc datapoint
% ystride     :
% zstride     :
% Mx          : show Mx copies of cell in x
% Mz          : show Mz copies of cell in z
% baseflow    : 1 add plane Couette base flow U = y \hat{x} to u, 0 don't
% quivscale   : 1 allow matlab to rescale; 0 don't (default 0)
% perspect    : 1 use perspective plot, 0 orthographic (default 1)
% framedir    : directory for u_yz etc data (default to current dir).

if nargin < 17 ; framedir = ''; end;
if nargin < 16 ; perspect  = 1; end;
if nargin < 15 ; quivscale = 0; end;
if nargin < 14 ; baseflow = 1; end;
if nargin < 13 ; zstride = 2; end
if nargin < 12 ; ystride = 2; end
if nargin < 11 ; xstride = 2; end

Nx = length(x);
Ny = length(y);
Nz = length(z);
umag = 1.05;
scrunchlevel = 1.0;

% on entering,
% *_yz : (i,j) elem is at (yi,zj)
% *_xz : (i,j) elem is at (xj,zi)
% *_xy : (i,j) elem is at (xj,yi)

%U_yz = (1-y.*y) * ones(1,Nz);
%U_xy = (1-y.*y) * ones(1,Nx);
%U_yz = zeros(Ny,Nz);
%U_xy = zeros(Ny,Nx);

if baseflow == 1
  U_yz = y * ones(1,Nz);
  U_xy = y * ones(1,Nx);
  u_yx = scrunch(u_xy' + U_xy', scrunchlevel);
  u_yz = scrunch(u_yz  + U_yz, scrunchlevel);
else
  u_yx = scrunch(u_xy', scrunchlevel);
  u_yz = scrunch(u_yz,  scrunchlevel);
end
u_xz = scrunch(u_xz', scrunchlevel);
v_yx = v_xy';
w_xz = w_xz';

% but transposing and renaming now results in
% *_xz : (i,j) elem is at (xi,zj)
% *_yx : (i,j) elem is at (xi,yj)
% *_yz : (i,j) elem is at (yi,zj)

% These magical factors undo Matlab's autoscaling of vectors in quiver plots,
% so that lengths of quivers convey magnitude of the vector fields, with the same
% scaling from plot to plot. The denominators were chosen so that a characteristic
% roll-streak structure in the HKW box looks good.
if quivscale == 1
  uwscale = 3*sqrt(max(max(u_xz.*u_xz + w_xz.*w_xz)));
  vwscale = 12*sqrt(max(max(v_yz.*v_yz + w_yz.*w_yz)));
elseif quivscale == 0
  uwscale = 0;
  vwscale = 0;
else
  uwscale = quivscale;
  vwscale = quivscale;
end


% if u fields are identically zero add a tiny bit of fuzz to make contourf plots behave
if max(max(abs(u_xz))) < 1e-13
 [X,Z] = meshgrid(x,z);
 u_xz = u_xz + 1e-12*X.*Z;
end
if max(max(abs(u_yz))) < 1e-13
 [Y,Z] = meshgrid(y,z);
 u_yz = u_yz + 1e-12*Y.*Z;
end
if max(max(abs(u_yx))) < 1e-13
 [Y,X] = meshgrid(y,x);
 u_yx = u_yx + 1e-12*Y.*X;
end

%if max(max(abs(u_yz))) < 1e-13
% [Y,Z] = meshgrid(y,z);
% u_yz = u_yz + 1e-12*Y.*Z;
%end
%if max(max(abs(u_xy))) < 1e-13
%[X,Y] = meshgrid(x,y);
% u_xy = u_xy + 1e-12*X.*Y;
%end


nx2 = 1:xstride:length(x);
ny2 = 2:ystride:length(y)-1;
nz2 = 1:zstride:length(z);
x2=x(nx2);
y2=y(ny2);
z2=z(nz2);

xaxis = [1 0 0];
yaxis = [0 1 0];
zaxis = [0 0 1];
cax = [-umag, umag];
%ulim = [-2*umag:umag/15:umag*2];
%ulim = [-2*umag:umag/5:umag*2];
ulim = [-2*umag:umag/15:umag*2];

%cax = [-1 1];
origin = [0 0 0];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yz-plane cross-section velocity


hold off

nz2a = 2:zstride:length(z)-1;
z2a=z(nz2a);
if vwscale == 0
  h = quiver('v6',z2a, y2, w_yz(ny2,nz2a), v_yz(ny2,nz2a), 'k');
else
  h = quiver('v6',z2a, y2, w_yz(ny2,nz2a), v_yz(ny2,nz2a), vwscale, 'k');
end
rotate(h, xaxis, 90, [0 0 0]);
hold on
view(3)

[C,h] = contourf('v6',z,y, u_yz, ulim);
caxis(cax);
set(h, 'LineStyle', 'none');
rotate(h, xaxis, 90, [0 0 0])

nyHi = 1:ystride:((Ny-1)/2+1);
yHi=y(nyHi);

if vwscale == 0
  h = quiver('v6',z2a,yHi+max(x), w_yz(nyHi,nz2a), v_yz(nyHi,nz2a), 'k');
else
  h = quiver('v6',z2a,yHi+max(x), w_yz(nyHi,nz2a), v_yz(nyHi,nz2a), vwscale, 'k');
end
rotate(h, xaxis, 90, [0 max(x) 0])

nyHi = 1:1:((Ny-1)/2+1);
yHi=y(nyHi);
[C,h] = contourf('v6',z, yHi+max(x), u_yz(nyHi,:), ulim);
caxis(cax);
set(h, 'LineStyle', 'none');
rotate(h, xaxis, 90, [0 max(x) 0])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xy-plane vertical slice


nyHi = 5:ystride:((Ny-1)/2+1);
yHi=y(nyHi);
nx2a = 1:xstride:length(x)-xstride;
x2a=x(nx2a);

% no need to rescale xy quiver plots becuase they have unit vector at y=+-1
h = quiver('v6',yHi,x2a, v_yx(nx2a,nyHi), u_yx(nx2a,nyHi), 'k');
rotate(h, yaxis, -90, [0 0 0])

nyHi = 1:1:((Ny-1)/2+1);
yHi=y(nyHi);
[C,h] = contourf('v6', yHi, x, u_yx(:,nyHi), ulim);
caxis(cax);
set(h, 'LineStyle', 'none');
rotate(h, yaxis, -90, [0 0 0])

nyLo = ((Ny-1)/2+1):ystride:Ny-5;
yLo=y(nyLo);
nx2a = xstride:xstride:length(x);
x2a=x(nx2a);

h = quiver('v6',yLo + max(z),x2a, v_yx(nx2a,nyLo), u_yx(nx2a,nyLo), 'k');
rotate(h, yaxis, -90, [max(z) 0 0])

nyLo = ((Ny-1)/2+1):Ny;
yLo=y(nyLo);
[C,h] = contourf('v6', yLo+max(z), x, u_yx(:,nyLo), ulim);
set(h, 'LineStyle', 'none');
rotate(h, yaxis, -90, [max(z) 0 0])





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xz-plane midplane velocity

nz3 = 2:zstride:Nz-1;
nx3 = 5:xstride:Nx-1;
x3 = x(nx3);
z3 = z(nz3);
if uwscale == 0
  quiver('v6',z3,x3, w_xz(nx3,nz3), u_xz(nx3,nz3), 'k');
else
  quiver('v6',z3,x3, w_xz(nx3,nz3), u_xz(nx3,nz3), uwscale, 'k');
end

%u_xzI = interp2(z3,x3,u_xz(nx3,nz3), z3,x3');
[C,h] = contourf(z, x, u_xz, ulim);
caxis(cax);
set(h, 'LineStyle', 'none');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Axes anesthesist barbeque
ep = 0.001;

% Box edges in box-x or Y-matlab
plot3([max(z) max(z)], [0 max(x)], [0 0], 'k-');
plot3([0 0],           [0 max(x)], [0 0], 'k-');
plot3([0 0],          [0 max(x)], [1+ep 1+ep], 'k-');

% Box edges in box-z
plot3([0 max(z)], [0 0],           [1 1], 'k-');
plot3([0 max(z)], [max(x) max(x)], [0 0], 'k-');
plot3([0 max(z)], [max(x) max(x)], [1 1], 'k-');
plot3([0 max(z)], [max(x) max(x)], [0 0], 'k-');

% Vertical lines, along y-box or Z-matlab
plot3([0 0], [max(x)+ep max(x)+ep], [0 1], 'k-');
plot3([max(z), max(z)], [max(x)-ep, max(x)-ep], [-1 1], 'k-');
plot3([max(z)-ep, max(z)-ep], [0 0], [-1 1], 'k-');

minx = fixdigits(min(x),2);
maxx = fixdigits(max(x),2);
miny = fixdigits(min(y),2);
maxy = fixdigits(max(y),2);
minz = fixdigits(min(z),2);
maxz = fixdigits(max(z),2);


%xlbl('z',24);
%ylbl('x',24);
%zlbl('y',24);

%text(-.01*max(x), -0.6, 0.25, 'y', 'fontsize', 8);
%text(max(z)/2,-0.7, -1, 'z', 'fontsize', 8);
%text(1.1*max(z), max(x)/2, -1, 'x', 'fontsize', 8);

%text(-0.06*max(z), -0.05*max(x), -0*max(y), 'y');
%text(max(z)/2, -0.13*max(x), -1, 'z');
%text(1.1*max(z), 0.5*max(x), -1, 'x');

% z x y
%text(-0.06*max(z), -0.02*max(x), 0, 'y', 'fontsize', 20);
%text(max(z)/2, -0.1*max(x), -1, 'z', 'fontsize', 20);
%text(1.1*max(z), 0.5*max(x), -1, 'x', 'fontsize', 20);


%set(gca, 'XTick', [minz maxz]);
%set(gca, 'YTick', [minx maxx]);
%set(gca, 'ZTick', [miny maxy]);

set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca, 'ZTick', []);
bigfont(10)

axis tight
axis equal
axis([min(z) max(z) min(x) max(x) min(y) max(y)]);
box off
hold off;

%view([42, 23]);
%view([31, 32]);
%view([24.5, 34]);
%view([36, 26]);
%view([35, 30]);
%view([18, 25]);
%view([36, 25]);
%view([29, 24]);
view([32, 25]);

%view([40, 25]);

%view([42, 27]);

if perspect == 1
  set(gca, 'Projection', 'Perspective');
end;
alpha(1);