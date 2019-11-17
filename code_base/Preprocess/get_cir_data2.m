% id_img图像预处理
function [point_data, cir_data] = get_cir_data(img) 

%************************************************************************************%
% (1)预处理
[height, width, deep] = size(img);
if deep==1
    gray = uint8(img);    
else
    gray = uint8(rgb2gray(img));
end    
bw = edge(gray, 'canny'); 
%************************************************************************************%
% (2)半圆圆心搜索
% 每次搜索增加的圆心位置步长
step_x = 5;
step_y = 5;
% 每次搜索增加的半径步长
step_r = 0.01*height;
% 每次搜索增加的角度步长
step_angle = 0.05*pi;
% 圆心的起始范围
ax1 = floor(width/2 - 0.03*width);
ax2 = floor(width/2 + 0.03*width);
by1 = floor(height - 0.24*height);
by2 = floor(height - 0.06*height);
% 搜索半径范围
r_min = 0.64*height;
r_max = 0.71*height;
% 统计每个圆心位置，不同半径时白色像素数量  
temp_num = 0;
temp_abr = [355,457,0];
% x方向搜索
for a=ax1:step_x:ax2
    % y方向搜索
    for b=by1:step_y:by2
        % r方向搜索
        for r=r_min:step_r:r_max
            % 统计每个角度下，半径端点的白色像素数量
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
            % 记录上一次的像素数量，以及相应的(a,b,r)值
            % 如果在新的(a,b,r)下统计的白色像素数量比上一次多，更新(a,b,r)值
            if pixels_num>temp_num
                temp_num = pixels_num;
                temp_abr = [a,b,r];
            end
        end
    end
end
%************************************************************************************%
% (3)方法2：圆弧扫描法,通过对圆弧进行扫描,确定圆点的位置

% (3)方法1：小圆搜索一般方法(精度不高)
gray(gray>200) = 255;
gray(gray<40) = 0; 
% 高斯滤波
h=fspecial('gaussian',3);   
gray=imfilter(gray,h);
thresh = 1.1*graythresh(gray);
bw = imbinarize(gray,thresh);  
[centers, radii] = imfindcircles(bw,[floor(height/73) floor(height/20)],'ObjectPolarity','bright','Sensitivity',0.86);
% 计算每个小圆到半圆弧中心的距离
temp_distance = 10;
temp_center = [width/2,height/2];
temp_radii = height/50;
% 判断是否找到小圆
if ~isempty(centers)
    temp_centers = abs(centers - temp_abr(1:2));
    for k=1:length(temp_centers(:,1))
        centers_distance = norm(temp_centers(k,:));
        error_distance = abs(centers_distance - temp_abr(3));
        % 记录偏差最小的圆心位置
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
    % 矩形框中心位置
    x0(index) = floor(temp_abr(1)+temp_abr(3)*cos(theta));
    y0(index) = floor(temp_abr(2)-temp_abr(3)*sin(theta));
    d = height/20;
    % rectangle('Position',[x0(index)-d/2,y0(index)-d/2,d,d],'LineWidth',2,'LineStyle','-','EdgeColor','g');
    % 对每个位置的矩形框进行二值化处理,统计白色像素数量
    rect_img = imcrop(img,[x0(index)-d/2,y0(index)-d/2,d,d]);
    rect_gray = rgb2gray(rect_img);
    bw = imbinarize(rect_gray,0.85);
    zero_num(index) = sum(sum(bw==1));
    % imshow(bw)
    % pause(0.1)
    index = index+1;
end
% hold on
% 查找最大值,确定位置
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


