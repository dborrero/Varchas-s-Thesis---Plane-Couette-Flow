% Load coordinates a0,a1 from DNS simulation and EIG == v exp(lambda t)
ad0 = load('ad0.asc'); 
ad1 = load('ad1.asc');
ae0 = load('ae0.asc');
ae1 = load('ae1.asc');
lambda = cload('lambda.asc');

[N,T] = size(ad0)

hold off

skipnext = 0;
for n=1:N
  n
  t = 1:5:T;
  if (skipnext == 0)
    if (imag(lambda(n)) == 0) 
      plot(ad1(n,t), ad0(n,t), 'r.', ae1(n,t), ae0(n,t), 'bo');
      ymin = 0.9*min(ad0(n,t));
      ymax = 1.1*max(ad0(n,t));
      xmin = min(ad1(n,t));
      xmax = max(ad1(n,t));
      axis([xmin xmax ymin ymax])
      xlabel('t');
      ylabel('a_0');
      h = gcf;
    else
      plot(ad0(n,t), ad1(n,t), 'r.', ae0(n,t), ae1(n,t), 'bo');
      xlabel('a_0');
      ylabel('a_1');
      skipnext = 1;
    end
    title(strcat('\lambda_', num2str(n-1), ' = ', num2str(lambda(n))));
    print(h, '-depsc', strcat('UBverify',num2str(n-1)));
    pause();
  else
    skipnext = 0;
  end
end