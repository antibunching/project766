function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
rng(now);
sample_indices = randi([1, size(Xs,1)], 1, ransac_n*4);

inliers_id = [];
for i = 1:ransac_n
    src_pts = Xs(sample_indices(i:i+3),:);
    dest_pts = Xd(sample_indices(i:i+3),:);
    H_temp = computeHomography(src_pts, dest_pts);

    computed_dest_pts = applyHomography(H_temp, Xs);
    err = vecnorm(computed_dest_pts - Xd, 2, 2);
    inliers_id_temp = find(err < eps);
    
    if size(inliers_id_temp,1) > size(inliers_id,1)
        inliers_id = inliers_id_temp;
        H = H_temp;
    end
end

end