function [L,U,p] = lutx_chop(A)
%LUTX_CHOP  Triangular factorization, textbook version
%   [L,U,p] = lutx_xhop(A) produces a unit lower triangular matrix L,
%   an upper triangular matrix U, and a permutation vector p,
%   so that L*U = A(p,:)
%   It uses the CHOP function to simulate lower precision arithmetic; 

%   Copyright 2014 Cleve Moler
%   Copyright 2014 The MathWorks, Inc.

[n,n] = size(A);
p = (1:n)';

for k = 1:n-1

   % Find index of largest element below diagonal in k-th column
   [r,m] = max(abs(A(k:n,k)));
   m = m+k-1;

   % Skip elimination if column is zero
   if (A(m,k) ~= 0)
   
      % Swap pivot row
      if (m ~= k)
         A([k m],:) = A([m k],:);
         p([k m]) = p([m k]);
      end

      % Compute multipliers
      i = k+1:n;
      A(i,k) = chop(A(i,k)/A(k,k));

      % Update the remainder of the matrix
      j = k+1:n;
      A(i,j) = chop(A(i,j) - chop(A(i,k)*A(k,j))); 
   end
end

% Separate result
L = tril(A,-1) + eye(n,n);
U = triu(A);
