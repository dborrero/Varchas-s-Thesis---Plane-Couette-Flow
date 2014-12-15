function f = ylbl(s, fs);
% ylbl(string, fontsize)

if nargin < 2
  fs = 16;
  
end

ylabel(s, 'FontSize', fs);

