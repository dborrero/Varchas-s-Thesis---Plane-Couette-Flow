lambda = cload('lambda.asc');

[M N] = size(lambda);
xa = -0.06;
xb = 0.06;
ya = -0.6;
yb = -ya;

hold off
plot(lambda, 'b.', 'MarkerSize', 16);
hold on
axis([xa xb ya yb])
plot([0 0], [-1 1], 'k--');
plot([-1 1], [0 0], 'k--');
xlbl('Re \lambda')
ylbl('Im \lambda')
bigfont
