% ��ȡSDͼ������
function data = get_sd_vector(img) 

%************************************************************************************%
% (1)Ԥ����
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
% (2)������ĸ
data = letter_separate(bw, 'w*h>10');




