% id_imgͼ��Ԥ����
function [point_data, cir_data] = get_cir_data(img) 

%************************************************************************************%
% (1)Ԥ����
[height, width, deep] = size(img);
if deep==1
    gray = uint8(img);    
else
    gray = uint8(rgb2gray(img));
end    
bw = edge(gray, 'canny'); 
%************************************************************************************%
% (2)��ԲԲ������
% ÿ���������ӵ�Բ��λ�ò���
step_x = 5;
step_y = 5;
% ÿ���������ӵİ뾶����
step_r = 0.01*height;
% ÿ���������ӵĽǶȲ���
step_angle = 0.05*pi;
% Բ�ĵ���ʼ��Χ
ax1 = floor(width/2 - 0.03*width);
ax2 = floor(width/2 + 0.03*width);
by1 = floor(height - 0.24*height);
by2 = floor(height - 0.06*height);
% �����뾶��Χ
r_min = 0.64*height;
r_max = 0.71*height;
% ͳ��ÿ��Բ��λ�ã���ͬ�뾶ʱ��ɫ��������  
temp_num = 0;
temp_abr = [355,457,0];
% x��������
for a=ax1:step_x:ax2
    % y��������
    for b=by1:step_y:by2
        % r��������
        for r=r_min:step_r:r_max
            % ͳ��ÿ���Ƕ��£��뾶�˵�İ�ɫ��������
            pixels_num = 0;
            for theta=0:step_angle:pi                                 
                x2 = floor(a+r*cos(theta));
                y2 = floor(b-r*sin(theta));
                if x2<=0
                    x2=1;
                end
                if y2<=0
                    y2=1;
                end
                if bw(y2,x2)==1
                    pixels_num = pixels_num+1;
                end
            end
            % ��¼��һ�ε������������Լ���Ӧ��(a,b,r)ֵ
            % ������µ�(a,b,r)��ͳ�Ƶİ�ɫ������������һ�ζ࣬����(a,b,r)ֵ
            if pixels_num>temp_num
                temp_num = pixels_num;
                temp_abr = [a,b,r];
            end
        end
    end
end
%************************************************************************************%
% (3)Բ��ɨ�跨,ͨ����Բ������ɨ��,ȷ��Բ���λ��   
index = 1;
for theta=0:0.01*pi:pi                                 
    % ���ο�����λ��
    x0(index) = floor(temp_abr(1)+temp_abr(3)*cos(theta));
    y0(index) = floor(temp_abr(2)-temp_abr(3)*sin(theta));
    d = height/20;
    % ��ÿ��λ�õľ��ο���ж�ֵ������,ͳ�ư�ɫ��������
    rect_img = imcrop(img,[x0(index)-d/2,y0(index)-d/2,d,d]);
    rect_gray = rgb2gray(rect_img);
    bw = imbinarize(rect_gray,0.9);
    zero_num(index) = sum(sum(bw==1));
    index = index+1;
end
% �������ֵ,ȷ��λ��
pos_flag = find(zero_num==max(zero_num));
x = x0(pos_flag(1));
y = y0(pos_flag(1));
%************************************************************************************%
point_data = [x,y];
cir_data = temp_abr;





