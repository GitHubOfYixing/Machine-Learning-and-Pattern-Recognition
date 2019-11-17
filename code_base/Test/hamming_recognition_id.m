% 计算图像的指纹，并预测其标签
function [label, score] = hamming_recognition_id(img) 

if nargin~=1
    return
end

dim = 16;
img = imresize(img, [dim, dim]);
[~,~,deep] = size(img);
if deep==3
    gray_64 = uint8(floor(rgb2gray(img)/2));
else
    gray_64 = uint8(floor(img/2));
end
mean_gray_64 = mean(mean(gray_64));
gray_64(gray_64<mean_gray_64) = 0;
gray_64(gray_64>=mean_gray_64) = 1;
gray_2 = gray_64;
gray_2t = gray_2';
img_id = gray_2t(:)';
% 匹配预测其标签
% 加载特征数据库
doc_path = '..\pokemon dataset\img_feature_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
max_score = zeros(1,doc_num);
max_score_name = strings(doc_num,1);
for j=1:doc_num
    % 比较两幅图片指纹的相似程度
    path = strcat('..\pokemon dataset\img_feature_set\', doc_dir(j).name);
    vector = load(path);
    len = length(vector.one_vector(:,1));
    score = zeros(1,len);
    for i=1:len
        flag = find(img_id == vector.one_vector(i,:));
        score(1,i) = 100*(length(flag)/64);
    end
    name = doc_dir(j).name;
    max_score_name(j) = name(1:3);  
    % 输出每个矩阵中的最大得分
    max_score(j) = max(score);
end
% 输出预测值
label = max_score_name(max_score==max(max_score));
label = label(1);
score = max(max_score);
% disp([label, score])

