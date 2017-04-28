function A = calcAmatrix(alpha, beta, length)

% A = calcAmatrix(alpha, beta, length)
%
% Computes the matrix A, the pentadiagonal banded matrix
% representation of the coefficients of the terms
% in the active contour's internal energy functional.
% (Kass, Witkin & Terzopoulos, 1988)
%
%   alpha   the tension weighting parameter
%   beta    the rigidity weighting parameter
%   length  the number of points defining the contour
%
% Cyrus A Wilson    March 2003

A = zeros(length, length);

% Although the numerical method presented by Kass et al. allows for
% alpha and beta terms that vary for each point in the snake,
% in my use I will only specify a single alpha and beta for the
% entire snake.

% I have rearranged equation 14 (Kass, Witkin & Terzopoulos, 1988)
% in terms of v(i - 2), v(i - 1), v(i), v(i + 1), v(i + 2); I call
% their respective coefficients a, b, c, d, e.

% note that I was able to simplify terms because in my implementation,
% alpha(i) = alpha(i + 1), etc.

a = beta;
b = (-1 * alpha) + (-4 * beta);
c = (2 * alpha) + (6 * beta);
d = (-1 * alpha) + (-4 * beta);
e = beta;

% create first row:

currentRow = zeros(1, length);
currentRow(length - 1) = a;
currentRow(length) = b;
currentRow(1) = c;
currentRow(2) = d;
currentRow(3) = e;

% assemble matrix, using the circshift function to generate each row

for m = 1:length
    A(m, :) = currentRow;
    currentRow = circshift(currentRow, [0, 1]);
end

