function[] = myMainScript()
disp('Running 1(a)');
tic;
myShrinkImageByFactorD('../data/circles_concentric.png',3);
toc; tic;
myShrinkImageByFactorD('../data/circles_concentric.png',2);

disp('Running 1(b)');
tic;
myBilinearInterpolation('../data/barbaraSmall.png');
toc; 
disp('Running 1(c)');
tic;
myNearestNeighborInterpolation('../data/barbaraSmall.png');
toc;
end
