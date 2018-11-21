function[] = myHE(Image)
[I1,clrmap] = imread(Image);
%I1 = double(I1);
[M,N,d]=size(I1);
 for k=1:d
     hist = imhist(I1(:,:,k));
     for l=2:256
         hist(l)=hist(l)+hist(l-1);
     end
     hist = hist/(M*N);
     for i=1:M
         for j=1:N
             I2(i,j,k) = uint8(255*hist(I1(i,j,k)+1));
         end
     end
 end
 figure;
 iptsetpref('ImshowAxesVisible','on');
 imshow(I1, clrmap);
 colorbar;
 title('Original Image');
 figure;
 imshow(I2, clrmap);
 colorbar;
 title(['Histogram Equalized Image']);


        
