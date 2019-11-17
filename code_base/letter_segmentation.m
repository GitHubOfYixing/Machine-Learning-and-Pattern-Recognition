% ���Ӷ�ֵͼ��ָ��
function data = letter_segmentation(bw) 

%********************************************************************************************%
[height, width] = size(bw);
bw_fill = imfill(bw,'holes');
Area = height*width; 
% ��ɨ��ָ��㷨
f_num = zeros(height,1,'int8');
% ͳ��ÿһ�а�ɫ���صĸ���
for i=1:width
    f_num(i) = sum(bw_fill(:,i));
end

% figure(2)
% plot(1:width, f_num, '-')

% ������ɢ���ݼ�ֵ
value = sign(diff(f_num));
value(value==-1)='A';
value(value==0)='O';
value(value==1)='B';
str = char(value)';
% ƥ��O�ַ����ٳ���0��
pat = 'A[O]{0,}+B';
% �����ݶ��½���������ʼλ��
[pos_start, pos_end, ~] = regexpi(str,pat,'start','end','match');

% hold on
% plot(pos_start+1, f_num(pos_start+1), '*')

% ͳ���ݶ��½�������,���ݶ���������
zero_num = pos_end-pos_start-1;
X_pos = pos_start+1;
% �ж�H�ַ���λ��
if length(zero_num)>2
    if zero_num(1)>zero_num(end-2)
        % ȷ���ָ��ߵ�λ��
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
% ɾ����Сֵ��Hֵ��ĵ�
X_pos = X_pos(Y_pos<f_num(H_pos));
bw(:,X_pos) = zeros(height,length(X_pos),'int8');
data = bwareaopen(bw,double(int32(Area/500))); 

% hold on
% text(double(H_pos),double(f_num(H_pos)),'H');
% hold off
%********************************************************************************************%


