% ��ȡCPͼ������
function data = get_cp_vector(img) 

%************************************************************************************%
% (1)Ԥ����
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

% ͳ�ư�ɫ��������,����ɫ���ظ���(����)ĳ��ֵʱ,�ϵ���ֵ
bw_num = sum(sum(bw==1));
thresh2 = 0.7*thresh;
while (bw_num/Area < 0.06 || bw_num/Area > 0.12) && thresh2<1
    thresh2 = thresh2 + 0.01;
    bw = imbinarize(gray,thresh2);
    bw_num = sum(sum(bw==1));
end
bw = bwareaopen(bw,double(int32(Area/200)));
bw = imclearborder(bw,8);

% (2)������ĸ
data = letter_separate(bw, 'h > 1.3*height/4');



