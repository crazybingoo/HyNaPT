function f_uv = compute_node_similarity(attr)
f_uv = GK_Similarity(attr.matrix);
f_uv(1:size(f_uv,1)+1:end) = 0;
end
