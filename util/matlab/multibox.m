function [x, z, u_xy, v_xy, u_yz, v_yz, w_yz, u_xz, w_xz] = multibox(Mx,Mz, x, z, u_xy, v_xy, u_yz, v_yz, w_yz, u_xz, w_xz);

% _xz files vary in z along rows and x along columns
% _xy files vary in y along rows and x along columns
% _yz files vary in y along rows and z along columns

if (Mx > 1)
  Nx  = length(x);
  Nx2 = Mx*(Nx-1)+1;
  Lx = x(Nx)-x(1);
  Lx2 = Mx*Lx;
  x  = min(x) + (0:(Nx2-1))*Lx2/(Nx2-1);
  u_xy = multicol(Mx, u_xy);
  v_xy = multicol(Mx, v_xy);
  u_xz = multicol(Mx, u_xz);
  w_xz = multicol(Mx, w_xz);
end

if (Mz > 1)
  Nz  = length(z);
  Nz2 = Mz*(Nz-1)+1;
  Lz = z(Nz)-z(1);
  Lz2 = Mz*Lz;
  z  = min(z) + (0:(Nz2-1))*Lz2/(Nz2-1);
  u_yz = multicol(Mz, u_yz);
  v_yz = multicol(Mz, v_yz);
  w_yz = multicol(Mz, w_yz);
  u_xz = multirow(Mz, u_xz);
  w_xz = multirow(Mz, w_xz);
end
