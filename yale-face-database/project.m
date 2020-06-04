function OutputName = Recognition(TestImage, m, A, Eigenfaces)
matrixglasses = zeros(77760,15);
scrfile=dir('C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database\*.jpg');
 for k=1:length(scrfile)
    filename=strcat('C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database\',scrfile(k).name);
    x=imread(filename);
    matrixglasses (:,k) = reshape(x,77760,1);
   
 end
M = mean(matrixglasses,2);
Train_Number = size(matrixglasses,2);
A = [];  
for k = 1 : Train_Number
    temp = double(matrixglasses(:,k)) - M; 
    A = [A temp]; 
end
L = A'*A;
[V ,D] = eig(L); 

L_eig_vec = [];
for k = 1 : size(V,2) 
    if( D(k,k)>1 )
        L_eig_vec = [L_eig_vec V(:,k)];
    end
end
Eigenfaces = A * L_eig_vec;

ProjectedImages = [];
Train_Number = size(Eigenfaces,2);
for k = 1 : Train_Number
    temp = Eigenfaces'*A(:,k); 
    ProjectedImages = [ProjectedImages temp]; 
end
InputImage = imread('C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database\testDatabase\5.jpg');
temp = InputImage(:,:,1);
[irow,icol] = size(temp);
InImage = reshape(temp',irow*icol,1);
Difference = double(InImage)-M; % Centered test image
ProjectedTestImage = Eigenfaces'*Difference
Euc_dist = [];
for k = 1 : Train_Number
    q = ProjectedImages(:,k);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    Euc_dist = [Euc_dist temp];
end

[Euc_dist_min , Recognized_index] = min(Euc_dist);
OutputName = strcat(int2str(Recognized_index),'.jpg');
SelectedImage = strcat('C:\Users\NADA EL-SAYED\Downloads\FER-project\yale-face-database','\',OutputName)
SelectedImage = imread(SelectedImage);

imshow(InputImage)
title('Test Image');
figure,imshow(SelectedImage);
title('Equivalent Image');

str = strcat('Matched image is :  ',OutputName);
disp(str)
end
