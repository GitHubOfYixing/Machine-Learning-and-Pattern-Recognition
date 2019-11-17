% KNN图像识别
% Class = knnclassify(test_data,train_data,train_label, k, distance, rule)
function [label, score] = knn_recognition_id(img_set, img_label) 

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
% 将图片转换成32*32大小
img_size = 32;
index = 0;
% 训练集
trainSet = zeros(numFiles,img_size*img_size);
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
            gray_img = uint8(rgb2gray(img));
        else
            gray_img = uint8(img);
        end
        % 将32*32大小图片转换成一列大小为1024的向量
        img_mat = zeros(1,img_size*img_size);
        for ii=1:img_size
            for jj=1:img_size
                img_mat((ii-1)*img_size+jj) = gray_img(ii,jj);
            end
        end
        trainSet(index,:) = img_mat;
        % 记录图像标签
        trainLabels(index,1) = doc_dir(j).name;  
        disp([index, numFiles]);
    end
end
disp(size(trainSet));
disp("训练数据加载完成...");
disp("开始训练KNN分类器...");

% 进行KNN模型训练(1-0.88;3-0.84,5-0.83,7-0.82)
model_id = fitcknn(trainSet, trainLabels, 'NumNeighbors', 1);
% 进行随机森林模型训练(20-0.85;50-0.86;100-0.88)
% model = TreeBagger(100, trainSet, trainLabels, 'Method', 'classification');
% 进行朴素贝叶斯模型训练
% model = NaiveBays.fit(trainSet, trainLabels);
% Scores = posterior(Mdl, img_set);
% [Scores, Predict_label] = posterior(Mdl, img_set);
% 进行SVM模型训练
% model = fitcsvm(trainSet, trainLabels);
% 集成学习器(Bossting, Bagging, Random Subspace)
% model = fitensemble(trainSet, trainLabels, 'AdaBoostM1', 100, 'tree', 'type', 'classification');
% 鉴别分类器
% model = ClassificationDiscriminant.fit(trainSet, trainLabels);

% 保存模型
save('model_id.mat','model_id'); 

% 测试数据
true_count = 0;
for k=1:length(img_label)
    % 预测数据
    [label,~] = predict(model_id,img_set(k,:));
    % svm预测数据
    % label = ClassificatinSVM(Mdl,img_set(k,:));
    disp(label)
    % 比较测试数据标签id是否与原始正确标签id相同
    if strcmp(label, img_label(k))
        % 如果相同表示其被正确聚类，否则错误聚类
        true_count = true_count+1;
    end      
    score = 0;
end
% 输出识别精度
sprintf("总共%d个,成功识别%d个,准确率为%.2f", length(img_label),true_count,true_count/length(img_label))

% % 创建交叉验证分类器 
% CVMdl = crossval(Mdl);  
% % 计算交叉验证时的模型损失
% kloss = kfoldLoss(CVMdl);
% disp(kloss)
% % 计算模型Mdl预测结果中被错误分类的数据占比,即分类错误的可能性
% rloss = resubLoss(Mdl);
% disp(rloss)




