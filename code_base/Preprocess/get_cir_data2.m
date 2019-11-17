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
% (3)����2��Բ��ɨ�跨,ͨ����Բ������ɨ��,ȷ��Բ���λ��

% (3)����1��СԲ����һ�㷽��(���Ȳ���)
gray(gray>200) = 255;
gray(gray<40) = 0; 
% ��˹�˲�
h=fspecial('gaussian',3);   
gray=imfilter(gray,h);
thresh = 1.1*graythresh(gray);
bw = imbinarize(gray,thresh);  
[centers, radii] = imfindcircles(bw,[floor(height/73) floor(height/20)],'ObjectPolarity','bright','Sensitivity',0.86);
% ����ÿ��СԲ����Բ�����ĵľ���
temp_distance = 10;
temp_center = [width/2,height/2];
temp_radii = height/50;
% �ж��Ƿ��ҵ�СԲ
if ~isempty(centers)
    temp_centers = abs(centers - temp_abr(1:2));
    for k=1:length(temp_centers(:,1))
        centers_distance = norm(temp_centers(k,:));
        error_distance = abs(centers_distance - temp_abr(3));
        % ��¼ƫ����С��Բ��λ��
        if error_distance<temp_distance && radii(k,:)<floor(height/35)
            temp_distance = error_distance;
            temp_center = centers(k,:);
            temp_radii = radii(k,:);
        end
    end
end    
%************************************************************************************%
point_data = [temp_center, temp_radii];
cir_data = temp_abr;

% figure(1)
% imshow(img)
% hold on
% plot(temp_abr(1),temp_abr(2),'o','LineWidth',2,'Color','yellow');
index = 1;
for theta=0:0.02*pi:pi                                 
    % hold on
    % plot(floor(temp_abr(1)+temp_abr(3)*cos(theta)),floor(temp_abr(2)-temp_abr(3)*sin(theta)),'x','LineWidth',1,'Color','blue');
    % hold on
    % ���ο�����λ��
    x0(index) = floor(temp_abr(1)+temp_abr(3)*cos(theta));
    y0(index) = floor(temp_abr(2)-temp_abr(3)*sin(theta));
    d = height/20;
    % rectangle('Position',[x0(index)-d/2,y0(index)-d/2,d,d],'LineWidth',2,'LineStyle','-','EdgeColor','g');
    % ��ÿ��λ�õľ��ο���ж�ֵ������,ͳ�ư�ɫ��������
    rect_img = imcrop(img,[x0(index)-d/2,y0(index)-d/2,d,d]);
    rect_gray = rgb2gray(rect_img);
    bw = imbinarize(rect_gray,0.85);
    zero_num(index) = sum(sum(bw==1));
    % imshow(bw)
    % pause(0.1)
    index = index+1;
end
% hold on
% �������ֵ,ȷ��λ��
% disp(zero_num)
pos_flag = find(zero_num==max(zero_num));
x = x0(pos_flag);
y = y0(pos_flag);
% disp([x,y])
% plot(x,y,'O')
% hold off

% hold on
% viscircles(temp_center, temp_radii, 'EdgeColor', 'r');
% hold off


