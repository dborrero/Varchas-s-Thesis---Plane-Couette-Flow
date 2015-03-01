function plotfields(label, indices, baseflow, scale, xstride, ystride, zstride)
% plotfields(label, indices, baseflow, scale, xstride, ystride, zstride)

if nargin < 3, baseflow = 0; end;
if nargin < 4, scale    = 1; end;
if nargin < 5, xstride  = 2; end;
if nargin < 6, ystride  = 2; end;
if nargin < 7, zstride  = 2; end;

printme = 1;

for n=indices 
  clf;
  plotfield(strcat(label, n2s(n)), printme, baseflow, ...
	    scale, xstride, ystride, zstride);
  clf;
  plotspectra(strcat(label, n2s(n)), printme, -6.1);
  
end
  