function zxframe(u_xz, v_xz, w_xz, umag, x,z, xstride, zstride)

  if (nargin < 7)
    xstride = 1;
  end
  if (nargin < 8)
    zstride = 2;
  end

  u_xz = u_xz';
  v_xz = v_xz';
  w_xz = w_xz';

  ulim = [-umag: umag/10: umag];
  [C,h] = contourf(z, x, u_xz, ulim); 
  set(h, 'LineStyle', 'none');
  hold on

  axis xy;
  %axis tight
  
  nx2 = 1:xstride:length(x);
  nz2 = 1:zstride:length(z);
  x2=x(nx2);
  z2=z(nz2);
  %quiver(z2, x2, w_xz(nx2,nz2), u_xz(nx2,nz2), 0, 'k'); 
  quiver(z2,x2, w_xz(nx2,nz2), u_xz(nx2,nz2), 'k'); 
  caxis([-umag umag]);
  
  minx = fixdigits(min(x), 3);
  maxx = fixdigits(max(x), 3);
  minz = fixdigits(min(z), 3);
  maxz = fixdigits(max(z), 3);
  axis([minz maxz minx maxx]);

  hold off;
  
  xlabel('z');
  ylabel('x');
  
  set(gca, 'YTick', [minx maxx]);
  set(gca, 'XTick', [minz maxz]);
  %t = frame * dt;
  %title(strcat('t=', num2str(t,2)));
  %axis equal;

