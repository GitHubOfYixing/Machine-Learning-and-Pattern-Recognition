% KNNͼ��ʶ��
%****************************************************************************************************%
% ����ѵ��ͼƬ���ݿ�(���ֺڵ�)
doc_path = '..\pokemon dataset\num_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
%************************************************************************************************%
% ���������������С
numFiles = doc_num*60;
disp(numFiles)
% ��ͼƬת����32*32��С
img_size = [32, 32];
index = 0;
% ѵ����
trainSet = zeros(numFiles,img_size(1)*img_size(2));
trainLabels = strings(numFiles,1);
disp("��ʼ����ѵ������...");
for j=1:doc_num
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    for i = 1:img_num 
        index = index+1;
        img = imread([img_path, img_dir(i).name]); 
        img = imresize(img, img_size);
        [~,~,deep] = size(img);
        if deep==3
            gray_img = uint8(rgb2gray(img));
        else
            gray_img = uint8(img);
        end
        thresh = graythresh(gray_img);
        bw = imbinarize(gray_img,thresh);
        bw = imclearborder(bw,8);
        % imshow(bw);
        % pause(0.5)
        % ��32*32��СͼƬת����һ�д�СΪ1024������
        trainSet(index,:) = img_to_vector(bw, img_size);
        trainLabels(index,1) = doc_dir(j).name;  
        disp([index, numFiles]);
    end
end
disp(size(trainSet));
disp("ѵ�����ݼ������...");

disp("��ʼѵ��������...");
% ����KNNģ��ѵ��(1-0.88;3-0.84,5-0.83,7-0.82)
model_num = fitcknn(trainSet, trainLabels, 'NumNeighbors', 1, 'Standardize',1);
% �������ɭ��ģ��ѵ��(20-0.85;50-0.86;100-0.88)
% model_num = TreeBagger(100, trainSet, trainLabels, 'Method', 'classification');
disp("������ѵ�����...");

% ����ģ��
save('model_num.mat','model_num'); 

% % ����������֤������ 
% CVMdl = crossval(model_num);  
% % ���㽻����֤ʱ��ģ����ʧ
% kloss = kfoldLoss(CVMdl);
% disp(kloss)
% % ����ģ��MdlԤ�����б�������������ռ��,���������Ŀ�����
% rloss = resubLoss(model_num);
% disp(rloss)




