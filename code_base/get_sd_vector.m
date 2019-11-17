% 获取SD图像向量
function data = get_sd_vector(img) 

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
thresh = 1.2*graythresh(gray);
bw = imbinarize(gray,thresh);
bw = bwareaopen(bw,double(int32(Area/400))); 
bw = imclearborder(bw,8);
% (2)分离字母
data = letter_separate(bw, 'w*h>10');




