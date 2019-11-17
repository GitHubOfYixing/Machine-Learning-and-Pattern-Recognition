% SVM+HOGͼ��ʶ��
function [label, score] = svm_recognition_id(img_feature, img_label) 

if nargin~=2
    return
end
%****************************************************************************************************%
% ����ѵ��ͼƬ���ݿ�
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
disp(doc_num)
%************************************************************************************************%
% numFiles = length(dir(['..\pokemon dataset\train\','*.*g']));
% ���������������С
numFiles = doc_num*30;
disp(numFiles)
% ��ͼƬת����48*48��С
img_size = 48;
index = 0;
trainLabels = strings(numFiles,1);
disp("��ʼ����ѵ������...");
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
        % ������ѵ��ͼ�����������ȡ
        [features, ~] = extractHOGFeatures(gray_img); 
        trainFeatures = zeros(numFiles,size(features,2),'single');
        trainFeatures(index,:) = extractHOGFeatures(gray_img);
        % �洢���ݱ�ǩ��001,002,...,151��
        trainLabels(index,1) = doc_dir(j).name;
        disp([index, numFiles]);
    end
end
disp(size(trainFeatures));
disp("ѵ�����ݼ������...");
disp("��ʼѵ��SVM������...");
% ��ǩ��
% svmstruct=svmtrain(x,y);
% svmѵ��
% group=svmclassify(svmstruct,double(reshape(img,n1*n2,3)));

% ��ʼsvm�����ѵ����ע�⣺fitcsvm���ڶ����࣬fitcecoc���ڶ���� 
classifer = fitcecoc(trainFeatures, trainLabels);  
% svmԤ�Ⲣ��ʾԤ��Ч��ͼ(img_feature, img_label)?
label = '000';
score = 0;
numTest = length(img_label);
for i = 1:numTest
    [predictIndex,score] = predict(classifer,img_feature(i,:));
    disp(score)
    disp(predictIndex);
end 


