% SVM+HOG图像识别
function [label, score] = svm_recognition_id(img_feature, img_label) 

if nargin~=2
    return
end
%****************************************************************************************************%
% 加载训练图片数据库
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
disp(doc_num)
%************************************************************************************************%
% numFiles = length(dir(['..\pokemon dataset\train\','*.*g']));
% 数据扩充后样本大小
numFiles = doc_num*30;
disp(numFiles)
% 将图片转换成48*48大小
img_size = 48;
index = 0;
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
        img = imresize(img,[img_size,img_size]);
        [~,~,deep] = size(img);
        if deep==3
            gray_img = rgb2gray(img);
        else
            gray_img = img;
        end
        % 对所有训练图像进行特征提取
        [features, ~] = extractHOGFeatures(gray_img); 
        trainFeatures = zeros(numFiles,size(features,2),'single');
        trainFeatures(index,:) = extractHOGFeatures(gray_img);
        % 存储数据标签（001,002,...,151）
        trainLabels(index,1) = doc_dir(j).name;
        disp([index, numFiles]);
    end
end
disp(size(trainFeatures));
disp("训练数据加载完成...");
disp("开始训练SVM分类器...");
% 标签集
% svmstruct=svmtrain(x,y);
% svm训练
% group=svmclassify(svmstruct,double(reshape(img,n1*n2,3)));

% 开始svm多分类训练，注意：fitcsvm用于二分类，fitcecoc用于多分类 
classifer = fitcecoc(trainFeatures, trainLabels);  
% svm预测并显示预测效果图(img_feature, img_label)?
label = '000';
score = 0;
numTest = length(img_label);
for i = 1:numTest
    [predictIndex,score] = predict(classifer,img_feature(i,:));
    disp(score)
    disp(predictIndex);
end 


