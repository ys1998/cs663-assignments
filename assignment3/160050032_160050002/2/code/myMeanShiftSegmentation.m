function res = myMeanShiftSegmentation(img, hc, hs)
% Parameters
% #iterations till 'assumed' convergence
num_iters = 20;
% amount by which we move towards the peak everytime
step_size = (hc*hs)^2/(hc^2+hs^2); 

% prepare data structure for storing pixel-wise information
[H,W,C] = size(img);
ds = zeros([H,W,C+2]);
ds(:,:,1:C) = img;
ds(:,:,C+1) = repmat(1:W, [H,1]);
ds(:,:,C+2) = repmat((1:H)', [1, W]);
ds = reshape(ds, [H*W, C+2]);

% allocate space for storing calculation results
num_nn = floor(sqrt(H*W));
diff = zeros([H*W, C+2, num_nn]);
fx = zeros([H*W, num_nn]);
sumfx = zeros([H*W, 1]);
grad_c = zeros([H*W, C]);
grad_s = zeros([H*W, 2]);

% waitbar for showing #iterations completed 
h = waitbar(0, "Iterations completed");
for i=1:num_iters
    % find nearest neighbors 
    idx = knnsearch(ds, ds, 'K', num_nn);
    % fill the diff matrix
    diff(:,:,:) = ds - permute(reshape(ds(idx', :)', [C+2, num_nn, H*W]), [3 1 2]);
    % find the kernel weights for each pixel
    fx(:,:) = exp(-squeeze(sum(diff(:, 1:C, :).^2/hc^2, 2))).*exp(-squeeze(sum(diff(:, C+1:C+2, :).^2/hs^2, 2)));
    
    % sum up the weights for all neighbors
    sumfx(:,:) = sum(fx, 2);
    
    % find the gradient for color domain
    grad_c(:,:) = -squeeze(sum(reshape(fx, [H*W, 1, num_nn]).*diff(:,1:C,:)/hc^2, 3));
    grad_c(:,:) = grad_c./sumfx;
    
    % find the gradient for spatial domain
    grad_s(:,:) = -squeeze(sum(reshape(fx, [H*W, 1, num_nn]).*diff(:,C+1:C+2,:)/hs^2, 3));
    grad_s(:,:) = grad_s./sumfx;
    
    % update the pixel data structure
    ds(:,1:C) = ds(:,1:C) + step_size*grad_c;
    ds(:,C+1:C+2) = ds(:,C+1:C+2) + step_size*grad_s;
  
    waitbar(i/num_iters, h);
end
close(h);
res = reshape(ds(:,1:C), [H,W,C]);
end

