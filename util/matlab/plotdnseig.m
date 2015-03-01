load ad0.asc
load ad1.asc
load ae0.asc
load ae1.asc

[M, N] = size(ad0);

for m=1:M;
  plot(ad1(m,:), ad0(m,:), 'r.', ae1(m,:), ae0(m,:), 'bo');
  title(num2str(m));
  pause;
end