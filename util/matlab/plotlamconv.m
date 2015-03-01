lambda = cload('lamconv.asc');

[M N] = size(lambda);
xa = -0.02;
xb = 0.01;
ya = -0.05;
yb = -ya;

for n=12:M
  n
  hold off
  plot(lambda(M,:), 'b.');
  axis([xa xb ya yb])
  %axis([-ax/2 ax/2 -ax ax])
  %axis equal;
  hold on
  plot(lambda(n,:), 'bo');
  plot([0 0], [ya yb], 'k--');
  pause
end;

