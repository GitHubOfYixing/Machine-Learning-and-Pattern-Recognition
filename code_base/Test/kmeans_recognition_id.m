% kmeans聚类
function [label, score] = kmeans_recognition_id(data) 

if nargin~=1
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
dataSet = zeros(numFiles,1024);
hwLabels = zeros(numFiles,1);
index = 0;
% 将图片转换成32*32大小
img_size = 32;
disp("开始加载训练数据...");
for j=1:doc_num
    % '..\pokemon dataset\train\001\'
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    for i = 1:img_num 
        index = index+1;
        % '..\pokemon dataset\train\001\1.jpg'
        img = imread([img_path, img_dir(i).name]); 
        img = imresize(img,[img_size,img_size]);
        [~,~,deep] = size(img);
        if deep==3
            gray_img = rgb2gray(img);
        else
            gray_img = img;
        end
        % 将32*32大小图片转换成一列大小为1024的向量
        img_mat = zeros(1,img_size*img_size);
        for ii=1:img_size
            for jj=1:img_size
                img_mat((ii-1)*img_size+jj) = gray_img(ii,jj);
            end
        end
        % 矩阵存储图片向量
        dataSet(index,:) = img_mat;
        % 存储数据标签（1,2,...,151）
        hwLabels(index,1) = str2num(doc_dir(j).name);
    end
end
disp("训练数据加载完成...");
%************************************************************************************************%
% 进行Kmeans聚类
% Idx:  聚类的标号
% C:    聚类之后质心的位置
% sumD: 所有点到质心的距离之和
% D:    每个点与所有质心的距离
% 将训练数据与测试数据绑定在一起进行聚类操作
disp("正在开始聚类...");
[Idx,~,~,~] = kmeans([dataSet;str2double(data(:,1:img_size*img_size))], doc_num);
disp(size(Idx))
test_num = size(data(:,1:img_size*img_size));
% 分类存储聚类后的标签numFiles
kmean_label = zeros(doc_num,1);
lab_num = 1;
disp("正在计算结果...")
for j=1:doc_num
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    % 获取每个类的聚类后的标签号
    lab = Idx(lab_num:lab_num+img_num-1);
    lab_num = lab_num+img_num;
    % 统计每个类中出现次数最多的标签号
    tab = tabulate(lab);
    max_label = tab(tab(:,2) == max(tab(:,2)),1);
    % 将最多标签号作为该类的判别标签
    kmean_label(j) = max_label(1);
end
% 检测测试数据的正确率
true_count = 0;
for k=1:test_num(1)
    % 判断测试标签属于哪一类
    label = find(Idx(numFiles+k)==kmean_label);
    if isempty(label)
        label = '000';
    else
        % 如果多个图像有相同的最大聚类标签，则只取第一个标签作为其身份id
        label = label(1);
        label = doc_dir(label).name;    
    end
    % 比较测试数据标签id是否与原始正确标签id相同
    if strcmp(label, data(k,1025))
        % 如果相同表示其被正确聚类，否则错误聚类
        true_count = true_count+1;
        % disp(label)
    end      
    score = 0;
end
% 输出识别精度
sprintf("总共%d个,成功识别%d个,准确率为%.2f", test_num(1),true_count,true_count/test_num(1))

% 输出预测值
% label = max_score_name(max_score==max(max_score));
% label = label(1);
% score = max(max_score);
% disp([label, score])

% sprintf("%s - %s - %s",img_name(1:3), label, num2str(score))
% if strcmp(img_name(1:3), label)
%     true_count = true_count+1;
% end
% % 输出识别精度
% sprintf("总共%d个,成功识别%d个,准确率为%.2f", img_num,true_count,true_count/img_num)







