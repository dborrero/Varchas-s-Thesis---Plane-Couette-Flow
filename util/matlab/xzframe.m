function xzframe(u_xz, v_xz, w_xz, umag, x,z)

  ulim = [-umag: umag/10: umag];
  [C,h] = contourf(x, z, u_xz, ulim); 
  set(h, 'LineStyle', 'none');
  hold on

  axis ij;
  %axis tight
  
  nx2 = 1:8:length(x);
  nz2 = 1:8:length(z);
  x2=x(nx2);
  z2=z(nz2);
  quiver(x2, z2, u_xz(nz2,nx2), w_xz(nz2,nx2), 0.5, 'k'); 
  %quiver(z2,x2, w_xz(nx2,nz2), u_xz(nx2,nz2), 'k'); 
  axis([min(x) max(x) min(z) max(z)]);
  caxis([-umag umag]);
  
  hold off;
  
  %xlabel('x');
  %ylabel('z');
  
  minx = fixdigits(min(x), 3);
  maxx = fixdigits(max(x), 3);
  minz = fixdigits(min(z), 3);
  maxz = fixdigits(max(z), 3);
  
  set(gca, 'XTick', [minx maxx]);
  set(gca, 'YTick', [minz maxz]);
  %t = frame * dt;
  %title(strcat('t=', num2str(t,2)));
  %axis equal;

