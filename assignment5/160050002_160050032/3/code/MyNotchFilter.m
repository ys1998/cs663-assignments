function [] = MyNotchFilter(X)
I = load(X);
I = I.Z;
%I = imread(I.image);
%I

[x,y] = size(I)


I1  = zeros(2*x,2*y);

for i=1:2*x
    for j=1:2*y
        if( i > x/2 && i <= 1.5*x && j > y*0.5 && j <= 1.5*y)
            %I(i-0.5*x,j-0.5*y)
            I1(i,j) = I(i-0.5*x,j-0.5*y);
        else
            I1(i,j) = 0;
        end    
    end
end 
%imshow(mat2gray(I1));
%imshow(I1);
F = fftshift(fft2(I1)); 
absfim1 = log(abs(F)+1); 
figure;
imshow(mat2gray(absfim1));

H = zeros(2*x,2*y);
%H_2 = zeros(2*x,2*y);
%I1(240:245,245:250)
% 235,245   277,267
% 240,246
for i=1:2*x
     for j=1:2*y
         if((i-240)*(i-240)+(j-245)*(j-245) <= 100) 
            H(i,j) = 0;
         elseif((i-272)*(i-272)+(j-267)*(j-267) <= 100)
            H(i,j) = 0;
         else
            H(i,j) = 1; 
         end   
     end
end   

R = F.*H;
%F = fftshift(fft2(I1)); 
absfim1 = log(abs(R)+1);
figure;
imshow(mat2gray(absfim1));

Res = ifft2(ifftshift(R));
Res = real(Res);
%figure;
%imshow(mat2gray(Res));
Z = Res(x*0.5:1.5*x,y*0.5:1.5*y);
%Z
figure;
imshow(mat2gray(Z));

