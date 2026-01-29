clc; clear;
close all;

%% ===================== Normal Condition =====================
% Timing
tic;

% Select data file
% FileName = 'D:\wcldematlab\keep\new_idea\gzs\gongzishu_cut06_Gamma.mat';
FileName = 'D:\wcldematlab\keep\new_idea\lhs_cut07\lihongsen_cut07_Gamma.mat';
% FileName = 'D:\wcldematlab\keep\new_idea\wc_cut03\wangchun_cut03_Gamma.mat';
% ...

load(FileName);

dc = size(X1, 1);
totalIterations = size(X1, 2) / 1024 - 3;

for time = 0:totalIterations
    start_point = 1024 * time + 1;
    end_point   = 1024 * (time + 3);
    datanew = X1(:, start_point:end_point);

    % Hyperedge construction
    all_hyperEdges = gain_hyperEdges(datanew);

    % Hypergraph efficiency
    E(time + 1, :) = hypergraph_efficiency(all_hyperEdges);

    fprintf('Iteration %d completed.\n', time + 1);
end

totalElapsedTime = toc;
fprintf('Total runtime: %.2f seconds.\n', totalElapsedTime);

%% ===================== Visualization =====================
colors1 = min([204, 153, 255] / 256 * 1.0, 1);
colors2 = min([51, 153, 255]  / 256 * 1.3, 1);
colors3 = min([128, 128, 128] / 256 * 1.3, 1);
colors4 = min([255, 192, 203] / 256 * 1.0, 1);

figure(3);
plot(E, 'LineWidth', 2, 'Color', colors3); hold on;
plot(E_del, 'LineWidth', 2, 'Color', colors2); hold on;
plot(E_del_del, 'LineWidth', 2, 'Color', colors1); hold on;
plot(E_orind, 'LineWidth', 2, 'Color', colors4);

set(gca, 'TickDir', 'out', 'FontSize', 18);
ylim([0.55 0.95]);
xticks(0:200:600);
box off;

%% ===================== Temporal Segments =====================
preictal  = E(1:200, :);
early     = E(426:450, :);
middle    = E(451:475, :);
late      = E(476:500, :);
postictal = E(501:525, :);

X_1 = [preictal, early, middle, late, postictal];

%% ===================== Remove EZ =====================
clc; clear; close all;
tic;

load(FileName);

% Remove EZ nodes
X1 = X1([2,3,4,5,6,7,8,9,10,11,12,13,14], :);
dc = size(X1, 1);
totalIterations = size(X1, 2) / 1024 - 3;

for time = 0:totalIterations
    start_point = 1024 * time + 1;
    end_point   = 1024 * (time + 3);
    datanew = X1(:, start_point:end_point);

    all_hyperEdges = gain_hyperEdges(datanew);
    E(time + 1, :) = hypergraph_efficiency(all_hyperEdges);

    fprintf('Iteration %d completed.\n', time + 1);
end

fprintf('Total runtime: %.2f seconds.\n', toc);

figure(4);
plot(E, '-o', 'Color', 'k');

%% ===================== Remove EZ & PZ =====================
clc; clear; close all;
tic;

FileName = 'D:\wcldematlab\keep\new_idea\ssh_cut109\ssh_cut109_Gamma.mat';
load(FileName);

X1 = X1([5,6,7,11,12,14], :);
dc = size(X1, 1);
totalIterations = size(X1, 2) / 1024 - 3;

for time = 0:totalIterations
    start_point = 1024 * time + 1;
    end_point   = 1024 * (time + 3);
    datanew = X1(:, start_point:end_point);

    all_hyperEdges = gain_hyperEdges(datanew);
    E(time + 1, :) = hypergraph_efficiency(all_hyperEdges);

    fprintf('Iteration %d completed.\n', time + 1);
end

fprintf('Total runtime: %.2f seconds.\n', toc);

figure(5);
plot(E, '-o', 'Color', 'k');

%% ===================== Ordinary Graph (Pairwise Edges Only) =====================
clc; clear; close all;
tic;

load(FileName);
dc = size(X1, 1);
totalIterations = size(X1, 2) / 1024 - 3;

for time = 0:totalIterations
    start_point = 1024 * time + 1;
    end_point   = 1024 * (time + 3);
    datanew = X1(:, start_point:end_point);

    all_hyperEdges = gain_hyperEdges(datanew);

    % Keep only first-order hyperedges (node pairs)
    filtered_hyperEdges = {};
    for i = 1:length(all_hyperEdges)
        if length(all_hyperEdges{i}) == 2
            filtered_hyperEdges{end+1} = all_hyperEdges{i};
        end
    end

    E(time + 1, :) = hypergraph_efficiency(filtered_hyperEdges);
    fprintf('Iteration %d completed.\n', time + 1);
end

fprintf('Total runtime: %.2f seconds.\n', toc);
