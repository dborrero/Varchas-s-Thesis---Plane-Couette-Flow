function f = ttl(s, fs);
% ttl(string, fontsize)
if nargin < 2
  fs = 16;
end

title(s, 'FontSize', fs);
