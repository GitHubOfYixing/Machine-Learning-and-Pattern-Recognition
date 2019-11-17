clc;
clear;
close all;

% img_path1 = '..\pokemon dataset\train_set\001\1_CP.jpg';
% img_path2 = '..\pokemon dataset\train_set\001\1_HP.jpg';
% img_path3 = '..\pokemon dataset\train_set\001\1_SD.jpg';

path = '..\pokemon dataset\train_set\';
path_dir = dir(path);
path_len = length(path_dir);
path_dir = path_dir(3:path_len);
path_len = length(path_dir);
for j = 1:path_len
    img_path = strcat(path, path_dir(j).name,'\');
    % disp(img_path)
    img_dir = dir([img_path, '*CP.jpg']);
    img_num = size(img_dir);
    for i=1:img_num
        % ��ȡͼƬ����
        img = imread([img_path, img_dir(i).name]);  
        [length, width, deep] = size(img);
        Area = length*width; 
        
        %*******************************************************************************************%
        
        % CP
        if deep==3
            gray = uint8(rgb2gray(img));
        else
            gray = uint8(img);
        end
        % �԰�ɫ���ⲿ�ֽ�����ɫ��ǿ
        % gray(gray<100) = 0;    
        % se = strel('disk',1);
        % gray = imerode(gray,se1); % ��ʴ
        % gray = imdilate(gray,se); % ����
        % thresh = 0.8;
        thresh = 1.1*graythresh(gray);
        bw = imbinarize(gray,thresh);
        % ɾ����ֵͼ��bw�����С��P�Ķ���Ĭ�������connʹ��8����
        bw = bwareaopen(bw,double(int32(Area/320))); 
        
        %*******************************************************************************************%
        
        % HP
%         if deep==3
%             gray = 255 - uint8(rgb2gray(img));
%         else
%             gray = 255 - uint8(img);
%         end
%         thresh = graythresh(gray);
%         bw = imbinarize(gray,thresh);
%         bw = bwareaopen(bw,double(int32(Area/400))); 

        %*******************************************************************************************%
    
        % SD
%         if deep==3
%             gray = 255 - uint8(rgb2gray(img));
%         else
%             gray = 255 - uint8(img);
%         end
%         % gray(gray>200) = 255;       
%         thresh = graythresh(gray);
%         bw = imbinarize(gray,thresh);
%         bw = bwareaopen(bw,double(int32(Area/400))); 

        %*******************************************************************************************%
        
        % ɾ��ͼ��߽��ϵ�����
        bw = imclearborder(bw,8);
        % �׶����
        I_Filled = imfill(bw,'holes');  
        subplot(1,5,1)
        imshow(I_Filled)
        % hold on
        
        % ��������(�ú���Ĭ�ϴ������ҷ�������)
        % ��ȡ����ͨ�������ԣ��������L�����������Num��
        [I_Labeled,I_Numbers]  = bwlabel(I_Filled,4);  
        % ��ȡ�����'basic'����('Area','Centroid')
        stats = regionprops(I_Labeled,'all');
        % �������Ȥ�������
        obj_num = size(stats);
        plot_i = 1;
        for index=1:obj_num
            box = stats(index).BoundingBox;
            cent = stats(index).Centroid;
            x = box(:,1);
            y = box(:,2);
            w = box(:,3);
            h = box(:,4);
            % rectangle('Position',[x,y,w,h],'LineWidth',2,'LineStyle','-','EdgeColor','b');
            % hold off
            %***************************************************************************************************%
            % ɸѡ����������ͼƬ(CP: h>length/3)
            if h > 1.3*length/4
                plot_i = plot_i+1;
                subplot(1,6,plot_i)
                num_img = imcrop(img,[x, y, w, h]); 
                imshow(num_img)
            end
            %***************************************************************************************************%
            % ɸѡ����������ͼƬ(HP)
%             % subplot(1,10,index+1)
%             num_img = imcrop(img,[x, y, w, h]); 
%             % imshow(num_img)
%             % ����HP�����֣�����ѵ��
%             hp_path = '..\pokemon dataset\hp_num_train\';
%             hp_dir = dir([hp_path,'*.jpg']);
%             hp_num = size(hp_dir);
%             imwrite(num_img,strcat(hp_path, num2str(hp_num(1)+1), '.jpg'));
            %***************************************************************************************************%
            % ɸѡ����������ͼƬ(SD)
%             % subplot(1,5,index+1)
%             num_img = imcrop(img,[x, y, w, h]); 
%             % imshow(num_img)
%             % ����SD�����֣�����ѵ��
%             sd_path = '..\pokemon dataset\sd_num_train\';
%             sd_dir = dir([sd_path,'*.jpg']);
%             sd_num = size(sd_dir);
%             imwrite(num_img,strcat(sd_path, num2str(sd_num(1)+1), '.jpg'));
            %***************************************************************************************************%
        end
        
        if j==2
            return
        end
        disp([j,i])
        pause(1)
        close all;
    end
end

%     CC = bwconncomp(bw, 8);
%     S = regionprops(CC, 'Area');
%     L = labelmatrix(CC);
%     bw = ismember(L, find([S.Area] < Area/60));