function [] = myBilinearInterpolation(Image)
[I1,clrmap] = imread(Image);
[M,N]=size(I1);

I2 = double(zeros(3*M-2,2*N-1));
for i=1:3*M-2
    for j=1:2*N-1  
        if rem(i+2,3)==0 && rem(j+1,2)==0    
            I2(i,j) = I1((i+2)/3,(j+1)/2);
        else
           mapi = (i+2)/3 ;
           mapj=(j+1)/2  ;
           x1=double(floor(mapi)); y1 = double(floor(mapj));
           frac1=(x1+1-mapi)*(y1+1-mapj); frac3= (mapi-x1)*(y1+1-mapj); frac2=(x1+1-mapi)*(mapj-y1);
           frac4=(mapi-x1)*(mapj-y1);
           I2(i,j)=frac1*I1(x1,y1);
           if frac2 > 0 
               I2(i,j)=I2(i,j)+frac2*I1(x1,y1+1);
           end    
           if frac3 > 0   
               I2(i,j)=I2(i,j)+frac3*I1(x1+1,y1);
           end 
           if frac4 > 0    
               I2(i,j)=I2(i,j)+frac4*I1(x1+1,y1+1);
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
figure; imagesc(I2); title('Bilinear interpolated Image');
colormap(myColorScale);
if size(I2,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar
% for i
% for i=2:3:3*M-4
%     for j=1:2:2*N-1  
%             I2(i,j) = (2/3)*I1((i+1)/3,j/2)+(1/3)*I1((i+2)/3,j/2); 
%     end 
% end
% for i=3:3:3*M-3
%     for j=1:2:2*N-1  
%             I2(i,j) = (1/3)*I1((i-1)/3,j/2)+(2/3)*I1((i+2)/3,j/2); 
%     end 
% end
% for i=2:3:3*M-2
%     for j=1:2:2*N-1  
%             I2(i,j) = (2/3)*I1((i-1)/3,j/2)+(1/3)*I1((i+2)/3,j/2); 
%     end 
% end
% for i=1:3:3*M-1
%     for j=2:2:2*N-2  
%             I2(i,j) = (1/2)*I1((i)/3,j/2)+(1/2)*I1((i+2)/3,j/2); 
%     end 
% end


    
