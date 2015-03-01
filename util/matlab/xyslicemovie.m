function xyslicemovie(t0, t1, smag)

uname = strcat('u',n2s(t0),'.h5');
[z,x,y,u] = loadhdf5(uname);

load Ubase.asc

% u is in order x,z,y,i

if nargin < 3; smag = 0.2; end

for n = t0:1:t1
  n
  uname = strcat('u',n2s(n),'.h5');
  [z,x,y,u] = loadhdf5(uname);
  Nx = length(x);  

  Nz2 = (length(z)-1)/2 + 1;
  %Ub = Ubase * ones(1,Nx);


  U = squeeze(u(:,Nz2,:,1))';
  V = squeeze(u(:,Nz2,:,2))';

  quiver(x,y, U, V)
  axis([0 max(x) min(y) max(y)])
  axis tight
  pause(0.5);
end;
