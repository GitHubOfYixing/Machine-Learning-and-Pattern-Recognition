% ID图像预处理
function data = id_img_preproccess(img) 

%************************************************************************************%
% 输入图像大小为480*480
% (1)将输入图像大小设置为32*32,转为灰度图
img_size = 32;
img = imresize(img,[img_size, img_size]);
[~,~,deep] = size(img);
if deep==3
    gray_img = uint8(rgb2gray(img));
else
    gray_img = uint8(img);
end
% (2)将32*32大小图片转换成一列大小为1024的向量
img_mat = zeros(1,img_size*img_size);
for i=1:img_size
    for j=1:img_size
        img_mat((i-1)*img_size+j) = gray_img(i,j);
    end
end
data = img_mat;

