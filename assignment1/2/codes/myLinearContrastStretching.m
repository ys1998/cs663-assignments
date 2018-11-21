function[]=myLinearContrastStretching(Image)
I1 =imread(Image);
[M,N,d]=size(I1);
I2 = double(zeros(M,N,d));
%I1
for i=1:d
    I5=double(I1(:,:,i));
    min_ = double(min(min(I5)));
    max_ = double(max(max(I5)));
    %max_
    %min_
    %max_-min_
    for j=1:M
        for k=1:N
        I2(j,k,i) = (I5(j,k)-min_)*(1.0/(max_-min_));
        end
    end    
end
%max(max(max(double(I2)-double(I1))))
myNumOfColors = 200;
myColorScale = repmat((0:1/(myNumOfColors-1):1)',1,3);
figure; imagesc(I1); title('Original Image');
colormap(myColorScale);
if size(I1,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar
figure; imagesc(I2); title('Linear Contrast Streched Image');
colormap(myColorScale);
if size(I2,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar
% figure
% iptsetpref('ImshowAxesVisible','on');
% imshow(I1, clrmap);
% colorbar;
% title('Original Image');
% figure
% imshow(I2, clrmap);
% colorbar;
% title(['Contrast Enhanced Image'])