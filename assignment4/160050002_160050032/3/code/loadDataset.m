function [train_x, train_labels, test_x, test_labels] = loadDataset(folder_path, train_folder, train_img, h, w)
% allocate space for variables
train_x = zeros(h*w, train_folder*train_img);
train_labels = zeros(train_folder*train_img, 1);
img = zeros(h*w, 1);
% variables to store test data
test_x = [];
test_labels = [];
% list of all subfolders
folder_lst = dir(folder_path);
% counter and index pointer
x = 1; cnt_x = 0;
while cnt_x < train_folder
    % ignore ., .. and README
    if (strcmp(folder_lst(x).name, '.') || strcmp(folder_lst(x).name, '..') || strcmp(folder_lst(x).name, 'README'))
        x = x + 1;
    else
        % list of all files within the subfolder
        file_lst = dir(fullfile(folder_path, folder_lst(x).name));
        y = 1; cnt_y = 0;
        % collect training images
        while cnt_y < train_img
            % ignore . and ..
            if (strcmp(file_lst(y).name, '.') || strcmp(file_lst(y).name, '..'))
                y = y + 1;
            else
                % read and reshape image into column vector
                img = reshape(imread(fullfile(folder_path, folder_lst(x).name, file_lst(y).name)), h*w, 1);
                % store image and its label
                train_x(:, cnt_x*train_img + cnt_y + 1) = img;
                train_labels(cnt_x*train_img + cnt_y + 1) = cnt_x + 1;
                y = y + 1; cnt_y  = cnt_y + 1;
            end
        end
        % collect test images
        while y <= length(file_lst)
            % ignore . and ..
            if (strcmp(file_lst(y).name, '.') || strcmp(file_lst(y).name, '..'))
                y = y + 1;
            else
                % read and reshape image into column vector
                img = reshape(imread(fullfile(folder_path, folder_lst(x).name, file_lst(y).name)), h*w, 1);
                % store test image and label
                test_x = [test_x, img];
                test_labels = [test_labels; cnt_x + 1];
                y = y + 1; cnt_y  = cnt_y + 1;
            end
        end
        x = x + 1; cnt_x = cnt_x + 1;
    end
end
% load unseen data
while x <= length(folder_lst)
    file_lst = dir(fullfile(folder_path, folder_lst(x).name));
    file_lst = {file_lst.name};
    file_lst = file_lst(~ismember(file_lst, {'.', '..'}));
    for y=(train_img+1):length(file_lst)
        % read and reshape image into column vector
        img = reshape(imread(fullfile(folder_path, folder_lst(x).name, string(file_lst(y)))), h*w, 1);
        % store test image and label
        test_x = [test_x, img];
        test_labels = [test_labels; -1]; % label is -1 for images outside training faces
    end
    x = x+1;
end
end