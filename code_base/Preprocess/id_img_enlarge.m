% ԭʼ���ݲ���ʱ��������������
clc;
clear;
close all;
warning('off');
%****************************************************************************************************%
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
%************************************************************************************************%
% ͳ��ÿ������������ѵ����������
img_num = zeros(doc_num,1);
for i=1:doc_num
    % '..\pokemon dataset\img_train_set\001\'
    img_path = strcat(doc_path,doc_dir(i).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num(i) = length(img_dir);
end
% �����������
disp(max(img_num))
% ��ÿ��������������������䵽30��
samples_num = 30;
% ���䷽�����Ҷ�ֵ�üӼ�; ͼ��ĶԳƲ���
for i=1:doc_num
    % '..\pokemon dataset\img_train_set\001\'
    img_path = strcat(doc_path,doc_dir(i).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    num = img_num;
    while num<samples_num
        % ���ѡ��һ�����е�ͼƬ��Ϊ�����׼
        % unidrnd(img_num,1): ����һ��(1,img_num)֮���СΪ1���������
        % unifrnd(2,img_num,1): ����һ��(2,img_num)֮���СΪ1���������
        % ���ѡ���׼ͼƬ(ֻѡ��ԭʼͼƬ��Ϊ��׼ͼƬ)
        temp1 = floor(unifrnd(1,img_num,1));
        % disp(temp1)
        img = imread([img_path, img_dir(temp1).name]);
        disp(img_dir(temp1).name)
        % subplot(1,3,1)
        % imshow(img)
        % ����任�Ҷ�
        temp2 = floor(unifrnd(-20,20,1));
        % disp(temp2)
        random_img = img + temp2;
        % subplot(1,3,2)
        % imshow(random_img)
        % ����Գ�ͼƬ
        temp3 = floor(unifrnd(1,3,1));
        % disp(temp3)
        if temp3==1
            symmetry_img = fliplr(random_img(:,:));
        else
            symmetry_img = random_img;
        end
        % subplot(1,3,3)
        % imshow(symmetry_img)
        % д��������
        flag = find(img_dir(temp1).name == '.');
        name = img_dir(temp1).name;
        name = name(1:flag-1);
        imwrite(symmetry_img,strcat(img_path,name,'_',num2str(num),'.jpg'));
        % ���¼�����������
        dir_num = dir([img_path,'*.*g']);
        num = length(dir_num);
    end
end




