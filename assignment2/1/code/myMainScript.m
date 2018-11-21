%% Unsharp Masking
% We performed *unsharp masking* on the images _lionCrop.mat_ and
% _superMoonCrop.mat_ using a 5x5 gaussian mask over a wide range of parameters
% (both $\sigma$ and _scale_), and visually compared the results: 
%%
% 
%   for sigma = [0.5, 0.7, 1, 3, 5, 10]
%       for scale = [1, 3, 5, 10, 20]
%           myUnsharpMasking('../data/lionCrop.mat',sigma,scale);
%           myUnsharpMasking('../data/superMoonCrop.mat',sigma,scale);
%       end
%   end
%
%%
% The optimal parameters from the above range were found to be
% $\sigma$=0.5, _scale_=10 for _lionCrop.mat_ and $\sigma$=3, _scale_=5 for
% _superMoonCrop.mat_
%%
function[] = myMainScript()
tic;
myUnsharpMasking('../data/lionCrop.mat', 0.5, 10);
toc;
tic;
myUnsharpMasking('../data/superMoonCrop.mat', 3, 5);
toc;
end
