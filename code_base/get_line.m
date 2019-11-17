% ���ͼƬ�е�ֱ�ߣ�����ֱ����������λ��
function [line_num, line_pos, line_len] = get_line(img, thresh, max_len) 

% (1)Ԥ����
[height,width,deep] = size(img);
if deep==1
    gray = uint8(img);
else 
    gray = uint8(rgb2gray(img));
end
bw = imbinarize(gray,thresh); 
bw = edge(bw, 'canny');
% (2)hough�任,Ѱ��ֱ��
[H,Theta,Rho] = hough(bw);
peaks = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(bw, Theta, Rho, peaks, 'FillGap', width/12, 'MinLength', 5);
% (3)ɸѡֱ��
line_num = 0;
sucess_flag = 0;
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    % �ж��Ƿ�Ϊ����
    if lines(k).point1(2) == lines(k).point2(2) 
        % ������߳���
        line_len = norm(lines(k).point1-lines(k).point2);
        % ֻ��ȡ����max_len���ȵ�ֱ��
        if line_len>max_len && line_len<0.95*width
%             plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
%             plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','red');
%             plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
            line_num = line_num+1;
            line_pos = xy;
            % �ҵ�ֱ��λ��(�м�λ��)
            if abs((xy(1,1)+xy(2,1))/2-width/2) < 1.5*width/30
                sucess_flag = 1;
                break
            end
        end
    end  
end
% δ�ҵ�ֱ��,���ؿ�
if sucess_flag==0
    line_num = [];
    line_pos = [];
    line_len = [];
end
