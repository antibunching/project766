function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)

n = size(src_pts_nx2,1);
zero_padding = zeros(n, 3);
one_padding = ones(n, 1);

col1_3 = horzcat(src_pts_nx2, [one_padding zero_padding]);
col1_3 = reshape(col1_3', [3 2*n]);
col1_3 = col1_3';
col4_6 = horzcat(zero_padding, [src_pts_nx2, one_padding]);
col4_6 = reshape(col4_6', [3 2*n]);
col4_6 = col4_6';
%dest_pts_nx2
dest_pts_flattened = reshape(dest_pts_nx2', [], 1);
src_x_repeat = src_pts_nx2(:,1);
src_x_repeat = repelem(src_x_repeat, 2);
src_y_repeat = src_pts_nx2(:,2);
src_y_repeat = repelem(src_y_repeat,2);
col_7 = -dest_pts_flattened.*src_x_repeat;
col_8 = -dest_pts_flattened.*src_y_repeat;
col_9 = -dest_pts_flattened;

A = horzcat(col1_3, col4_6, col_7, col_8, col_9);
[v, ~] = eig(A'*A);
H_3x3 = reshape(v(:,1), 3, 3)';

end