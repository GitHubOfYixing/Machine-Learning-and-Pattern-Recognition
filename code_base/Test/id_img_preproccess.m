% IDͼ��Ԥ����
function data = id_img_preproccess(img) 

%************************************************************************************%
% ����ͼ���СΪ480*480
% (1)������ͼ���С����Ϊ32*32,תΪ�Ҷ�ͼ
img_size = 32;
img = imresize(img,[img_size, img_size]);
[~,~,deep] = size(img);
if deep==3
    gray_img = uint8(rgb2gray(img));
else
    gray_img = uint8(img);
end
% (2)��32*32��СͼƬת����һ�д�СΪ1024������
img_mat = zeros(1,img_size*img_size);
for i=1:img_size
    for j=1:img_size
        img_mat((i-1)*img_size+j) = gray_img(i,j);
    end
end
data = img_mat;

