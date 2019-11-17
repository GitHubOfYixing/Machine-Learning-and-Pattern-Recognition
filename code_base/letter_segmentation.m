% 连接二值图像分割函数
function data = letter_segmentation(bw) 

%********************************************************************************************%
[height, width] = size(bw);
bw_fill = imfill(bw,'holes');
Area = height*width; 
% 线扫描分割算法
f_num = zeros(height,1,'int8');
% 统计每一列白色像素的个数
for i=1:width
    f_num(i) = sum(bw_fill(:,i));
end

% figure(2)
% plot(1:width, f_num, '-')

% 计算离散数据极值
value = sign(diff(f_num));
value(value==-1)='A';
value(value==0)='O';
value(value==1)='B';
str = char(value)';
% 匹配O字符至少出现0次
pat = 'A[O]{0,}+B';
% 查找梯度下降结束的起始位置
[pos_start, pos_end, ~] = regexpi(str,pat,'start','end','match');

% hold on
% plot(pos_start+1, f_num(pos_start+1), '*')

% 统计梯度下降结束后,零梯度像素数量
zero_num = pos_end-pos_start-1;
X_pos = pos_start+1;
% 判断H字符的位置
if length(zero_num)>2
    if zero_num(1)>zero_num(end-2)
        % 确定分割线的位置
        H_pos = X_pos(1);
        X_pos = X_pos(2:end);
    else
        H_pos = X_pos(end-1);
        X_pos = X_pos(1:end-2);
    end
else
    H_pos = 1;
    X_pos = 1;
end
Y_pos = f_num(X_pos)';
% 删除极小值比H值大的点
X_pos = X_pos(Y_pos<f_num(H_pos));
bw(:,X_pos) = zeros(height,length(X_pos),'int8');
data = bwareaopen(bw,double(int32(Area/500))); 

% hold on
% text(double(H_pos),double(f_num(H_pos)),'H');
% hold off
%********************************************************************************************%


