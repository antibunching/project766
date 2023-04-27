img1_name = 'test_data/set1/DSC_0830.JPG';
img2_name = 'test_data/set1/DSC_0831.JPG';

img1_name = 'test_data/set2/DSC_0842.JPG';
img2_name = 'test_data/set2/DSC_0843.JPG';
img1_name = 'test_data/set7/DSC_0893.JPG';
img2_name = 'test_data/set7/DSC_0894.JPG';

img1_name = 'test_data/set6/DSC_0889.JPG';
img2_name = 'test_data/set6/DSC_0890.JPG';
img1_name = 'test_data/set8/PXL_20230426_221749325.jpg';
img2_name = 'test_data/set8/PXL_20230426_221753200.jpg';

img1 = imread(img1_name);
img2 = imread(img2_name);

%genSIFTMatches takes a long time if we use
%images in their original size. 
img1_small = imresize(img1, 1/2, 'bilinear');
img2_small = imresize(img2, 1/2, 'bilinear');

[xs, xd] = genSIFTMatches(img1_small, img2_small);


ransac_n = 100;
eps = 1;
[inliers_id, H] = runRANSAC(xs, xd, ransac_n, eps);

%select points to show
xs_inlier = xs(inliers_id, :);
xd_inlier = xd(inliers_id, :);
sample_indices = randi([1, size(xs_inlier,1)], 1, 50);
n1 = 1;
n2 = 19;
sample_indices = n1:(n1+n2);

%select points to show
xs1 = xs(:,:);
xd1 = xd(:,:);

%ret = showCorrespondence(img1_small, img2_small, xs1(sample_indices,:), xd1(sample_indices,:));
%imwrite(ret, 'sift_match1.png');
%imshow(ret);
ret = img2;
pos = horzcat(xd1*5,ones(size(xd1,1),1)*10);
%ret = insertShape(ret,"FilledCircle",pos,Opacity=1,Color='green');
%imwrite(ret, 'sift_match2.png');

xs1 = xs_inlier(:,:);
xd1 = xd_inlier(:,:);

pos = horzcat(xd1*5,ones(size(xd1,1),1)*10);
%ret = insertShape(img2,'FilledCircle',pos,Color='green');
%imwrite(ret, 'sift_match_ransac2.png');
%ret = showCorrespondence(img1_small, img2_small, xs1(sample_indices,:), xd1(sample_indices,:));
%imwrite(ret, 'sift_match_ransac1.png');

xs1 = [625 500];
xd1 = applyHomography(H, xs1);
ret = showCorrespondence(img1_small, img2_small, xs1,xd1);
imwrite(ret, 'sift_match.png');
