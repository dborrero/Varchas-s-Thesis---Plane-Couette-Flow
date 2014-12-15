function bigfont(fs); 

if nargin <1
  fs = 16;
end

set(gca, 'FontSize', fs)