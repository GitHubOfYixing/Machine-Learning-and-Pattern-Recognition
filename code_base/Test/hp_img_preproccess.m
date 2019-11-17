% HP图像预处理
function data = hp_img_preproccess(img) 

%************************************************************************************%
% (1)预处理
[height, width, deep] = size(img);
Area = height*width; 
if deep==3
    gray = 255 - uint8(rgb2gray(img));
else
    gray = 255 - uint8(img);
end
% gray = imadjust(gray,[],[],1);
thresh = 0.9*graythresh(gray);
bw = imbinarize(gray,thresh);
bw = bwareaopen(bw,double(int32(Area/500))); 
bw = imclearborder(bw,8);

% 对部分连接在一起的数字进行分离
bw = num_segmentation(bw);

% figure(1)
% imshow(gray)
% figure(2)
% imshow(bw)
% figure(3)

% (2)分割字符
[I_Labeled,~] = bwlabel(bw,4);  
stats = regionprops(I_Labeled,'all');
obj_num = size(stats);
data = [];
if obj_num == 0
    return
end
for index=1:obj_num
    box = stats(index).BoundingBox;
    x = box(:,1);
    y = box(:,2);
    w = box(:,3);
    h = box(:,4);
    bw_img = imcrop(bw,[x-w/8,y-h/8,w+2*w/8,h+2*h/8]); 
    bw_img = imclearborder(bw_img,8);
    
    img_size = [32,32];
    bw_img = imresize(bw_img,img_size);
    % 将图片转换成1024列向量
    data(index,:) = img_to_vector(bw_img, img_size);
    
    % subplot(1,10,index)
    % imshow(bw_img)
end


