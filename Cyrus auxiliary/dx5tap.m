function dI = dx5tap(I)

% description coming soon
%
% Cyrus A Wilson    February 2005

[numRows, numCols] = size(I);

% Eero Simoncelli's 5-tap derivative filters
% (separable convolution kernels)
sepDeriv = [9.186104e-2; 0.307610; 0.00000; -0.307610; -9.186104e-2];
sepSmooth = [3.342604e-2; 0.241125; 0.450898; 0.241125; 3.342604e-2];

result = conv2(sepSmooth, sepDeriv', I, 'valid');

dI = zeros(numRows, numCols);
dI(3:(numRows-2), 3:(numCols-2)) = result;
