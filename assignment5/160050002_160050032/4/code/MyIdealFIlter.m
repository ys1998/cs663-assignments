function [] = MyIdealFIlter(I,D)
I = imread(I);
%I

[x,y] = size(I);

% zero pad the image assuming x,y are even 
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
%I1 = complex(I1);
F = fftshift(fft2(I1)); 

H = zeros(2*x,2*y);
for i=1:2*x
     for j=1:2*y
         if( (i-x)*(i-x) + (j-y)*(j-y) <= D*D) 
             H(i,j) = 1;
         else
             H(i,j) = 0;
         end    
     end
end  
figure;
 absfim1 = log(abs(H)+1); 
 imshow(mat2gray(absfim1));
%imshow(H)
R = F.*H;
%R

Res = ifft2(ifftshift(R));
%Res
Res = real(Res);

% extract the center part of the Res
%figure;
%imshow(mat2gray(Res));
Z = Res(x*0.5:1.5*x,y*0.5:1.5*y);
%Z
figure;
imshow(mat2gray(Z));
