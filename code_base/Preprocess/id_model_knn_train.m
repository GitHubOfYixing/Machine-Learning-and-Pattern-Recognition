clc;
clear;
close all;
warning('off');
%****************************************************************************************************%
% ����ѵ��ͼƬ���ݿ�
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
disp(doc_num)
%************************************************************************************************%
% ���������������С
numFiles = doc_num*30;
disp(numFiles)
% ��ͼƬת����32*32��С
img_size = [32, 32];
index = 0;
% ѵ����
trainSet = zeros(numFiles,img_size(1)*img_size(2));
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
disp("ѵ�����ݼ������...");

disp("��ʼѵ��������...");
% ����KNNģ��ѵ��(1-0.88;3-0.84,5-0.83,7-0.82)
model_id = fitcknn(trainSet, trainLabels, 'NumNeighbors', 1);
% �������ɭ��ģ��ѵ��(20-0.85;50-0.86;100-0.88)
% model_id = TreeBagger(80, trainSet, trainLabels, 'Method', 'classification');
disp("������ѵ�����...");

% ����ģ��
save('model_id.mat','model_id'); 

% % ����������֤������ 
% CVMdl = crossval(model_id);  
% % % ���㽻����֤ʱ��ģ����ʧ
% kloss = kfoldLoss(CVMdl);
% disp(kloss)
% % ����ģ��MdlԤ�����б�������������ռ��,���������Ŀ�����
% rloss = resubLoss(model_id);
% disp(rloss)


