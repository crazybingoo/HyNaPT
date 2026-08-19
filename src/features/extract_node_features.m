function attr = extract_node_features(signal, hyper)
%EXTRACT_NODE_FEATURES Compute the manuscript node-attribute vector.
%   Clinical zone labels are deliberately excluded. They may initialize a
%   downstream propagation experiment but are not node attributes.

attr.hyperdegree = normalize_feature(hyper.degree);
attr.meanPLV = normalize_feature(mean(hyper.pairwisePLV, 2));
attr.logHFO = normalize_feature(log1p(compute_HFO_PSD(signal)));
attr.logAmpMax = normalize_feature(log1p(max(abs(signal), [], 2)));
attr.logAmpMean = normalize_feature(log1p(mean(abs(signal), 2)));
[pac, ~] = compute_PAC(signal);
attr.PAC = normalize_feature(pac);

attr.matrix = [attr.hyperdegree(:), attr.meanPLV(:), attr.logHFO(:), ...
    attr.logAmpMax(:), attr.logAmpMean(:), attr.PAC(:)];
end
