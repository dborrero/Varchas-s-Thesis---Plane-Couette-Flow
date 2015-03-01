function [z,x,y,u] = load3hdf5(filename);
% [z,x,y,u] = load3hdf5(filename);
% returns vectors in order z,x,y and u indexed as u[x,z,y,i] because
% that works with matlab slice(z,x,y,u,[0,Lz],[0,Lx],[-1 0]

data = hdf5read(filename, '/data/u');

Lx = hdf5read(filename,'/','Lx');
Lz = hdf5read(filename,'/','Lz');
ya = hdf5read(filename,'/','a');
yb = hdf5read(filename,'/','b');

% If we don't cast ints to doubles, matlab messes up later calculations
% like x = (0:Nx)*Lx/Nx;, apparently do mults as floats but then casts
% back to ints when storing in x. WTF??
Nx = double(hdf5read(filename,'/','Nx'));
Ny = double(hdf5read(filename,'/','Ny'));
Nz = double(hdf5read(filename,'/','Nz'));
Nd = double(hdf5read(filename,'/','Nd'));


% Don't get Nx,Ny,Nz this way. A bug in chflow hdf5save saved the dims in the 
% wrong order. Fixed the bug 2011-12-23, fields saved after that should be ok.
% [Nz,Ny,Nx,Nd] = size(data);

% Prior to 2011-12-23, data was mistakenly saved with dims = [Nz,Ny,Nx,Nd].
% Reshape to correct form dims = [Nz,Ny,Nx,Nd]. Will be no-op for correct shape.

data = reshape(data, Nz, Ny, Nx, Nd);
data = permute(data, [3 2 1 4]);

% For plotting, want to extend data all the way to end of periodic domain,
% by repeating the first (zeroth) element as the last, for both x and z. 
% So extend x from length Nx to length Nx+1, same for z, and allocate u.

x = (0:Nx)*Lx/Nx;
z = (0:Nz)*Lz/Nz;
y = (ya+yb)/2 + (yb-ya)/2 * cos((0:Ny-1)*pi/(Ny-1));

% There are two crazy ordering issues that require permutation, and the
% combination is totally confusing. First Matlab's 3d plotting functions
% like slice(x,y,z, u) require u to have indices in order u(1:Ny, 1:Nx, 1:Nz)
% So we need to permute indices of v from [x,y,z,i] to [y,x,z,i].

% However, these functions plot x,y on horizontal and z on vertical. 
% and we want z,x on horizontal and y on vertical. So that calls for 
% and additional permutation (x,y,z) -> (z,x,y) or, on indices of v 
% from [y,x,z,i] to [x,z,y,i]. So the total perumation of indices on
% u is [x,y,z,i] to [x,z,y,i]. 

% Allocate u for shape [x,z,y,i] with 1 point expansion in x and z
u = zeros(Nx+1, Ny, Nz+1, Nd);

% Permute data from order [x,y,z,i] to [x,z,y,i] and fill
u(1:Nx,:,1:Nz,:) = data;

% Repeat (0,z,y) (nx=1) plane as (Lx,z,y) (nx=Nx+1) plane 
u(Nx+1,:,:,:) = u(1,:,:,:);

% Repeat (x,0,y) (nz=1) plane as (x,Lz,y) (nz=Nz+1) plane
u(:,:,Nz+1,:) = u(:,:,1,:);

% Permute from [x,y,z,i] to  [x,z,y,i]
u = permute(u, [1 3 2 4]);


% Matlab wants u indices ordered as [y,x,z,i] for plotting
% Permute accordingly, from [x,y,z,i] to [y,x,z,i]

%u = permute(u, [2 1 3 4]);

% And then. matlab likes to plot x,y horizontal and z vertical, 
% contrary to fluid channel notation where x,z, is horizontal
% and y vertical. So permute (x,y,z,i) -> (z,x,y,i), or
% [y,x,z,i] -> [x,z,y,i]

%u = permute(u, [2, 3, 1, 4]);
return 

