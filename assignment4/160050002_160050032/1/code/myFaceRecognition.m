function [] = myFaceRecognition(train_x, train_labels, test_x, test_labels, k_vals, type, ignore)
% train_x - training data
% train_labels - traning labels
% test_x - test data
% test_labels - correct labels for test data
% k_vals - number of eigenfaces used for reconstruction
% type - denotes the method used for finding eigenvectors ('eig' or 'svd')
% ignore - whether to ignore top 3 eigencoeffs or not (0 or 1), or both (2; only for svd)
if strcmp(type, 'eig')
    x_mean = mean(train_x, 2);
    x_ = double(train_x) - x_mean;
    L = x_' * x_;
    [w, d] = eig(L);
    [~, idx] = sort(diag(d), 'descend');
    w = w(:, idx);
    V = x_ * w;
    V = V./vecnorm(V);
    tx_ = double(test_x) - x_mean;
    recog_rates = [];
    for k = k_vals
        Vk = V(:, 1:k); 
        coeffs = Vk' * x_;
        c = Vk' * tx_;
        recog = 0;
        for i = 1:size(test_x, 2)
            if ignore == 0
                [~, pred] = min(sum((coeffs - c(:,i)).^2));
            else
                [~, pred] = min(sum((coeffs(4:size(coeffs,1), :) - c(4:size(c,1),i)).^2));
            end
            recog = recog + (train_labels(pred) == test_labels(i));
        end
        recog_rates = [recog_rates, recog/size(test_x, 2)];
    end
    figure;
    plot(1:length(k_vals), recog_rates, '-o');
    if ignore == 1
        title('Recognition rate vs. k using "eig" ignoring top 3 eigencoeffs');
    else
        title('Recognition rate vs. k using "eig" not ignoring top 3 eigencoeffs');
    end
    xlabel('k'); ylabel('Recognition rate');
    xticks(1:length(k_vals));
    ylim([0.0, 1.0]);
    xticklabels(k_vals);
elseif strcmp(type, 'svd')
    x_mean = mean(train_x, 2);
    x_ = double(train_x) - x_mean;
    [U, S, ~] = svd(x_, 'econ');
    [~, idx] = sort(diag(S).^2, 'descend');
    U = U(:, idx);
    tx_ = double(test_x) - x_mean;
    recog_rates0 = []; recog_rates1 = [];
    for k = k_vals
        Vk = U(:, 1:k); 
        coeffs = Vk' * x_;
        c = Vk' * tx_;
        recog0 = 0; recog1 = 0;
        for i = 1:size(test_x, 2)
            [~, pred0] = min(sum((coeffs - c(:,i)).^2));
            [~, pred1] = min(sum((coeffs(4:size(coeffs,1), :) - c(4:size(c,1),i)).^2));
            recog0 = recog0 + (train_labels(pred0) == test_labels(i));
            recog1 = recog1 + (train_labels(pred1) == test_labels(i));
        end
        recog_rates0 = [recog_rates0, recog0/size(test_x, 2)];
        recog_rates1 = [recog_rates1, recog1/size(test_x, 2)];
    end
    figure;
    if ignore == 0
        plot(1:length(k_vals), recog_rates0, '-o');
        title('Recognition rate vs. k using "svd" not ignoring top 3 eigencoeffs');
    elseif ignore == 1
        plot(1:length(k_vals), recog_rates1, '-o');
        title('Recognition rate vs. k using "svd" ignoring top 3 eigencoeffs');
    elseif ignore == 2
        plot(1:length(k_vals), recog_rates0, '-o');
        title('Recognition rate vs. k using "svd" not ignoring top 3 eigencoeffs');
        xlabel('k'); ylabel('Recognition rate');
        xticks(1:length(k_vals));
        ylim([0.0, 1.0]);
        xticklabels(k_vals);
        figure;
        plot(1:length(k_vals), recog_rates1, '-o');
        title('Recognition rate vs. k using "svd" ignoring top 3 eigencoeffs');
    end
    xlabel('k'); ylabel('Recognition rate');
    xticks(1:length(k_vals));
    ylim([0.0, 1.0]);
    xticklabels(k_vals);
end
end