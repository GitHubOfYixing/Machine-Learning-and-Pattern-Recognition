% 原始数据不足时，进行数据扩充
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
% 统计每个动物所给的训练样本数量
img_num = zeros(doc_num,1);
for i=1:doc_num
    % '..\pokemon dataset\img_train_set\001\'
    img_path = strcat(doc_path,doc_dir(i).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num(i) = length(img_dir);
end
% 最大样本数量
disp(max(img_num))
% 将每个动物的样本数量都扩充到30个
samples_num = 30;
% 扩充方法：灰度值得加减; 图像的对称操作
for i=1:doc_num
    % '..\pokemon dataset\img_train_set\001\'
    img_path = strcat(doc_path,doc_dir(i).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    num = img_num;
    while num<samples_num
        % 随机选择一张已有的图片作为扩充基准
        % unidrnd(img_num,1): 产生一个(1,img_num)之间大小为1的随机整数
        % unifrnd(2,img_num,1): 产生一个(2,img_num)之间大小为1的随机整数
        % 随机选择基准图片(只选择原始图片作为基准图片)
        temp1 = floor(unifrnd(1,img_num,1));
        % disp(temp1)
        img = imread([img_path, img_dir(temp1).name]);
        disp(img_dir(temp1).name)
        % subplot(1,3,1)
        % imshow(img)
        % 随机变换灰度
        temp2 = floor(unifrnd(-20,20,1));
        % disp(temp2)
        random_img = img + temp2;
        % subplot(1,3,2)
        % imshow(random_img)
        % 随机对称图片
        temp3 = floor(unifrnd(1,3,1));
        % disp(temp3)
        if temp3==1
            symmetry_img = fliplr(random_img(:,:));
        else
            symmetry_img = random_img;
        end
        % subplot(1,3,3)
        % imshow(symmetry_img)
        % 写入新样本
        flag = find(img_dir(temp1).name == '.');
        name = img_dir(temp1).name;
        name = name(1:flag-1);
        imwrite(symmetry_img,strcat(img_path,name,'_',num2str(num),'.jpg'));
        % 重新计算样本数量
        dir_num = dir([img_path,'*.*g']);
        num = length(dir_num);
    end
end




