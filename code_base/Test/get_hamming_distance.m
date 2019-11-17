clc;
clear;
close all;
%***************************************************************************% 
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
%***************************************************************************% 
% ƽ����ϣ�㷨
for j=1:doc_num
    img_path = strcat(doc_path, doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.jpg']);
    img_num = length(img_dir);
    disp(doc_dir(j).name)
    % �洢ͼƬָ��
    dim = 16;
    one_vector = zeros(img_num,dim*dim);
    for i=1:img_num
        % ��ȡͼƬ����
        img = imread([img_path, img_dir(i).name]);
        % ����ͼƬ��ָ��
        % (1)��ͼƬ��С����Ϊ8x8��С
        img = imresize(img, [dim, dim]);
        [~,~,deep] = size(img);
        % (2)ת����64���Ҷ�ͼ��
        if deep==3
            gray_64 = uint8(floor(rgb2gray(img)/2));
        else
            gray_64 = uint8(floor(img/2));
        end
        % (3)����Ҷ�����ƽ��ֵ
        mean_gray_64 = mean(mean(gray_64));
        % (4)��С��ƽ��ֵ������ֵ��0������ƽ��ֵ��������1
        gray_64(gray_64<mean_gray_64) = 0;
        gray_64(gray_64>=mean_gray_64) = 1;
        gray_2 = gray_64;
        % (5)����ֵͼ�������ϵ��£�������ƽ��Ϊһά����
        gray_2t = gray_2';
        one_vector(i,:) = gray_2t(:)';
        % (6)��һά����ת���ɹ�ϣֵ�ַ���
        hash_num = num2str(one_vector(i,1));
        for k=2:length(one_vector(i,:))
            hash_num = strcat(hash_num, num2str(one_vector(i,k))); 
        end
    end
    % ������one_vector���浽xxx.mat�����ļ���
    % ��one_vector�����ݽ��������㣬���ɸ�ͼ���ͨ��ָ��
    save(strcat('..\pokemon dataset\img_feature_set\',doc_dir(j).name,'.mat'), 'one_vector')
end
