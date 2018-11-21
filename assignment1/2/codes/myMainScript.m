function[] = myMainScript()
disp('Running Q2(a) [estimated time ~5 sec each]');
tic;
myLinearContrastStretching('../data/barbara.png');
toc;tic;
myLinearContrastStretching('../data/TEM.png');
toc;tic;
myLinearContrastStretching('../data/canyon.png');
toc;tic;
myLinearContrastStretching('../data/church.png');
toc;

disp('Running Q2(b) [estimated time ~5 sec each]');
tic;
myHE('../data/barbara.png');
toc;tic;
myHE('../data/TEM.png');
toc;tic;
myHE('../data/canyon.png');
toc;tic;
myHE('../data/church.png');
toc;

disp('Running Q2(c) [estimated time ~6 sec]');
figure; myHM('../data/retina.png','../data/retinaMask.png', '../data/retinaRef.png', '../data/retinaRefMask.png');

disp('Running Q2(d) for "canyon.png" [estimated time ~15 sec each]');
figure; myAHE('../data/canyon.png', -1);
figure; myAHE('../data/canyon.png', 15);
figure; myAHE('../data/canyon.png', 201);
figure; myAHE('../data/canyon.png', 347);

disp('Running Q2(d) for "barbara.png" [estimated time ~6 sec each]');
figure; myAHE('../data/barbara.png', -1);
figure; myAHE('../data/barbara.png', 15);
figure; myAHE('../data/barbara.png', 75);
figure; myAHE('../data/barbara.png', 201);

disp('Running Q2(d) for "TEM.png" [estimated time ~10 sec each]');
figure; myAHE('../data/TEM.png', -1);
figure; myAHE('../data/TEM.png', 15);
figure; myAHE('../data/TEM.png', 201);
figure; myAHE('../data/TEM.png', 501);

disp('Running Q2(e) for "canyon.png" [estimated time ~15 sec each]');
figure; myCLAHE('../data/canyon.png', -1, 0);
figure; myCLAHE('../data/canyon.png', 201, 0.002);
figure; myCLAHE('../data/canyon.png', 201, 0.001);

disp('Running Q2(e) for "barbara.png" [estimated time ~10 sec each]');
figure; myCLAHE('../data/barbara.png', -1, 0);
figure; myCLAHE('../data/barbara.png', 75, 0.004);
figure; myCLAHE('../data/barbara.png', 75, 0.002);

disp('Running Q2(e) for "TEM.png" [estimated time ~10 sec each]');
figure; myCLAHE('../data/TEM.png', -1, 0);
figure; myCLAHE('../data/TEM.png', 201, 0.008);
figure; myCLAHE('../data/TEM.png', 201, 0.004);

end