function vortframe(vort_yz, magn, y,z,  ystride, zstride)

if (nargin < 5); ystride = 1; end;
if (nargin < 6); zstride = 1; end;

ny2 = 1:ystride:length(y);
nz2 = 1:zstride:length(z);
y2=y(ny2);
z2=z(nz2);
  
%magn = max(max(abs(vort_yz)));
vortlim = [-magn: magn/10: magn];
vort_yz = scrunch(vort_yz, -magn, magn);
[C,h] = contourf(z, y, vort_yz, vortlim); 
set(h, 'LineStyle', 'none');
axis xy;
%axis tight
axis([min(z) max(z) min(y) max(y)]);
caxis([-magn magn]);
  
xlabel('z');
ylabel('y');
miny = fixdigits(min(y), 3);
maxy = fixdigits(max(y), 3);
minz = fixdigits(min(z), 3);
maxz = fixdigits(max(z), 3);

set(gca, 'YTick', [miny maxy]);
set(gca, 'XTick', [minz maxz]);
