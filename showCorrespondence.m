function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)

img1 = horzcat(orig_img, warped_img);

dest_pts_nx2(:,1) = dest_pts_nx2(:,1) + size(orig_img, 2);
n = size(src_pts_nx2, 1);
color = [ 'g', 'm', 'y'];
%img1 = insertMarker(img1,dest_pts_nx2, 'size', 10);

f1 = figure();
imshow(img1);
hold on;
for i = 1:n
    c = color(mod(i,3)+1);
    line([src_pts_nx2(i,1) dest_pts_nx2(i,1)], ...
        [src_pts_nx2(i,2) dest_pts_nx2(i,2)], 'Color', c);

end
result_img = saveAnnotatedImg(f1);
close(f1);

end