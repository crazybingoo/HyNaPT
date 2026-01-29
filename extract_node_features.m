function attr = extract_node_features(datanew, hyper, cfg)

attr.R_zone = cfg.R_zone;

attr.hyperdegree = normalize_feature(hyper.degree);

attr.meanPLV = normalize_feature( ...
    Average_Connection_Strength(datanew));

attr.avgPath = normalize_feature( ...
    hypergraph_avg_shortest_path(hyper.edges, hyper.dc));

attr.psd_hfo = normalize_feature( ...
    compute_HFO_PSD(datanew));

attr.amp_max = normalize_feature(max(abs(datanew),[],2));
attr.amp_mean = normalize_feature(mean(abs(datanew),2));

[~, PAC] = compute_PAC(datanew);
attr.PAC = normalize_feature(PAC);

attr.matrix = struct2array(attr)';
end
