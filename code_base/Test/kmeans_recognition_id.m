% kmeans����
function [label, score] = kmeans_recognition_id(data) 

if nargin~=1
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
dataSet = zeros(numFiles,1024);
hwLabels = zeros(numFiles,1);
index = 0;
% ��ͼƬת����32*32��С
img_size = 32;
disp("��ʼ����ѵ������...");
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
        % ��32*32��СͼƬת����һ�д�СΪ1024������
        img_mat = zeros(1,img_size*img_size);
        for ii=1:img_size
            for jj=1:img_size
                img_mat((ii-1)*img_size+jj) = gray_img(ii,jj);
            end
        end
        % ����洢ͼƬ����
        dataSet(index,:) = img_mat;
        % �洢���ݱ�ǩ��1,2,...,151��
        hwLabels(index,1) = str2num(doc_dir(j).name);
    end
end
disp("ѵ�����ݼ������...");
%************************************************************************************************%
% ����Kmeans����
% Idx:  ����ı��
% C:    ����֮�����ĵ�λ��
% sumD: ���е㵽���ĵľ���֮��
% D:    ÿ�������������ĵľ���
% ��ѵ��������������ݰ���һ����о������
disp("���ڿ�ʼ����...");
[Idx,~,~,~] = kmeans([dataSet;str2double(data(:,1:img_size*img_size))], doc_num);
disp(size(Idx))
test_num = size(data(:,1:img_size*img_size));
% ����洢�����ı�ǩnumFiles
kmean_label = zeros(doc_num,1);
lab_num = 1;
disp("���ڼ�����...")
for j=1:doc_num
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    % ��ȡÿ����ľ����ı�ǩ��
    lab = Idx(lab_num:lab_num+img_num-1);
    lab_num = lab_num+img_num;
    % ͳ��ÿ�����г��ִ������ı�ǩ��
    tab = tabulate(lab);
    max_label = tab(tab(:,2) == max(tab(:,2)),1);
    % ������ǩ����Ϊ������б��ǩ
    kmean_label(j) = max_label(1);
end
% ���������ݵ���ȷ��
true_count = 0;
for k=1:test_num(1)
    % �жϲ��Ա�ǩ������һ��
    label = find(Idx(numFiles+k)==kmean_label);
    if isempty(label)
        label = '000';
    else
        % ������ͼ������ͬ���������ǩ����ֻȡ��һ����ǩ��Ϊ�����id
        label = label(1);
        label = doc_dir(label).name;    
    end
    % �Ƚϲ������ݱ�ǩid�Ƿ���ԭʼ��ȷ��ǩid��ͬ
    if strcmp(label, data(k,1025))
        % �����ͬ��ʾ�䱻��ȷ���࣬����������
        true_count = true_count+1;
        % disp(label)
    end      
    score = 0;
end
% ���ʶ�𾫶�
sprintf("�ܹ�%d��,�ɹ�ʶ��%d��,׼ȷ��Ϊ%.2f", test_num(1),true_count,true_count/test_num(1))

% ���Ԥ��ֵ
% label = max_score_name(max_score==max(max_score));
% label = label(1);
% score = max(max_score);
% disp([label, score])

% sprintf("%s - %s - %s",img_name(1:3), label, num2str(score))
% if strcmp(img_name(1:3), label)
%     true_count = true_count+1;
% end
% % ���ʶ�𾫶�
% sprintf("�ܹ�%d��,�ɹ�ʶ��%d��,׼ȷ��Ϊ%.2f", img_num,true_count,true_count/img_num)







