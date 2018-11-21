%% Function for patch based filtering.
%Image1 is the correct image, Image2 is the corrupted image
%is_corrupt for the two types of input type similary y
function [] = myPatchBasedFiltering(Image1,Image2,is_corrupt,y)
if(is_corrupt)
   I0 = double(Image1);
   [X,Y] = size(I0);
   I1 = double(Image2)*256;
   I2 = double(zeros(X,Y));
else
   I0 = Image1;
    [X,Y] = size(I0);
    I1 = zeros(X,Y);
    I2 = double(zeros(X,Y)); % I2 stores the modified image
    %corrupt I1
    rng(0);
     range_intensity = max(max(I0))-min(min(I0));
     for i=1:X
         for j=1:Y
             x = normrnd(0,0.05*range_intensity);
             I1(i,j) = I0(i,j) + x;    
         end
     end 
end    
if y == 1
    z = 1.0;
elseif y == 2
    z = 0.5;
else 
    z = 1.0;
end    
%% Main body
param= [26.1,29.0,31.9]; % param array stores the values of 'h' to be tried
rsmd  = zeros(size(param)); % rsmd array stores the rsmd values for the correpsonding value of parameter
% loop around each pixel and apply the patch based filetr on it
isotropic_patch = zeros(9,9);
for i=1:9
    for j=1:9
        dist = (i-5)*(i-5)+(j-5)*(j-5);
        isotropic_patch(i,j) = exp(-dist/z);
    end
end

% dataS precalculates all the 9*9 patches saving a lot og repeated
% calculation and making the code faster
dataS = double(zeros(9,9,X,Y)); 
for i=1:X
     for k=1:Y
         for a=-4:4
             for b=-4:4
                  if(i+a < 1 || k+b < 1 || k+b > Y || i+a > X) 
                       dataS(a+5,b+5,i,k) = -1;
                  else
                       dataS(a+5,b+5,i,k) = I1(i+a,k+b);
                  end    
              end
         end  
     end    
 end 

% The main loop of the code were the filtered image gets constructed
for p=1:3
    h = param(p);
    rsmd_temp=0.0;
    for i=1:X  
        
        for j=1:Y
            % obtain the window by determining the four corners such that
            % 9*9 patch ceneterd here always lies in the 25*25 window
            lx = max(1,j-8);
            rx = min(X,j+8);
            uy = max(1,i-8);
            dy = min(Y,i+8);
            window = I1(uy:dy,lx:rx);
            % for each entry of window weight will finally store its cumulative
            % weight, its just initialized with window for the sake of matching
            % the size
            weight = window;
            % find the patch for the current pixel
            patchRef = zeros(9,9);
            for a=-4:4
                for b=-4:4
                    if(i+a < 1 || i+a > Y || j+b < 1 || j+b > X) 
                        patchRef(a+5,b+5)=-1;
                    else
                        patchRef(a+5,b+5) = I1(i+a,j+b);
                    end    
                end
            end    
            % iterarte over the pixels of the window
            for i1=uy:dy
                for j1=lx:rx
                    patchNew = dataS(:,:,i1,j1); 
                    % we have patchNew and patchRef to calculate the weight of
                    % this pixels influence
                    temp_weight = 0.0;
                    for a=1:9
                        for b=1:9
                            if(patchNew(a,b) == -1 || patchRef(a,b) == -1) 
                                continue;
                            else
                                diff = abs(patchNew(a,b)-patchRef(a,b));
                                temp_weight = temp_weight + (isotropic_patch(a,b)*isotropic_patch(a,b))*(diff*diff);
                                %temp_weight = temp_weight + diff*diff;
                            end 
                        end
                    end    
                    %temp_weight
                    weight(i1-uy+1,j1-lx+1) = double(exp(-1.0*temp_weight/(h*h)));  
                   
                end    
            end
            % now the weight array is full we calculate the reulting intensity
            % and store it in I2.
            tot = sum(sum(weight));
            weight = weight/tot;
            I2(i,j) = sum(sum(window.*weight));
            rsmd_temp=rsmd_temp+(I0(i,j)-I2(i,j))*(I0(i,j)-I2(i,j));
        end
    end
    % calculate rsmd
    rsmd_temp = rsmd_temp/(X*Y*1.0);
    rsmd_temp= sqrt(double(rsmd_temp));
    rsmd(p) = rsmd_temp;
    %if is_corrupt == false
        figure;
        subplot(2,1,1); imagesc([I0, I1, I2]); title(['(left) Original, (center) Corrupted, (right) Denoised \sigma_h = ',num2str(h)]);
        colormap gray; daspect([1 1 1]); axis tight;
        colorbar;
    %else
    %    figure;
    %    subplot(2,1,1); imagesc([I1, I2]); title(['(left) Corrupted, (right) Denoised \sigma_h = ',num2str(h)]);
    %    colormap gray; daspect([1 1 1]); axis tight;
    %    colorbar;
    %end
    %% Images 
    % images are saved in the image folder by Part1,Part2,Part3
    % respectively for the three images
    save(['Image',num2str(h),'.mat'],'I2');
    imwrite(uint8(I2),['Image',num2str(h),'.png']);
end
param 
rsmd    
