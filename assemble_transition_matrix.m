function P = assemble_transition_matrix(datanew, hyper, f_uv, cfg)

move_sim = zeros(hyper.dc);

move_sim = transition_same_hyperedge( ...
    move_sim, hyper, datanew, f_uv);

move_sim = transition_adjacent_hyperedge( ...
    move_sim, hyper, f_uv);

move_sim = transition_indirect_hyperedge( ...
    move_sim, hyper, f_uv);

move_sim = transition_no_connection( ...
    move_sim, hyper, datanew, f_uv);

% 自转移
rowSum = sum(f_uv,2);
for i = 1:hyper.dc
    move_sim(i,i) = 1/(1+rowSum(i));
end

% 行归一化
P = move_sim ./ sum(move_sim,2);
end
