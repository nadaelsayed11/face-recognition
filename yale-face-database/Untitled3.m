 clear all; 
 close all;
 clc;
input_dir = 'C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database';
image_dims = [243,320];
 
filenames = dir(fullfile(input_dir, '*.jpg'));
num_images = numel(filenames);
images = [];
for n = 1:num_images
    filename = fullfile(input_dir, filenames(n).name);
    img = imread(filename);
   img3 = reshape(img,prod(image_dims),1);
    if n == 1
        images = zeros(prod(image_dims), num_images);
    end
    images(:, n) = img3(:);
end
% % steps 1 and 2: find the mean image and the mean-shifted input images
 mean_face = mean(images, 2);
shifted_images = images - repmat(mean_face, 1, num_images);
% 
 [evectors, score, evalues] = pca(images');
%  
% 
 num_eigenfaces = 20;
 evectors = evectors(:,1:num_eigenfaces);
% % step 6: project the images into the subspace to generate the feature vectors
 features = evectors' * shifted_images;
% 
global x
 input_image = imread(x);
%  input_image2 = reshape(input_image,prod(image_dims),1);
 feature_vec = evectors' * (double(input_image(:)) - mean_face);
 similarity_score = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vec)), 1:num_images);
%  
% 
[match_score, match_ix] = max(similarity_score);
%figure,imshow([ input_image reshape(images(:,match_ix),image_dims)]);
%title(sprintf('matches%s,score%f',filenames(match_ix).name,-match_score));
%  
% 
% 
% OutputName = strcat(int2str(match_ix),'.jpg');
% SelectedImage = strcat('D:\project\data 1','\',OutputName);
% SelectedImage = imread(SelectedImage);
% 
%  imshow(input_image)
%  title('Test Image');
%  figure,imshow(SelectedImage);
%  title('Equivalent Image');

% str = strcat('Matched image is :  ',OutputName);
% disp(str)

% a = imread('1.jpg');
% a = imresize(a,0.4);
% detector = vision.CascadeObjectDetector('EyePairBig');
% 
% detector.MergeThreshold=20;
% 
% bbox = step(detector, a);
% B = insertObjectAnnotation(a,'rectangle',bbox,'EyePairBig');
% imshow(B);
% a = imread('1.jpg');
% a = imresize(a,0.4);
% detector = vision.CascadeObjectDetector('Mouth');
% 
% detector.MergeThreshold=50;
% 
% bbox = step(detector, a);
% B = insertObjectAnnotation(a,'rectangle',bbox,'Mouth');
% imshow(B);
% a = imread('1.jpg');
% a = imresize(a,0.4);
% detector = vision.CascadeObjectDetector('Nose');
% 
% detector.MergeThreshold=50;
% 
% bbox = step(detector, a);
% B = insertObjectAnnotation(a,'rectangle',bbox,'Nose');
% imshow(B);