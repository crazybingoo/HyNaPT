%%
clc; clear;
close all;

%% ===================== Motivation =====================
% This script explores node fragility and seizure-stage-dependent
% vulnerability patterns using transition probability matrices Q_ij.
% The goal is to identify seizure-related nodes and propagation modes
% before, during, and after seizures.

%% ===================== Parameter Settings =====================
epsilon = 1e-6;     % Small constant to avoid log(0)
num_nodes = 18;
num_windows = length(Q_ij);

% Initialize output matrices (nodes × time windows)
entropy_mat     = zeros(num_nodes, num_windows);   % Diffusion-driven entropy
sensitivity_mat = zeros(num_nodes, num_windows);   % Incoming probability (sensitivity)
betweenness_mat = zeros(num_nodes, num_windows);   % Shortest-path betweenness

%% ===================== Main Loop =====================
for t = 1:num_windows
    Q = Q_ij{t};    % Transition probability matrix at time window t

    %% --- 1. Diffusion-Driven Entropy (Outgoing) ---
    % Each row represents the outgoing diffusion distribution of a node
    H = -sum(Q .* log(Q + epsilon), 2);
    entropy_mat(:, t) = H;

    %% --- 2. Sensitivity Score (Incoming) ---
    % Column sum reflects how much a node is driven by others
    S = sum(Q, 1);
    sensitivity_mat(:, t) = S';

    %% --- 3. Betweenness Centrality (Diffusion Paths) ---
    % Convert probabilities to costs
    W = -log(Q + epsilon);
    G = digraph(W);
    B = centrality(G, 'betweenness', 'Cost', G.Edges.Weight);
    betweenness_mat(:, t) = B;
end

%% ===================== Global Heatmaps =====================
figure;
subplot(3,1,1);
imagesc(entropy_mat); colorbar; colormap('turbo');
set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'XTick', []);

subplot(3,1,2);
imagesc(sensitivity_mat); colorbar;
set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'XTick', []);

subplot(3,1,3);
imagesc(betweenness_mat); colorbar;
set(gca, 'FontSize', 10, 'FontWeight', 'bold');

%% ===================== Focused Temporal Window =====================
x_range = 100:500;
x_vals = x_range;

figure('Position', [100, 100, 1500, 600]);
tiledlayout(3,1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Entropy
ax1 = nexttile;
imagesc(x_vals, 1:num_nodes, entropy_mat(:, x_range));
set(ax1, 'FontSize', 14, 'FontWeight', 'bold', 'XTick', []);
ax1.FontName = 'Times New Roman';
colorbar;

% Sensitivity
ax2 = nexttile;
imagesc(x_vals, 1:num_nodes, sensitivity_mat(:, x_range));
set(ax2, 'FontSize', 14, 'FontWeight', 'bold', 'XTick', []);
ax2.FontName = 'Times New Roman';
colorbar;

% Betweenness
ax3 = nexttile;
imagesc(x_vals, 1:num_nodes, betweenness_mat(:, x_range));
set(ax3, 'FontSize', 14, 'FontWeight', 'bold');
xticks(100:100:500);
ax3.FontName = 'Times New Roman';
colorbar;

%% ===================== Node-Level Temporal Dynamics =====================
time = 1:num_windows;

colors1 = min([204/256, 153/256, 255/256], 1);
colors2 = min([51/256, 153/256, 255/256] * 1.3, 1);

figure;
tiledlayout(3,1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Entropy
nexttile;
plot(time, entropy_mat(6,:), 'LineWidth', 1.5, 'Color', colors2); hold on;
plot(time, entropy_mat(10,:), 'LineWidth', 1.5, 'Color', colors1);
axis off;

% Sensitivity
nexttile;
plot(time, sensitivity_mat(6,:), 'LineWidth', 1.5, 'Color', colors2); hold on;
plot(time, sensitivity_mat(10,:), 'LineWidth', 1.5, 'Color', colors1);
axis off;

% Betweenness
nexttile;
plot(time, betweenness_mat(6,:), 'LineWidth', 1.5, 'Color', colors2); hold on;
plot(time, betweenness_mat(10,:), 'LineWidth', 1.5, 'Color', colors1);
box off;

%% ===================== Channel Comparison =====================
figure('Position', [100, 100, 800, 400]);
hold on;

x_range = 100:500;
y1 = entropy_mat(5, x_range);
y2 = entropy_mat(9, x_range);

p1 = plot(x_range, y1, 'r-', 'LineWidth', 2);
p2 = plot(x_range, y2, 'b-.', 'LineWidth', 1.8, ...
          'MarkerIndices', 1:20:length(x_range), 'MarkerSize', 5);

legend([p1, p2], {'Channel 5', 'Channel 9'}, ...
       'Location', 'northeast', 'Box', 'off');

ylabel('H_i^{out}(t)', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'TickDir', 'out', 'XLim', [100, 500]);
grid on;
box on;
