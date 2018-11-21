function [] = myCrossPowerSpectrum(f1, f2)
F1 = fft2(f1);
F2 = fft2(f2);
CPS = (F1 .* conj(F2)) ./ (abs(F1) .* abs(F2));
R = ifft2(CPS);
mag = log(1 + abs(CPS));

figure; 
colormap gray;
imagesc(mag,  [min(min(mag)), max(max(mag))]);
colorbar;
title('Logarithm of magnitude of cross-power spectrum');

[~, idx] = max(R(:));
[j, i] = ind2sub(size(R), idx);
disp('Position of marker = [' + string(i) + ', ' + string(j) + ']');
figure; 
colormap gray;
imagesc(R); 
title('Result');
end