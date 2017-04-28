function dI = dyy5tap(I)

% description coming soon
%
% Cyrus A Wilson    February 2005

[numRows, numCols] = size(I);

% Eero Simoncelli's 5-tap derivative filters
% (separable convolution kernels)
sepDerivDeriv = [0.202183; 9.181186e-2; -0.587989; 9.181186e-2; 0.202183];
sepSmooth = [3.342604e-2; 0.241125; 0.450898; 0.241125; 3.342604e-2];

result = conv2(sepDerivDeriv, sepSmooth', I, 'valid');

dI = zeros(numRows, numCols);
dI(3:(numRows-2), 3:(numCols-2)) = result;
