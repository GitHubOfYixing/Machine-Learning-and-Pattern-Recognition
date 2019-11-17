% SD图像预处理
function data = sd_img_preproccess(img) 

%************************************************************************************%
% (1)预处理
[height, width, deep] = size(img);
Area = height*width; 
if deep==3
    gray = 255 - uint8(rgb2gray(img));
else
    gray = 255 - uint8(img);
end    
gray = imadjust(gray,[],[],1);
thresh = 1.1*graythresh(gray);
bw = imbinarize(gray,thresh);
bw = bwareaopen(bw,double(int32(Area/400))); 
bw = imclearborder(bw,8);

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
if obj_num==0
    return
end
for index=1:obj_num
    box = stats(index).BoundingBox;
    x = box(:,1);
    y = box(:,2);
    w = box(:,3);
    h = box(:,4);
    if w*h>10
        num_img = imcrop(bw,[x-w/8,y-h/8,w+2*w/8,h+2*h/8]); 
        num_img = imclearborder(num_img,8);
        img_size = 32;
        num_img = imresize(num_img,[img_size,img_size]);
        % subplot(1,5,index)
        % imshow(num_img)   
        % 将32*32大小图片转换成一列大小为1024的向量
        img_mat = zeros(1,img_size*img_size);
        for i=1:img_size
            for j=1:img_size
                img_mat((i-1)*img_size+j) = num_img(i,j);
            end
        end
        data(index,:) = img_mat;
    end
end


