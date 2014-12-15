function plotbox(label, xstride, ystride, zstride, baseflow, quivscale, perspect, scale, Mx, Mz, framedir);
% plotbox(label, xstride, ystride, zstride, baseflow, quivscale, perspect, scale, Mx, Mz, framedir);
%   plot velocity field in a 3D box
%   label    : filename base as produced by 'fieldplots.x' or 'movieframes.x'
%   xstride  : granularity for quiver plot, defaults to 2
%   ystride  : ditto
%   zstride  : ditto
%   baseflow : add laminar base flow before plotting, default 1 (true)
%   quivscale: let matlab rescale quiver plot, default 0 (false)
%   perspect : 0 for orthographic, 1 for perspective, default 1
%   scale    : rescale velocity field by this factor
%   Mx       : repeat cell Mx times in x
%   Mz       : repeat cell Mz times in z
%   framedir : directory containing frame data (slices of fields), default = .

if nargin < 11; framedir = ''; end
if nargin < 10; Mz = 1; end
if nargin < 9;  Mx = 1; end
if nargin < 8;  scale = 1; end
if nargin < 7;  perspect = 0; end
if nargin < 6;  quivscale = 0; end
if nargin < 5;  baseflow = 1; end
if nargin < 4;  zstride = 2; end
if nargin < 3;  ystride = 2; end
if nargin < 2;  xstride = 2; end
if nargin < 1;  label = 'u'; end

set(gcf, 'renderer', 'opengl');
%set(gcf, 'renderer', 'zbuffer');

x = load(strcat(framedir,'x.asc'));
y = load(strcat(framedir,'y.asc'));
z = load(strcat(framedir,'z.asc'));

u_xy = scale*load(strcat(framedir, label, '_u_xy.asc'));
v_xy = scale*load(strcat(framedir, label, '_v_xy.asc'));
u_yz = scale*load(strcat(framedir, label, '_u_yz.asc'));
v_yz = scale*load(strcat(framedir, label, '_v_yz.asc'));
w_yz = scale*load(strcat(framedir, label, '_w_yz.asc'));
u_xz = scale*load(strcat(framedir, label, '_u_xz.asc'));
w_xz = scale*load(strcat(framedir, label, '_w_xz.asc'));

[x2, z2, u_xy2, v_xy2, u_yz2, v_yz2, w_yz2, u_xz2, w_xz2] = multibox(Mx,Mz, x, z, u_xy, v_xy, u_yz, v_yz, w_yz, u_xz, w_xz);

boxframe(x2,y,z2, u_yz2, v_yz2, w_yz2, u_xy2, v_xy2, u_xz2, w_xz2, xstride, ystride,zstride, baseflow, quivscale, perspect);


if (Mx>1 | Mz>1)

  Lx = max(x);
  Lz = max(z);
  set(gca, 'ytick', [0:Lx:Mx*Lx]);
  set(gca, 'xtick', [0:Lz:Mz*Lz]);
  set(gca, 'xticklabel', '');
  set(gca, 'yticklabel', '');

  %MLz = (Mz-1)*Lz;
%  lw = 'linewidth';
%   w = 1.15;
%   hold on
%   plot3([MLz MLz], [Lx Lx], [1 -1], 'k-', lw, w);
%   plot3([MLz MLz], [0  0], [1 -1], 'k-', lw, w);
%   plot3([Mz*Lz Mz*Lz], [Lx Lx], [1 -1], 'k-', lw, w);

%   plot3([MLz MLz], [0  Lx], [1 1], 'k-', lw, w);
%   plot3([MLz Mz*Lz], [Lx Lx], [1 1], 'k-', lw, w);
%   plot3([Mz*Lz Mz*Lz], [0 Lx], [1 1], 'k-', lw, w);

end