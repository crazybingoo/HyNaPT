%%
clc; clear;
close all;

%% ===================== Load Transition Probability Matrices =====================
load('D:\wcldematlab\keep\new_idea\3-1month\lhs_07\Q_ij.mat');
load('D:\wcldematlab\keep\new_idea\3-1month\lhs_07\Q_ij_1.mat');
load('D:\wcldematlab\keep\new_idea\3-1month\lhs_07\Q_ij_2.mat');

% Alternative datasets (uncomment as needed)
% load('...\ssh_110\Q_ij.mat');
% load('...\ssh_110\Q_ij_1.mat');
% load('...\ssh_110\Q_ij_2.mat');
% ...

%% ===================== Temporal Difference Computation =====================
tt = 597;   % Number of time windows

delta_Q  = zeros(tt, 1);
delta_Q1 = zeros(tt, 1);
delta_Q2 = zeros(tt, 1);

% Frobenius norm of transition matrix differences
for t = 1:(tt - 1)
    delta_Q(t)  = norm(Q_ij{t}   - Q_ij{t+1},   'fro');
    delta_Q1(t) = norm(Q_ij_1{t} - Q_ij_1{t+1}, 'fro');
    delta_Q2(t) = norm(Q_ij_2{t} - Q_ij_2{t+1}, 'fro');
end

% Remove NaN values
delta_Q  = delta_Q(~isnan(delta_Q));
delta_Q1 = delta_Q1(~isnan(delta_Q1));
delta_Q2 = delta_Q2(~isnan(delta_Q2));

%% ===================== Statistical Indicators =====================
% Mean and standard deviation
mu(10, :)     = mean(delta_Q);
mu1(10, :)    = mean(delta_Q2);
muR(10, :)    = mean(delta_Q1);

sigma(10, :)  = std(delta_Q);
sigma1(10, :) = std(delta_Q2);
sigmaR(10, :) = std(delta_Q1);

% Coefficient of variation
mu_data     = [mu, mu1, muR];
sigma_data  = [sigma, sigma1, sigmaR];
CV_data     = sigma_data ./ mu_data;

%% ===================== Patient-Level Aggregation =====================
for i = 1:10
    all_results{1, i} = ...
        [mu_data(i, :); sigma_data(i, :); CV_data(i, :)];
end

num_patients = numel(all_results);
all_data = cat(3, all_results{:});

% Reformat dimensions for visualization
for i = 1:size(all_data, 3)
    all_data(:, :, i) = all_data(:, :, i)';
end

% Swap rows to match desired order
for i = 1:size(all_data, 3)
    tmp = all_data(2, :, i);
    all_data(2, :, i) = all_data(3, :, i);
    all_data(3, :, i) = tmp;
end

mean_data = mean(all_data, 3);
std_data  = std(all_data, 0, 3);

%% ===================== Grouped Bar Plot =====================
figure; hold on;

b = bar(mean_data', 'grouped');

colors = [
    127/256 101/256 159/256;   % HyNaPT
    9/256   133/256 156/256;   % HyNaPT-R
    166/256 166/256 166/256    % HyNaPT-1
];

for i = 1:3
    b(i).FaceColor = colors(i,:);
    b(i).FaceAlpha = 0.6;
    b(i).EdgeColor = 'none';
end

set(gca, ...
    'XTick', 1:3, ...
    'XTickLabel', {'\mu', '\sigma', 'CV'}, ...
    'FontName', 'Helvetica', ...
    'FontSize', 18);

legend({'HyNaPT', 'HyNaPT-R', 'HyNaPT-1'}, ...
       'Location', 'eastoutside', ...
       'Box', 'off', ...
       'FontSize', 16);

ylim([0 1]);
set(gca, 'TickDir', 'out');
box off;

%% ===================== Error Bars =====================
ngroups = size(mean_data, 2);
nbars   = size(mean_data, 1);
groupwidth = min(0.8, nbars / (nbars + 1.5));

for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i - 1)*groupwidth/(2*nbars);
    y = mean_data(i, :);
    err = std_data(i, :);

    errorbar(x, y, err, 'k', ...
        'LineStyle', 'none', 'LineWidth', 0.5, 'HandleVisibility', 'off');
end

%% ===================== Scatter Overlay =====================
scatter_size = 50;
jitter = 0.05;

for method = 1:3
    for metric = 1:3
        x_pos = (metric - groupwidth/2 + ...
            (2*method - 1)*groupwidth/(2*nbars)) + ...
            jitter*(rand(10,1) - 0.5);

        y_data = squeeze(all_data(method, metric, :));
        scatter(x_pos, y_data, scatter_size, ...
            colors(method,:), 'filled', ...
            'MarkerEdgeColor', 'k', ...
            'HandleVisibility', 'off');
    end
end

%% ===================== Statistical Tests =====================
[~, p_mu_1] = ttest2(mu_data(:,1), mu_data(:,2));
[~, p_mu_2] = ttest2(mu_data(:,2), mu_data(:,3));
[~, p_mu_3] = ttest2(mu_data(:,1), mu_data(:,3));

[~, p_sigma_1] = ttest2(sigma_data(:,1), sigma_data(:,2));
[~, p_sigma_2] = ttest2(sigma_data(:,2), sigma_data(:,3));
[~, p_sigma_3] = ttest2(sigma_data(:,1), sigma_data(:,3));

[~, p_cv_1] = ttest2(CV_data(:,1), CV_data(:,2));
[~, p_cv_2] = ttest2(CV_data(:,2), CV_data(:,3));
[~, p_cv_3] = ttest2(CV_data(:,1), CV_data(:,3));

%% ===================== Temporal Visualization =====================
figure;
plot(delta_Q,  'LineWidth', 2); hold on;
plot(delta_Q1, 'LineWidth', 2);
plot(delta_Q2, 'LineWidth', 2);
hold off;

set(gca, 'TickDir', 'out', 'FontSize', 18);
box off;
