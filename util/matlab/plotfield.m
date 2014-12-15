function plotfield(label, printme, baseflow, scale,xstride,ystride,zstride)
% plotfield(label, printme, baseflow, scale, xstride, ystride, zstride)

if nargin < 1, label = ''; end;
if nargin < 2, printme = 0; end
if nargin < 3, baseflow = 1; end;
if nargin < 4, scale = 1; end;
if nargin < 5, xstride = 2; end;
if nargin < 6, ystride = 2; end;
if nargin < 7, zstride = 2; end;

if length(label) > 0 
  label = strcat(label, '_');
end

load x.asc;
load y.asc;
load z.asc;

u_xz =  load(strcat(label, 'u_xz.asc'));
v_xz =  load(strcat(label, 'v_xz.asc'));
w_xz =  load(strcat(label, 'w_xz.asc'));
o_yz =  load(strcat(label, 'vort_yz.asc'));
u_yz =  load(strcat(label, 'u_yz.asc'));
v_yz =  load(strcat(label, 'v_yz.asc'));
w_yz =  load(strcat(label, 'w_yz.asc'));

% u_xz =  load('u_xz.asc');
% v_xz =  load('v_xz.asc');
% w_xz =  load('w_xz.asc');
% o_yz =  load('vort_yz.asc');
% u_yz =  load('u_yz.asc');
% v_yz =  load('v_yz.asc');
% w_yz =  load('w_yz.asc');

if baseflow ~= 0
  [Ny, Nz] = size(u_yz);
  U_yz = y * ones(1, Nz);
  %u_specy =  load(strcat(label, 'uspecy.asc'));
  u_yz = u_yz + U_yz;
end

if scale == 0
  scale = max(max(abs(u_yz)));
end

subplot(2,2,1, 'align');
%umag = max(max(abs(u_yz)));
umag = scale;
u_yz = scrunch(u_yz, -umag, umag);
yzframe(u_yz, v_yz, w_yz, umag, y,z, ystride, zstride);
xlbl('');
ylbl('y');
%axis equal
axis tight
axis([min(z) max(z) min(y) max(y)]);
ttl('cross-stream velocity');
bigfont

% Chebyshev spectrum plot
%subplot(224);
%hold off
%Ny = length(y);
%semilogy(0:2:Ny-1, u_specy(1,1:2:Ny), 'b.',...
%	 1:2:Ny-1, u_specy(1,2:2:Ny), 'r.');
%hold on
%semilogy(u_specy(2,:), 'r.');
%semilogy(u_specy(3,:), '.', 'Color', [0 0.7 0]);
%axis([0 length(y)+1 1e-10 1])
%xlbl('n')
%ylbl('|e_{0,0,ny}|');
%ttl('chebyshev spectrum')
%bigfont

% Vorticity plot
subplot(2,2,3, 'align');
%omag = max(max(abs(o_yz)));
omag = 1.5*scale;
o_yz = scrunch(o_yz, -omag, omag);
vortframe(o_yz, omag, y,z, 1,1);
xlbl('z');
ylbl('y');
%axis equal
axis tight
axis([min(z) max(z) min(y) max(y)]);
ttl('cross-stream vorticity');
bigfont

subplot(1,2,2,'align');
%umag = max(max(abs(u_xz)));
umag = scale;
u_xz = scrunch(u_xz, -umag, umag);
zxframe(u_xz, v_xz, w_xz, umag, x,z,xstride,zstride)
%axis equal
axis tight
axis([min(z) max(z) min(x) max(x)]);
xlbl('z');
ylbl('x');
ttl('midplane velocity');
bigfont

if printme ~= 0 
  print(gcf, '-depsc', strcat(label,'field.eps'));
end