function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)

n = size(src_pts_nx2, 1);
s = horzcat(src_pts_nx2, ones(n,1));
p = H_3x3 * s';
p = p';
p = p(:, 1:2) ./ p(:,3);
dest_pts_nx2 = p;
end