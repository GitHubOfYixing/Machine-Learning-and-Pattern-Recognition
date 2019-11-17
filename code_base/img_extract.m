% 裁剪图片中的感兴趣区域
function [id_img, cp_img, hp_img, sd_img, cir_img, cir_img_pos] = img_extract(img) 

% (1)获取图片
origin_img = img;
%********************************************************************************************************%
% (2)对图像中间部分进行定位裁剪
[height, width, ~] = size(origin_img);
img = imcrop(origin_img,[width/5, 1.2*height/3, 3*width/5, height/4]); 
%********************************************************************************************************%
% (3)检测图片中的直线及其位置
thresh = 0.90;
[line_num, line_pos, line_len] = get_line(img, thresh, width/3);
if isempty(line_num)
    % 对未被识别的图像通过循环调整阈值，直到能够被识别
    for t=1:50
        thresh = thresh - 0.01;
        [line_num, line_pos, line_len] = get_line(img, thresh, width/3);
        if ~isempty(line_num)
            break
        end
    end
end
% 如果未检测到直线,返回空
if isempty(line_num)
    id_img = [];
    cp_img = [];
    hp_img = [];
    sd_img = [];
    cir_img = [];
    cir_img_pos = [];
    return
end
%********************************************************************************************************%
% (4)裁剪HP位置图像
x_c = (line_pos(1,1)+line_pos(2,1))/2;
y_c = (line_pos(1,2)+line_pos(2,2))/2;
hp_pos = [x_c - 1.1*line_len/4, y_c - line_len/25, 1.1*line_len/2, height/15];
hp_img = imcrop(img, hp_pos);
% figure(1)
% imshow(hp_img)
%********************************************************************************************************%
% (5)裁剪ID位置图像
x_c = x_c + width/5;
y_c = y_c + 1.2*height/3;
id_pos = [x_c - 1.0*line_len/2, y_c - 1.4*line_len, 1.0*line_len, 1.1*line_len];
crop_img = imcrop(origin_img, id_pos);
id_img = imresize(crop_img, [480, 480]);
% figure(2)
% imshow(id_img)
%********************************************************************************************************%
% (6)裁剪CP位置图像
cp_pos = [x_c - 0.5*line_len/2, y_c - 1.7*line_len, 1.0*line_len/2, 0.85*line_len/3];
cp_img = imcrop(origin_img, cp_pos); 
% figure(3)
% imshow(cp_img)
%********************************************************************************************************%
% (7)裁剪SD位置图像
sd_pos = [x_c+line_len/12, y_c+0.95*line_len, line_len/4, 1.2*line_len/5];
sd_img = imcrop(origin_img, sd_pos); 
% figure(4)
% imshow(sd_img)
%********************************************************************************************************%
% (8)裁剪半圆弧位置图像
cir_img_pos = [0, y_c - 1.6*line_len, width, 1.2*line_len];
cir_img = imcrop(origin_img, cir_img_pos); 
% figure(5)
% imshow(cir_img)

