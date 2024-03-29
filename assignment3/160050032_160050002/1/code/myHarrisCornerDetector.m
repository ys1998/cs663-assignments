function [] = myHarrisCornerDetector()
S = load('../data/boat.mat');
I=S.imageOrig; %load the original image
% min(min(I)) = 0 so no need of reshifting
I = (I)/(max(max(I))); % make the intensity range from 0 to 1
% initialize parameters for tuning
sigma_1 = 1; % sigma_1 is the weight gaussian
sigma_2 = 1; % sigma_2 is the gaussian filtering for original image to get Ix,Iy

% filter the image before extracting the derivatives

I = imgaussfilt(I,sigma_2);
[Ix,Iy] = imgradientxy(I);

% copmute the Ix^2, Iy^2 ,IxIy matrices before computing the structure
% tensor

Ix2 = Ix.^2;
figure;
imshow(mat2gray(Ix)),colorbar;
title('Ix');
Iy2 = Iy.^2;
figure;
imshow(mat2gray(Iy)),colorbar;
title('Iy');
IxIy = Ix.*Iy;

% these lines filter Ix2 Iy2 IxIy by another gaussian which is supposed to
% be the weights for when we constrcut strcuture tensors for pixels, thus
% after this step we dont need to worry about the weights we can just add
% the matrices at the neighbourhood of each pixel
g = fspecial('gaussian', [6 6] ,sigma_1);
Ix2 = imfilter(Ix2,g,'same');
Iy2 = imfilter(Iy2,g,'same');
IxIy = imfilter(IxIy,g,'same');

[X,Y] = size(I);
eigen1 = double(zeros(X,Y)); % smaller eigen value
eigen2 = double(zeros(X,Y)); % larger eigen value
Result = double(zeros(X,Y)); % cornerness measure
k = 0.15; % tuning parameter for measuring 
for i=1:X-1
    for j=1:Y-1
        if(i == 1 || j == 1) 
            resIx2 = 0;
            resIy2 = 0;
            resIxIy = 0;
            for a=0:1
                for b=0:1
                    resIx2 = resIx2 + Ix2(a+i,b+j);
                    resIy2 = resIy2 + Iy2(a+i,b+j);
                    resIxIy = resIxIy + IxIy(a+i,b+j);
                end
            end
            tensor = double(zeros(2,2));
            tensor(1,1) = resIx2;
            tensor(1,2) = resIxIy;
            tensor(2,1) = resIxIy;
            tensor(2,2) = resIy2;
            %tensor;
            e = eig(tensor);
            %min(e);
            %max(e);
            eigen1(i,j) = min(e);
            eigen2(i,j) = max(e);
            Result(i,j) = (eigen1(i,j)*eigen2(i,j)) - k*(eigen1(i,j)+eigen2(i,j))*(eigen1(i,j)+eigen2(i,j));
        else     
            resIx2 = 0;
            resIy2 = 0;
            resIxIy = 0;
            for a=-1:1
                for b=-1:1
                    resIx2 = resIx2 + Ix2(a+i,b+j);
                    resIy2 = resIy2 + Iy2(a+i,b+j);
                    resIxIy = resIxIy + IxIy(a+i,b+j);
                end
            end
            tensor = double(zeros(2,2));
            tensor(1,1) = resIx2;
            tensor(1,2) = resIxIy;
            tensor(2,1) = resIxIy;
            tensor(2,2) = resIy2;
            %tensor;
            e = eig(tensor);
            %min(e);
            %max(e);
            eigen1(i,j) = min(e);
            eigen2(i,j) = max(e);
            Result(i,j) = (eigen1(i,j)*eigen2(i,j)) - k*(eigen1(i,j)+eigen2(i,j))*(eigen1(i,j)+eigen2(i,j));
        end
    end
end    
Corners = (Result > 0.35);
max(max(Result));

% display all the results
 figure;
 imshow(mat2gray(eigen1));
 title('Minimum eigen value'),colorbar;
 figure;
 imshow(mat2gray(eigen2));
 title('Maximum eigen value'),colorbar;
 figure;
 imshow(mat2gray(Result)),colorbar;
 title('Cornerness measure');
 figure;
 imshow(mat2gray(Corners)),colorbar;
 title('Thresholded Cornerness measure');
 figure;
 imshow(mat2gray(Corners+I)),colorbar;
 title('Cornerness measure superimposed on image');
 
 