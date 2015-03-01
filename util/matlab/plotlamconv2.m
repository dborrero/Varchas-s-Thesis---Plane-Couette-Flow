function plotlamconv2(Marg)

if nargin <1
  Marg = 200
end

lambda = cload('lamconv.asc');

% M = number of iterations
% N = number of saved eigenvalues

[M N] = size(lambda);
for m=1:M
  for n=1:N
    if (imag(lambda(m,n)) < 0)
      lambda(m,n) = conj(lambda(m,n));
    end
  end
end
lambdaF = lambda(M,:);

lamerr = zeros(M-1,N);

for m=1:M
  for n=1:N-1
    lamerr(m,n) = min(abs(lambdaF(n) - lambda(m,:)));
  end
end

Nsub=20;
c = get(gca, 'ColorOrder');
%semilogy(lamerr(:,1:10))
hold off
for n=1:Nsub
  cn = c(mod(n-1,7)+1,:);
  semilogy(1.01*Marg ,lamerr(M-1,n), 'o',...
	   'MarkerFaceColor', cn, ...;
	   'MarkerEdgeColor', cn);
hold on
end
%legend('\lambda_0^i err', ...
%       '\lambda_1^i err', ...
%       '\lambda_2^i err', ...
%       '\lambda_3^i err', ...
%       '\lambda_4^i err', ...
%       '\lambda_5^i err', ...
%       '\lambda_6^i err');

legend('boxoff')
semilogy(lamerr(1:Marg,1:Nsub))
%plot(abs(lamerr(:,1:20)))
axis([0 100 1e-18 1])
fs=20;
xlbl('iteration n',fs);
ylbl('|\lambda_n - \lambda_{n=100}|',fs);
ttl('Arnoldi convergence',fs)
legend
bigfont(20);