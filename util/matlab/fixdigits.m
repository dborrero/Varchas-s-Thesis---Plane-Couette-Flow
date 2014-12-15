function r = fixdigits(x, d);

if nargin < 2
  d = 2;
end
%r = str2num(num2str(x,d));
r = fix(10^d*x)/10^d;

  %d = d-1;
  %s = sign(x);
  %x = abs(x);
  %m = floor(log10(x));
  %r = sign(x)*round(x*10^(-m+d))*10^(m-d);
  
  
