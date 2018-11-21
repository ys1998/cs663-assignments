%% MyMainScript

tic;
%% Your code here
    MyIdealFIlter('../data/barbara256.png',40);
    MyGuassianFIlter('../data/barbara256.png',40);
    MyIdealFIlter('../data/barbara256.png',50);
    MyGuassianFIlter('../data/barbara256.png',50);
    MyIdealFIlter('../data/barbara256.png',60);
    MyGuassianFIlter('../data/barbara256.png',60);
    MyIdealFIlter('../data/barbara256.png',70);
    MyGuassianFIlter('../data/barbara256.png',70);
toc;
