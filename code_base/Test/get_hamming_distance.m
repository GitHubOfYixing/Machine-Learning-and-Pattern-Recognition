clc;
clear;
close all;
%***************************************************************************% 
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
%***************************************************************************% 
% 平均哈希算法
for j=1:doc_num
    img_path = strcat(doc_path, doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.jpg']);
    img_num = length(img_dir);
    disp(doc_dir(j).name)
    % 存储图片指纹
    dim = 16;
    one_vector = zeros(img_num,dim*dim);
    for i=1:img_num
        % 获取图片名称
        img = imread([img_path, img_dir(i).name]);
        % 计算图片的指纹
        % (1)将图片大小设置为8x8大小
        img = imresize(img, [dim, dim]);
        [~,~,deep] = size(img);
        % (2)转换成64级灰度图像
        if deep==3
            gray_64 = uint8(floor(rgb2gray(img)/2));
        else
            gray_64 = uint8(floor(img/2));
        end
        % (3)计算灰度像素平均值
        mean_gray_64 = mean(mean(gray_64));
        % (4)将小于平均值的像素值置0，大于平均值的像素置1
        gray_64(gray_64<mean_gray_64) = 0;
        gray_64(gray_64>=mean_gray_64) = 1;
        gray_2 = gray_64;
        % (5)将二值图像矩阵从上到下，从左到右平铺为一维向量
        gray_2t = gray_2';
        one_vector(i,:) = gray_2t(:)';
        % (6)将一维向量转换成哈希值字符串
        hash_num = num2str(one_vector(i,1));
        for k=2:length(one_vector(i,:))
            hash_num = strcat(hash_num, num2str(one_vector(i,k))); 
        end
    end
    % 将变量one_vector保存到xxx.mat数据文件中
    % 对one_vector中数据进行与运算，生成该图像的通用指纹
    save(strcat('..\pokemon dataset\img_feature_set\',doc_dir(j).name,'.mat'), 'one_vector')
end
