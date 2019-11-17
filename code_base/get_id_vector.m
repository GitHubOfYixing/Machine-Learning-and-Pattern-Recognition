% 获取ID图像向量
function data = get_id_vector(id_img) 

%************************************************************************************%
% (1)预处理
img_size = [32,32];
id_img = imresize(id_img,img_size);
[~,~,deep] = size(id_img);
if deep==3
    id_gray_img = uint8(rgb2gray(id_img));
else
    id_gray_img = uint8(id_img);
end
% (2)灰度图像转成向量
data = img_to_vector(id_gray_img, img_size);





