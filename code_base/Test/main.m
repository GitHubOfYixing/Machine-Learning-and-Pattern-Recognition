clc;
clear;
close all;
warning('off');
img_path = '..\pokemon dataset\val\';
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);
% ���Լ�
img_size = 32;
testSet = zeros(img_num,img_size*img_size);
testLabels = strings(img_num,1);
disp("���ڶ�ȡ��������...")
disp(img_num)
true_count = 0;
for index=1:img_num
    img_name = img_dir(index).name;
    path = [img_path, img_name]; 
    img = imread(path);
    [animal_img, cp_img, hp_img, sd_img, ~, ~] = img_extract(img);
    %*******************************************************************************************************%
%     % kmeans����ʶ����ͼƬ
%     % (1)������ͼ���С����Ϊ32*32,תΪ�Ҷ�ͼ
%     test_img = imresize(animal_img,[32,32]);
%     [~,~,deep] = size(test_img);
%     if deep==3
%         test_gray_img = rgb2gray(test_img);
%     else
%         test_gray_img = uint8(test_img);
%     end
%     % (2)��32*32��СͼƬת����һ�д�СΪ1024������
%     test_img_mat = zeros(1,1024);
%     for i=1:32
%         for j=1:32
%             test_img_mat((i-1)*32+j) = test_gray_img(i,j);
%         end
%     end
%     testSet(index,:) = test_img_mat;
%     % ��¼ͼ���ǩ
%     testLabel(index,1) = img_name(1:3);
    %*******************************************************************************************************%
%     % �������뷽��ʶ����ͼƬ
%     [label, score] = hamming_recognition_id(animal_img);
%     sprintf("%s - %s - %s",img_name(1:3), label, num2str(score))
%     if strcmp(img_name(1:3), label)
%         true_count = true_count+1;
%     end
%     if index==img_num
%         sprintf("�ܹ�%d��,�ɹ�ʶ��%d��,׼ȷ��Ϊ%.2f", index,true_count,true_count/index)
%     end
    %*******************************************************************************************************%
%     % SVM-HOG����ʶ����ͼƬ
%     % ����ͼ���СΪ480*480
%     % (1)������ͼ���С����Ϊ48*48,תΪ�Ҷ�ͼ
%     test_img = imresize(animal_img,[48,48]);
%     [~,~,deep] = size(test_img);
%     if deep==3
%         test_gray_img = rgb2gray(test_img);
%     else
%         test_gray_img = uint8(test_img);
%     end 
%     % ��ȡHOG����
%     [features, ~] = extractHOGFeatures(test_gray_img);  
%     testFeatures = zeros(img_num,size(features,2),'single'); 
%     testFeatures(index,:) = extractHOGFeatures(test_gray_img);
%     % �洢���ݱ�ǩ��001,002,...,151��
%     testLabels(index,1) = img_name(1:3);
%     disp(testLabels(index,1))
    %*******************************************************************************************************%
    % KNN����ʶ����ͼƬ
    % ����ͼ���СΪ480*480
    % (1)������ͼ���С����Ϊ32*32,תΪ�Ҷ�ͼ
    test_img = imresize(animal_img,[img_size, img_size]);
    [~,~,deep] = size(test_img);
    if deep==3
        test_gray_img = rgb2gray(test_img);
    else
        test_gray_img = uint8(test_img);
    end
    % (2)��32*32��СͼƬת����һ�д�СΪ1024������
    test_img_mat = zeros(1,img_size*img_size);
    for i=1:img_size
        for j=1:img_size
            test_img_mat((i-1)*img_size+j) = test_gray_img(i,j);
        end
    end
    testSet(index,:) = test_img_mat;
    % ��¼ͼ���ǩ
    testLabels(index,1) = img_name(1:3); 
    disp(testLabels(index,1))
end
% disp(size(testFeatures));
disp("�������ݶ�ȡ���...")
% kmeans����
% data = [testSet,testLabel];
% [label, score] = kmeans_recognition_id(data);

% svm����
% [label, score] = svm_recognition_id(testFeatures, testLabels);

% knn����
[label, score] = knn_recognition_id(testSet, testLabels);








