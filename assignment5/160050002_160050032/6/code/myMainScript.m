%% Assignment 5 : Question 6

%% With noise-free inputs
tic;
disp('Inputs');
I = zeros(300, 300);
I(50:100, 50:120) = 255;
J = zeros(300, 300);
J(120:170, 20:90) = 255;

figure; colormap gray;
imagesc(I); title('I'); 
figure; colormap gray;
imagesc(J); title('J'); 

myCrossPowerSpectrum(I, J);
toc;
snapnow;

%% With noisy inputs
tic;
rng(0);
I = I + randn(size(I)) * 20;
J = J + randn(size(J)) * 20;

disp('Noisy inputs');
figure;
colormap gray;
imagesc(I); title('Noisy I');
figure; 
colormap gray;
imagesc(J); title('Noisy J');

myCrossPowerSpectrum(I, J);
toc;
snapnow;

%% Conclusion
% The marker in the outputs indicates the position of the impulse. As
% mentioned in the paper, this impulse indicates the translation difference
% between two input images. Note that these translations are periodic, i.e.
% a translation of $X$ along a dimension is same as a translation of $N -
% X$ in the opposite direction. Thus, the values obtained match with
% expected values. Moreover, addition of noise spreads the impulse response
% along both dimensions i.e. instead of a single bright pixel, we get a set
% of pixels with varying intensities.
%
% The complexity of the FFT based method is $O(MN\log(MN)$ where the image
% is of dimension $M\times N$. However, for pixel based methods the
% complexity will be $O(MN)^2$ (considering all MN overlaps, and complexity
% of $O(MN)$ for finding correlation/similarity for each overlap.
