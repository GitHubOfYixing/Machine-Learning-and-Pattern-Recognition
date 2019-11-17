clc;
clear;
close all;
warning('off');
img_path = '..\pokemon dataset\val\';
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);
% 测试集
img_size = 32;
testSet = zeros(img_num,img_size*img_size);
testLabels = strings(img_num,1);
disp("正在读取测试数据...")
disp(img_num)
true_count = 0;
for index=1:img_num
    img_name = img_dir(index).name;
    path = [img_path, img_name]; 
    img = imread(path);
    [animal_img, cp_img, hp_img, sd_img, ~, ~] = img_extract(img);
    %*******************************************************************************************************%
%     % kmeans方法识别动物图片
%     % (1)将输入图像大小设置为32*32,转为灰度图
%     test_img = imresize(animal_img,[32,32]);
%     [~,~,deep] = size(test_img);
%     if deep==3
%         test_gray_img = rgb2gray(test_img);
%     else
%         test_gray_img = uint8(test_img);
%     end
%     % (2)将32*32大小图片转换成一列大小为1024的向量
%     test_img_mat = zeros(1,1024);
%     for i=1:32
%         for j=1:32
%             test_img_mat((i-1)*32+j) = test_gray_img(i,j);
%         end
%     end
%     testSet(index,:) = test_img_mat;
%     % 记录图像标签
%     testLabel(index,1) = img_name(1:3);
    %*******************************************************************************************************%
%     % 汉明距离方法识别动物图片
%     [label, score] = hamming_recognition_id(animal_img);
%     sprintf("%s - %s - %s",img_name(1:3), label, num2str(score))
%     if strcmp(img_name(1:3), label)
%         true_count = true_count+1;
%     end
%     if index==img_num
%         sprintf("总共%d个,成功识别%d个,准确率为%.2f", index,true_count,true_count/index)
%     end
    %*******************************************************************************************************%
%     % SVM-HOG方法识别动物图片
%     % 输入图像大小为480*480
%     % (1)将输入图像大小设置为48*48,转为灰度图
%     test_img = imresize(animal_img,[48,48]);
%     [~,~,deep] = size(test_img);
%     if deep==3
%         test_gray_img = rgb2gray(test_img);
%     else
%         test_gray_img = uint8(test_img);
%     end 
%     % 提取HOG特征
%     [features, ~] = extractHOGFeatures(test_gray_img);  
%     testFeatures = zeros(img_num,size(features,2),'single'); 
%     testFeatures(index,:) = extractHOGFeatures(test_gray_img);
%     % 存储数据标签（001,002,...,151）
%     testLabels(index,1) = img_name(1:3);
%     disp(testLabels(index,1))
    %*******************************************************************************************************%
    % KNN方法识别动物图片
    % 输入图像大小为480*480
    % (1)将输入图像大小设置为32*32,转为灰度图
    test_img = imresize(animal_img,[img_size, img_size]);
    [~,~,deep] = size(test_img);
    if deep==3
        test_gray_img = rgb2gray(test_img);
    else
        test_gray_img = uint8(test_img);
    end
    % (2)将32*32大小图片转换成一列大小为1024的向量
    test_img_mat = zeros(1,img_size*img_size);
    for i=1:img_size
        for j=1:img_size
            test_img_mat((i-1)*img_size+j) = test_gray_img(i,j);
        end
    end
    testSet(index,:) = test_img_mat;
    % 记录图像标签
    testLabels(index,1) = img_name(1:3); 
    disp(testLabels(index,1))
end
% disp(size(testFeatures));
disp("测试数据读取完成...")
% kmeans聚类
% data = [testSet,testLabel];
% [label, score] = kmeans_recognition_id(data);

% svm分类
% [label, score] = svm_recognition_id(testFeatures, testLabels);

% knn分类
[label, score] = knn_recognition_id(testSet, testLabels);








