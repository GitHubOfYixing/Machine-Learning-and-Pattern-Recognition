% 获取CP图像向量
function data = get_cp_vector(img) 

%************************************************************************************%
% (1)预处理
[height, width, deep] = size(img);
Area = height*width; 
if deep==3
    gray = uint8(rgb2gray(img));
else
    gray = uint8(img);
end
gray = imadjust(gray,[],[],2); 
thresh = graythresh(gray);
bw = imbinarize(gray,thresh);

% 统计白色像素数量,当白色像素高于(低于)某个值时,上调阈值
bw_num = sum(sum(bw==1));
thresh2 = 0.7*thresh;
while (bw_num/Area < 0.06 || bw_num/Area > 0.12) && thresh2<1
    thresh2 = thresh2 + 0.01;
    bw = imbinarize(gray,thresh2);
    bw_num = sum(sum(bw==1));
end
bw = bwareaopen(bw,double(int32(Area/200)));
bw = imclearborder(bw,8);

% (2)分离字母
data = letter_separate(bw, 'h > 1.3*height/4');



