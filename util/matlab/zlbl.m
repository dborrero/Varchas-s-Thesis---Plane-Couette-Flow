function f = zlbl(s, fs);
% zlbl(string, fontsize)

if nargin < 2
  fs = 16;
end

  zlabel(s, 'FontSize', fs);



