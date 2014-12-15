function yzframe(u_yz, v_yz, w_yz, umag, y,z, ystride, zstride)
% 

  if (nargin < 7)
    ystride = 2;
  end
  if (nargin < 8)
    zstride = 2;
  end
    
  ulim = [-umag:umag/10:umag];
  [C,h] = contourf(z, y, u_yz, ulim); 
  set(h, 'LineStyle', 'none');
  hold on;
  %axis equal
  %axis tight
  %contourf(z, y, u_yz, ulim, 'g:'); 
  caxis([-umag umag]);
  axis([min(z) max(z) min(y) max(y)]);

  ny2 = 1:ystride:length(y);
  nz2 = 1:zstride:length(z);
  y2=y(ny2);
  z2=z(nz2);
  
  %quiver(z2,y2, w_yz(ny2,nz2), v_yz(ny2,nz2), 0, 'k'); 
  quiver(z2,y2, w_yz(ny2,nz2), v_yz(ny2,nz2), 'k'); 
  %plot([min(z) max(z)], [-0.7 -0.7], 'k-');
  hold off;
  %minz = fixdigits(min(z), 3);
  %maxz = fixdigits(max(z), 3);
  %miny = fixdigits(min(y), 3);
  %maxy = fixdigits(max(y), 3);
  minz = fixdigits(min(z));
  maxz = fixdigits(max(z));
  miny = fixdigits(min(y));
  maxy = fixdigits(max(y));
  
  xlabel('z');
  ylabel('y');
  set(gca, 'XTick', [minz maxz]);
  set(gca, 'YTick', [miny maxy]);
  %set(gca, 'XTick', []);
  %set(gca, 'YTick', []);
