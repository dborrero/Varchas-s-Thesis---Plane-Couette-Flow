hold off;
plot(lambdaW, 'bo', 'MarkerSize', 10);
hold on;
plot(lambdaJ, 'r.', 'MarkerSize', 16);

%plot(lambdaB, '.', 'Color', [0 0.8 0], 'MarkerSize', 10);
plot([-1 1], [0 0], 'k--');
plot([0 0], [-1 1], 'k--');
axis([-.1 .05 -.1 .1])

xlbl('Re \lambda');
ylbl('Im \lambda');
%legend('Direct', 'Arnoldi 0', 'Arnoldi 1')
legend('Direct', 'Arnoldi')

bigfont
