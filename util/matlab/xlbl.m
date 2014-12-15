function f = xlbl(s, fs);
% xlbl(string, fontsize)

if nargin < 2
  fs = 16;
end

  xlabel(s, 'FontSize', fs);



