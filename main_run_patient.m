clc; clear; close all;
tic;

%% 1. 参数 & 数据
cfg = patient_config('lhs_07');
load(cfg.FileName);
dc = size(X1,1);
totalIterations = size(X1,2)/1024 - 3;

P_all = cell(totalIterations+1,1);

%% 2. 主循环
for t = 0:totalIterations

    datanew = get_sliding_window(X1, t);

    %% 超图
    hyper = build_hypergraph(datanew);

    %% 节点特征
    attr = extract_node_features(datanew, hyper, cfg);

    %% 相似度
    f_uv = compute_node_similarity(attr);

    %% 转移矩阵
    P_all{t+1} = assemble_transition_matrix( ...
        datanew, hyper, f_uv, cfg);

    fprintf('完成窗口 %d / %d\n', t+1, totalIterations+1);
end

save(cfg.savePath, 'P_all');
fprintf('总耗时 %.2f s\n', toc);
