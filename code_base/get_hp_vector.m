% ��ȡHPͼ������
function data = get_hp_vector(img) 

%************************************************************************************%
% (1)Ԥ����
[height, width, deep] = size(img);
Area = height*width; 
if deep==3
    gray = 255 - uint8(rgb2gray(img));
else
    gray = 255 - uint8(img);
end
thresh = 0.9*graythresh(gray);
bw = imbinarize(gray,thresh);
bw = bwareaopen(bw,double(int32(Area/500))); 
bw = imclearborder(bw,8);
% bw1 = bw;

% (2)�Բ���������һ������ֽ��з���
bw = letter_segmentation(bw);
% figure(1)
% subplot(1,2,1)
% imshow(bw1)
% subplot(1,2,2)
% imshow(bw)
% (3)������ĸ
data = letter_separate(bw, '2>1');


