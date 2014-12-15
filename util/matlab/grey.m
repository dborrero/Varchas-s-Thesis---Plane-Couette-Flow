function g = grey();

% [0 0.25]
for m=1:32
  x = m/64;
  g(m,:) = x * [1 1 1];
end

% [0.75 1]
for m=33:64
  x = m/64;
  g(m,:) = x * [1 1 1];
end
