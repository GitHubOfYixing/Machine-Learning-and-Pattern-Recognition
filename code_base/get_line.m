% 检测图片中的直线，返回直线数量及其位置
function [line_num, line_pos, line_len] = get_line(img, thresh, max_len) 

% (1)预处理
[height,width,deep] = size(img);
if deep==1
    gray = uint8(img);
else 
    gray = uint8(rgb2gray(img));
end
bw = imbinarize(gray,thresh); 
bw = edge(bw, 'canny');
% (2)hough变换,寻找直线
[H,Theta,Rho] = hough(bw);
peaks = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(bw, Theta, Rho, peaks, 'FillGap', width/12, 'MinLength', 5);
% (3)筛选直线
line_num = 0;
sucess_flag = 0;
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    % 判断是否为横线
    if lines(k).point1(2) == lines(k).point2(2) 
        % 计算横线长度
        line_len = norm(lines(k).point1-lines(k).point2);
        % 只获取大于max_len长度的直线
        if line_len>max_len && line_len<0.95*width
%             plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
%             plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','red');
%             plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
            line_num = line_num+1;
            line_pos = xy;
            % 找到直线位置(中间位置)
            if abs((xy(1,1)+xy(2,1))/2-width/2) < 1.5*width/30
                sucess_flag = 1;
                break
            end
        end
    end  
end
% 未找到直线,返回空
if sucess_flag==0
    line_num = [];
    line_pos = [];
    line_len = [];
end
