clc;
clear;
close all;

img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\014_CP117_HP44_SD1300_3057_26.PNG");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\001_CP130_HP28_SD600_3757_1.PNG");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\010_CP10_HP10_SD200_6050_1.JPG");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\019_CP10_HP10_SD200_6050_40.JPG");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\039_CP109_HP68_SD600_7729_40.jpg");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\048_CP222_HP49_SD800_6050_28.JPG");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\067_CP167_HP41_SD400_7745_17.jpg");
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\091_CP494_HP42_SD1000_7745_11.jpg"); % �޷�ʶ��H(1.3)
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\145_CP7000_HP1298_SD300_6050_24.JPG"); % �޷�ʶ��H
% img = imread("D:\����ѧϰ��ģʽʶ��\pokemon dataset\val\151_CP2769_HP88_SD1900_6050_23.JPG"); % �޷�ʶ��H(1.3)

[id_img, cp_img, hp_img, sd_img, cir_img, cir_img_pos] = img_extract(img);
[height, width, deep] = size(hp_img);
Area = height*width; 
if deep==3
    gray = 255 - uint8(rgb2gray(hp_img));
else
    gray = 255 - uint8(hp_img);
end
% gray = imadjust(gray,[],[],1);
thresh = 0.95*graythresh(gray);
bw = imbinarize(gray,thresh);
bw = imclearborder(bw,8);
bw_fill = imfill(bw,'holes');
figure(1)
imshow(bw_fill)

% ��ɨ��ָ��㷨
f_num = zeros(height,1,'int8');
% ͳ��ÿһ�а�ɫ���صĸ���
for i=1:width
    f_num(i) = sum(bw_fill(:,i));
end
figure(2)
plot(1:width,f_num,'-')

% ������ɢ���ݼ�ֵ
value = sign(diff(f_num));
value(value==-1)='A';
value(value==0)='O';
value(value==1)='B';
str = char(value)';
% ƥ��O�ַ����ٳ���0��
pat = 'A[O]{0,}+B';
% �����ݶ��½���������ʼλ��
[pos_start, pos_end, substr] = regexpi(str,pat,'start','end','match');
hold on
plot(pos_start+1, f_num(pos_start+1), '*')
hold off

% ͳ���ݶ��½�������,���ݶ���������
zero_num = pos_end-pos_start-1;
X_pos = pos_start+1
% disp(zero_num)
% �ж�H�ַ���λ��
if length(zero_num)>2
    if zero_num(1)>zero_num(end-2)
        % ȷ���ָ��ߵ�λ��
        H_pos = X_pos(1);
        X_pos = X_pos(2:end);
    else
        H_pos = X_pos(end-1);
        X_pos = X_pos(1:end-2);
    end
else
    H_pos = 1;
    X_pos = 1;
end
Y_pos = f_num(X_pos)'
X_pos = X_pos(Y_pos<f_num(H_pos))

bw(:,X_pos) = zeros(height,length(X_pos),'int8');

figure(3)
imshow(bw)






