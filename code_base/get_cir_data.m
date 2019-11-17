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
% (3)圆弧扫描法,通过对圆弧进行扫描,确定圆点的位置   
index = 1;
for theta=0:0.01*pi:pi                                 
    % 矩形框中心位置
    x0(index) = floor(temp_abr(1)+temp_abr(3)*cos(theta));
    y0(index) = floor(temp_abr(2)-temp_abr(3)*sin(theta));
    d = height/20;
    % 对每个位置的矩形框进行二值化处理,统计白色像素数量
    rect_img = imcrop(img,[x0(index)-d/2,y0(index)-d/2,d,d]);
    rect_gray = rgb2gray(rect_img);
    bw = imbinarize(rect_gray,0.9);
    zero_num(index) = sum(sum(bw==1));
    index = index+1;
end
% 查找最大值,确定位置
pos_flag = find(zero_num==max(zero_num));
x = x0(pos_flag(1));
y = y0(pos_flag(1));
%************************************************************************************%
point_data = [x,y];
cir_data = temp_abr;





