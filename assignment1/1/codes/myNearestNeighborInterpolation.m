function []=myNearestNeighborInterpolation(Image)
[I1,clrmap] = imread(Image);
[M,N]=size(I1);
I2 = zeros(3*M-2,2*N-1);
for i=1:3*M-2
    for j=1:2*N-1  
        if rem(i+2,3)==0 && rem(j+1,2)==0    
            I2(i,j) = I1((i+2)/3,(j+1)/2);
        else
           mapi = (i+2)/3;mapj=(j+1)/2; 
           x1=floor(mapi); y1 = floor(mapj);
           if mapi <= x1+0.5 && mapj <= y1+0.5
               I2(i,j)=I1(x1,y1);
           elseif mapi <=x1+0.5 
               I2(i,j)=I1(x1,y1+1);
           elseif mapj <= y1+0.5
               I2(i,j)=I1(x1+1,y1);
           else 
               I2(i,j)=I1(x1+1,y1+1);
           end    
        end    
    end 
end
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
figure; imagesc(I2); title('Nearest Neighbour interpolated Image');
colormap(myColorScale);
if size(I2,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar
