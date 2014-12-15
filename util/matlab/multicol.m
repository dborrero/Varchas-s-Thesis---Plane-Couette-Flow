function Mu = multicol(M,u);
% Repeat

[I J] = size(u);
Mu = zeros(I,M*(J-1)+1);

for m=0:(M-1)
  offset = m*(J-1);
  j = (offset+1):(offset+J);
  Mu(:,j) = u;
end