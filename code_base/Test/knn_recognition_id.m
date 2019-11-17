% KNNͼ��ʶ��
% Class = knnclassify(test_data,train_data,train_label, k, distance, rule)
function [label, score] = knn_recognition_id(img_set, img_label) 

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
% ��ͼƬת����32*32��С
img_size = 32;
index = 0;
% ѵ����
trainSet = zeros(numFiles,img_size*img_size);
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
            gray_img = uint8(rgb2gray(img));
        else
            gray_img = uint8(img);
        end
        % ��32*32��СͼƬת����һ�д�СΪ1024������
        img_mat = zeros(1,img_size*img_size);
        for ii=1:img_size
            for jj=1:img_size
                img_mat((ii-1)*img_size+jj) = gray_img(ii,jj);
            end
        end
        trainSet(index,:) = img_mat;
        % ��¼ͼ���ǩ
        trainLabels(index,1) = doc_dir(j).name;  
        disp([index, numFiles]);
    end
end
disp(size(trainSet));
disp("ѵ�����ݼ������...");
disp("��ʼѵ��KNN������...");

% ����KNNģ��ѵ��(1-0.88;3-0.84,5-0.83,7-0.82)
model_id = fitcknn(trainSet, trainLabels, 'NumNeighbors', 1);
% �������ɭ��ģ��ѵ��(20-0.85;50-0.86;100-0.88)
% model = TreeBagger(100, trainSet, trainLabels, 'Method', 'classification');
% �������ر�Ҷ˹ģ��ѵ��
% model = NaiveBays.fit(trainSet, trainLabels);
% Scores = posterior(Mdl, img_set);
% [Scores, Predict_label] = posterior(Mdl, img_set);
% ����SVMģ��ѵ��
% model = fitcsvm(trainSet, trainLabels);
% ����ѧϰ��(Bossting, Bagging, Random Subspace)
% model = fitensemble(trainSet, trainLabels, 'AdaBoostM1', 100, 'tree', 'type', 'classification');
% ���������
% model = ClassificationDiscriminant.fit(trainSet, trainLabels);

% ����ģ��
save('model_id.mat','model_id'); 

% ��������
true_count = 0;
for k=1:length(img_label)
    % Ԥ������
    [label,~] = predict(model_id,img_set(k,:));
    % svmԤ������
    % label = ClassificatinSVM(Mdl,img_set(k,:));
    disp(label)
    % �Ƚϲ������ݱ�ǩid�Ƿ���ԭʼ��ȷ��ǩid��ͬ
    if strcmp(label, img_label(k))
        % �����ͬ��ʾ�䱻��ȷ���࣬����������
        true_count = true_count+1;
    end      
    score = 0;
end
% ���ʶ�𾫶�
sprintf("�ܹ�%d��,�ɹ�ʶ��%d��,׼ȷ��Ϊ%.2f", length(img_label),true_count,true_count/length(img_label))

% % ����������֤������ 
% CVMdl = crossval(Mdl);  
% % ���㽻����֤ʱ��ģ����ʧ
% kloss = kfoldLoss(CVMdl);
% disp(kloss)
% % ����ģ��MdlԤ�����б�������������ռ��,���������Ŀ�����
% rloss = resubLoss(Mdl);
% disp(rloss)




