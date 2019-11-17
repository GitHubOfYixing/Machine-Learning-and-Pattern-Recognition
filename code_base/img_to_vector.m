% 将图像转成向量
function data = img_to_vector(img, img_size) 

%************************************************************************************%
img_mat = zeros(1,img_size(1)*img_size(2));
for i=1:img_size(1)
    for j=1:img_size(2)
        img_mat((i-1)*img_size(1)+j) = img(i,j);
    end
end
data = img_mat;





