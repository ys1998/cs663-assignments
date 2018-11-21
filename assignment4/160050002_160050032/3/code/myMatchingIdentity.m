function [] = myMatchingIdentity(train_x, train_y, test_x, test_y, k, n_test)
% train_x - input data (images)
% train_y - correct labels for input
% test_x - test data (includes both seen and unseen)
% test_y - correct labels for test data (-1 for unseen)
x_mean = mean(train_x, 2);
x_ = double(train_x) - x_mean;
L = x_' * x_;
[w, d] = eig(L);
[~, idx] = sort(diag(d), 'descend');
w = w(:, idx);
V = x_ * w;
V = V./vecnorm(V);
Vk = V(:, 1:k);
coeffs = Vk' * x_;
epsilon = zeros(length(unique(test_y)) - 1, 1); % ignore label for unseen data
% find threshold for each label
for i=1:size(epsilon, 1)
    idx = ((i-1)*n_test+1):(i*n_test);
    c = coeffs(:, idx);
    for j = idx
        epsilon(i) = max([epsilon(i), sum((c - coeffs(:, j)).^2)]);
    end
end
% e = max(epsilon);
false_negs = 0; false_pos = 0;
c = Vk' * (double(test_x) - x_mean);
for i = 1:size(test_x, 2)
    [dist, pred] = min(sum((coeffs - c(:,i)).^2));
    if test_y(i) == -1 && dist < epsilon(train_y(pred))
        false_pos = false_pos + 1;
    elseif test_y(i) ~=-1 && dist >= epsilon(train_y(pred))
        false_negs = false_negs + 1;        
    end
end
disp('Thresholds for each label = ');
disp(sqrt(epsilon));
disp(strcat('False negatives = ', string(false_negs./length(test_y))));
disp(strcat('False positives = ', string(false_pos./length(test_y))));
end