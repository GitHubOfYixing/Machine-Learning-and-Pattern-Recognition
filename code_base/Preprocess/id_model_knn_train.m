clc;
clear;
close all;
warning('off');
%****************************************************************************************************%
% 加载训练图片数据库
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
disp(doc_num)
%************************************************************************************************%
% 数据扩充后样本大小
numFiles = doc_num*30;
disp(numFiles)
% 将图片转换成32*32大小
img_size = [32, 32];
index = 0;
% 训练集
trainSet = zeros(numFiles,img_size(1)*img_size(2));
trainLabels = strings(numFiles,1);
disp("开始加载训练数据...");
for j=1:doc_num
    % '..\pokemon dataset\img_train_set\001\'
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    for i = 1:img_num 
        index = index+1;
        % '..\pokemon dataset\img_train_set\001\1.jpg'
        img = imread([img_path, img_dir(i).name]); 
        img = imresize(img,img_size);
        [~,~,deep] = size(img);
        if deep==3
            gray_img = uint8(rgb2gray(img));
        else
            gray_img = uint8(img);
        end
        trainSet(index,:) = img_to_vector(img, img_size);
        trainLabels(index,1) = doc_dir(j).name;  
        disp([index, numFiles]);
    end
end
disp(size(trainSet));
disp("训练数据加载完成...");

disp("开始训练分类器...");
% 进行KNN模型训练(1-0.88;3-0.84,5-0.83,7-0.82)
model_id = fitcknn(trainSet, trainLabels, 'NumNeighbors', 1);
% 进行随机森林模型训练(20-0.85;50-0.86;100-0.88)
% model_id = TreeBagger(80, trainSet, trainLabels, 'Method', 'classification');
disp("分类器训练完成...");

% 保存模型
save('model_id.mat','model_id'); 

% % 创建交叉验证分类器 
% CVMdl = crossval(model_id);  
% % % 计算交叉验证时的模型损失
% kloss = kfoldLoss(CVMdl);
% disp(kloss)
% % 计算模型Mdl预测结果中被错误分类的数据占比,即分类错误的可能性
% rloss = resubLoss(model_id);
% disp(rloss)


