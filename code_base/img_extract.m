% �ü�ͼƬ�еĸ���Ȥ����
function [id_img, cp_img, hp_img, sd_img, cir_img, cir_img_pos] = img_extract(img) 

% (1)��ȡͼƬ
origin_img = img;
%********************************************************************************************************%
% (2)��ͼ���м䲿�ֽ��ж�λ�ü�
[height, width, ~] = size(origin_img);
img = imcrop(origin_img,[width/5, 1.2*height/3, 3*width/5, height/4]); 
%********************************************************************************************************%
% (3)���ͼƬ�е�ֱ�߼���λ��
thresh = 0.90;
[line_num, line_pos, line_len] = get_line(img, thresh, width/3);
if isempty(line_num)
    % ��δ��ʶ���ͼ��ͨ��ѭ��������ֵ��ֱ���ܹ���ʶ��
    for t=1:50
        thresh = thresh - 0.01;
        [line_num, line_pos, line_len] = get_line(img, thresh, width/3);
        if ~isempty(line_num)
            break
        end
    end
end
% ���δ��⵽ֱ��,���ؿ�
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
% (4)�ü�HPλ��ͼ��
x_c = (line_pos(1,1)+line_pos(2,1))/2;
y_c = (line_pos(1,2)+line_pos(2,2))/2;
hp_pos = [x_c - 1.1*line_len/4, y_c - line_len/25, 1.1*line_len/2, height/15];
hp_img = imcrop(img, hp_pos);
% figure(1)
% imshow(hp_img)
%********************************************************************************************************%
% (5)�ü�IDλ��ͼ��
x_c = x_c + width/5;
y_c = y_c + 1.2*height/3;
id_pos = [x_c - 1.0*line_len/2, y_c - 1.4*line_len, 1.0*line_len, 1.1*line_len];
crop_img = imcrop(origin_img, id_pos);
id_img = imresize(crop_img, [480, 480]);
% figure(2)
% imshow(id_img)
%********************************************************************************************************%
% (6)�ü�CPλ��ͼ��
cp_pos = [x_c - 0.5*line_len/2, y_c - 1.7*line_len, 1.0*line_len/2, 0.85*line_len/3];
cp_img = imcrop(origin_img, cp_pos); 
% figure(3)
% imshow(cp_img)
%********************************************************************************************************%
% (7)�ü�SDλ��ͼ��
sd_pos = [x_c+line_len/12, y_c+0.95*line_len, line_len/4, 1.2*line_len/5];
sd_img = imcrop(origin_img, sd_pos); 
% figure(4)
% imshow(sd_img)
%********************************************************************************************************%
% (8)�ü���Բ��λ��ͼ��
cir_img_pos = [0, y_c - 1.6*line_len, width, 1.2*line_len];
cir_img = imcrop(origin_img, cir_img_pos); 
% figure(5)
% imshow(cir_img)

