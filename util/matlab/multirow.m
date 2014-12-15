function Mu = multirow(M,u);

[I J] = size(u);
Mu = zeros(M*(I-1)+1, J);

for m=0:(M-1)
  offset = m*(I-1);
  i = (offset+1):(offset+I);
  Mu(i, :) = u;
end