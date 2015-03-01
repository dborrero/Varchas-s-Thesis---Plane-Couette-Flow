function ploteigf(n) 

lambda = cload(strcat('../ew', n2s(n), '.cmplx'));
plotfield(strcat('ef', n2s(n)));
subplot(121)
ttl(strcat('\lambda_{', n2s(n), '} = ', n2s(lambda)));
  
h = gcf;
print(h,'-depsc', strcat('ef', n2s(n)));