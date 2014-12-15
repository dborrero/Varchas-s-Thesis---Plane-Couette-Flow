function B = scrunch(A, amin, amax);
% scrunch(A, mag)        : assure that |A(i,j)| <= mag
% scrunch(A, amin, amax) : assure that amin <= A(i,j) <= amax

if nargin < 3 ; 
  amax = abs(amin);
  amin = -abs(amin);
end

[M, N] = size(A);
B = A;
for i=1:M
  for j=1:N
    if B(i,j) < amin
      B(i,j) = amin;
    elseif B(i,j) > amax
      B(i,j) = amax;
    end
  end
end
      