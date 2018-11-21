function [] = myShrinkImageByFactorD(I1,d)
[Image,clrmap] = imread(I1);
[X,Y] = size(Image);

rows = 0:d:X;
columns = 0:d:Y;
rows = rows([2:end]);
columns = columns([2:end]);
I2 = ones(ceil(X/d),ceil(Y/d));
for i = 1:X/d
    for j=1:Y/d
        I2(i,j) = Image(rows(i),columns(j));
    end
end  

myNumOfColors = 200;
myColorScale = repmat((0:1/(myNumOfColors-1):1)',1,3);
figure; imagesc(Image); title('Original Image');
colormap(myColorScale);
if size(Image,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar
figure; imagesc(I2); title(['Shrinked Image By Factor = ' num2str(d) '.']);
colormap(myColorScale);
if size(I2,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar

% myNumOfColors = 200;
% myColorScale = [ [0:1/(myNumOfColors-1):1]']; 
% imagesc (single (I2)); % phantom is a popular test image colormap (myColorScale);
% colormap gray;
% daspect ([1 1 1]);
% axis tight;
% colorbar
