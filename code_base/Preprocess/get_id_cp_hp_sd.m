clear; clc; close all; warning off;

img_path = '..\pokemon dataset\train\';
% 图片包含png、jpg、jpeg格式
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);
% 统计未被识别的图像数量，及其对应的标签
zero_count = 0;
% 定义30行一列的字符串数组
zero_name = strings(30,1);
for i = 1:img_num 
    % 获取图片名称
    img = imread([img_path, img_dir(i).name]);
    disp(i)
    disp(img_dir(i).name)
    % 裁剪图片
    [id_img, cp_img, hp_img, sd_img, cir_img, cir_img_pos] = img_extract(img);
    % 保存裁剪后图片
    name = img_dir(i).name;
    ul_idx = strfind(name,'_');
    subimg_dir = strcat('..\pokemon dataset\img_train_set\', name(1:ul_idx(1)-1));
    if exist(subimg_dir,'dir')==0
        mkdir('..\pokemon dataset\img_train_set\', name(1:ul_idx(1)-1));
    end  
    % 灰度化
    [height, width, deep] = size(id_img);
    Area = height*width; 
    if deep==1
        gray = uint8(id_img);   
    else
        gray = uint8(rgb2gray(id_img));
    end    
    gray = imadjust(gray,[],[],1);
    id_img = gray;
 
    
    if ~isempty(id_img)
        disp(123)
        % imwrite(hp_img,strcat(subimg_dir, '\', num2str(i), '_HP.jpg'));
        imwrite(id_img,strcat(subimg_dir, '\', num2str(i), '.jpg'));
        % imwrite(cp_img,strcat(subimg_dir, '\', num2str(i), '_CP.jpg'));
        % imwrite(cp_img,strcat(subimg_dir, '\', num2str(i), '_SD.jpg'));
    else
        zero_count = zero_count+1;
        zero_name(zero_count) = name;
        disp(zero_name(zero_count))
        return
    end
    %********************************************************************************************************%
    
    if i==img_num
        close all;
        disp(zero_count)
        disp(zero_name(1:zero_count))
        return
    end
    % pause(0.5)
    close all;
end








