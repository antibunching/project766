
% input image directory, typically more than 5 images are needed
data_dir = 'test_data/set5';

file_list = dir(fullfile(data_dir,'*.jpg'));
file_list = [file_list dir(fullfile(data_dir,'*.JPG'))];
file_names = {file_list.name};
number_of_files = size(file_names,2);

ref_img = imread(fullfile(data_dir,file_names{1}));

scaling = 1/3;
% resize if input images are too large. SIFT takes a long time for large images, 
% for large images, it is more practical to choose correspondence points manually.
if scaling ~= 1
    small_ref_img = imresize(ref_img, scaling, 'bilinear');
else
    small_ref_img = ref_img;
end

[img_h, img_w, ~] = size(small_ref_img);

number_of_imgs = number_of_files;
% override, reduce number of images used for experiment and demo
%number_of_imgs = 3;

ransac_n = 50;
ransac_eps = 0.5;

% the output stack, h * w * 3 color channel * number of input images
output = zeros(img_h, img_w, 3, number_of_imgs, 'uint8'); 
output(:,:,:,1) = uint8(small_ref_img);
for i = 2:number_of_imgs
    img_i = imread(fullfile(data_dir,file_names{i}));
    % resize for faster SIFT
    if scaling ~= 1
        small_img_i = imresize(img_i, scaling, 'bilinear');
    else
        small_img_i = img_i;
    end
    small_img_i = im2double(small_img_i);

    [xs, xd] = genSIFTMatches(small_ref_img, small_img_i, 'VLFeat');
    [~, H] = runRANSAC(xs, xd, ransac_n, ransac_eps);

    [img_h, img_w, ~] = size(small_ref_img);

    [xx, yy] = meshgrid(1:img_w, 1:img_h);
    % similar to backwardwarp in one of the HWs, but instead of computing mask and blend, 
    % here we just insert the values into an array 
    img_pts = applyHomography(H, [xx(:), yy(:)]);
    src_img = double(small_img_i);
    
    %flatten r, g, b so they can work with interp2
    r = src_img(:,:,1);
    g = src_img(:,:,2);
    b = src_img(:,:,3);
    r_d = interp2(1:img_w, 1:img_h, r, img_pts(:,1), img_pts(:,2),'linear',0);
    g_d = interp2(1:img_w, 1:img_h, g, img_pts(:,1), img_pts(:,2),'linear',0);
    b_d = interp2(1:img_w, 1:img_h, b, img_pts(:,1), img_pts(:,2),'linear',0);
    
    r_d = reshape(r_d, [img_h, img_w]);
    g_d = reshape(g_d, [img_h, img_w]);
    b_d = reshape(b_d, [img_h, img_w]);
    

    mapped_img = zeros(img_h, img_w, 3);
    mapped_img(:,:,1) = r_d;
    mapped_img(:,:,2) = g_d;
    mapped_img(:,:,3) = b_d;

    output(:,:,:,i) = floor(mapped_img*256);

end
    % pick the median value in the stack. pixel values of r, g, b might be from 
    % different frames, majority vote algorithm will probably solve the issue. 
    % but it works well most of the times)
    result = median(output(:,:,:,:), 4);
    imshow(result);
