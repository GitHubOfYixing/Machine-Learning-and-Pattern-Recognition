warning off; 
% 图片圆弧检测
img_path = '../pokemon dataset/val_set/';
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);

success_flag = 0;
for i=1:img_num
    img = imread([img_path, img_dir(i).name]); 
    [height, width, deep] = size(img);
    % 图像灰度化
    if deep==3
        gray = uint8(rgb2gray(img));
    else
        gray = uint8(img);
    end
%     figure(1)
%     subplot(1,2,1);
%     imshow(gray);
%     title('灰度图像');
    % 高斯滤波
    % h=fspecial('gaussian',5);   
    % gray=imfilter(gray,h);
    bw = edge(gray, 'canny'); 
%     subplot(1,2,2);
%     imshow(bw);
%     title('二值图像');
    %************************************************************************%
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
%     subplot(1,2,1)
%     hold on
%     rectangle('Position',[ax1, by1, ax2-ax1, by2-by1], 'LineWidth',2, 'EdgeColor','r');
    % 统计每个圆心位置，不同半径时白色像素数量  
    temp_num = 0;
    temp_abr = [0,0,0];
    % x方向搜索
    for a=ax1:step_x:ax2
        % y方向搜索
        for b=by1:step_y:by2
            % r方向搜索
            for r=r_min:step_r:r_max
                % 统计每个角度下，半径端点的白色像素数量
                pixels_num = 0;
                for theta=0:step_angle:pi                                 
                    x1 = a;
                    y1 = b;
                    x2 = floor(a+r*cos(theta));
                    y2 = floor(b-r*sin(theta));
                    if y2==0
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
    % 输出最终的(a,b,r)预测值
    disp(int32([i, img_num, temp_abr]))
%     for theta=0:step_angle:pi                                 
%         subplot(1,2,1)
%         hold on
%         plot(temp_abr(1),temp_abr(2),'x','LineWidth',2,'Color','green');
%         hold on
%         plot(floor(temp_abr(1)+temp_abr(3)*cos(theta)),floor(temp_abr(2)-temp_abr(3)*sin(theta)),'x','LineWidth',1,'Color','green');
%     end
%     hold off
    % 检测圆弧上的小圆
    gray(gray>200) = 255;
    gray(gray<40) = 0; 
    % 高斯滤波
    h=fspecial('gaussian',3);   
    gray=imfilter(gray,h);
    thresh = 1.1*graythresh(gray);
    bw = imbinarize(gray,thresh);  
%     subplot(1,2,2);
    imshow(bw);
    title('二值图像');
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
    % 统计定位成功的小圆的个数
    if temp_center(1)~=width/2 && temp_center(2)~=height/2
        success_flag = success_flag+1;
    end
%     subplot(1,2,2); 
    hold on
    viscircles(temp_center, temp_radii, 'EdgeColor', 'b');
    hold off

    % return
    pause(0.1)
end
sprintf('Total Num:%d, Success Num:%d, Success Rate:%.2f',img_num, success_flag, success_flag/img_num)


% % 图像与sobel算子进行卷积
% % 建立sobel算子
% sobel_xl=[-1,0,1;-2,0,2;-1,0,1];
% sobel_xr=[1,0,-1;2,0,-2;1,0,-1];
% sobel_yl=[1,2,1;0,0,0;-1,-2,-1];
% sobel_yr=[-1,-2,-1;0,0,0;1,2,1];
% % 把图像数据类型转换为双精度浮点类型
% gray=im2double(gray);
% % 卷积
% A=conv2(gray,sobel_xl);
% B=conv2(gray,sobel_xr);
% C=conv2(gray,sobel_yl);
% D=conv2(gray,sobel_yr);
% % 图像二值化
% bw_A=imbinarize(A,graythresh(A));
% bw_B=imbinarize(B,graythresh(B));
% bw_C=imbinarize(C,graythresh(C));
% bw_D=imbinarize(D,graythresh(D));
% % 图像相加
% bw_ABCD=bw_A+bw_B+bw_C+bw_D;
% %消除噪点
% se=strel('disk',2);
% bw=imclose(bw_ABCD,se);


