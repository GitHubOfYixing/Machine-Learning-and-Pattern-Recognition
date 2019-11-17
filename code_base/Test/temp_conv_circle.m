warning off; 
% ͼƬԲ�����
img_path = '../pokemon dataset/val_set/';
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);

success_flag = 0;
for i=1:img_num
    img = imread([img_path, img_dir(i).name]); 
    [height, width, deep] = size(img);
    % ͼ��ҶȻ�
    if deep==3
        gray = uint8(rgb2gray(img));
    else
        gray = uint8(img);
    end
%     figure(1)
%     subplot(1,2,1);
%     imshow(gray);
%     title('�Ҷ�ͼ��');
    % ��˹�˲�
    % h=fspecial('gaussian',5);   
    % gray=imfilter(gray,h);
    bw = edge(gray, 'canny'); 
%     subplot(1,2,2);
%     imshow(bw);
%     title('��ֵͼ��');
    %************************************************************************%
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
%     subplot(1,2,1)
%     hold on
%     rectangle('Position',[ax1, by1, ax2-ax1, by2-by1], 'LineWidth',2, 'EdgeColor','r');
    % ͳ��ÿ��Բ��λ�ã���ͬ�뾶ʱ��ɫ��������  
    temp_num = 0;
    temp_abr = [0,0,0];
    % x��������
    for a=ax1:step_x:ax2
        % y��������
        for b=by1:step_y:by2
            % r��������
            for r=r_min:step_r:r_max
                % ͳ��ÿ���Ƕ��£��뾶�˵�İ�ɫ��������
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
                % ��¼��һ�ε������������Լ���Ӧ��(a,b,r)ֵ
                % ������µ�(a,b,r)��ͳ�Ƶİ�ɫ������������һ�ζ࣬����(a,b,r)ֵ
                if pixels_num>temp_num
                    temp_num = pixels_num;
                    temp_abr = [a,b,r];
                end
            end
        end
    end
    % ������յ�(a,b,r)Ԥ��ֵ
    disp(int32([i, img_num, temp_abr]))
%     for theta=0:step_angle:pi                                 
%         subplot(1,2,1)
%         hold on
%         plot(temp_abr(1),temp_abr(2),'x','LineWidth',2,'Color','green');
%         hold on
%         plot(floor(temp_abr(1)+temp_abr(3)*cos(theta)),floor(temp_abr(2)-temp_abr(3)*sin(theta)),'x','LineWidth',1,'Color','green');
%     end
%     hold off
    % ���Բ���ϵ�СԲ
    gray(gray>200) = 255;
    gray(gray<40) = 0; 
    % ��˹�˲�
    h=fspecial('gaussian',3);   
    gray=imfilter(gray,h);
    thresh = 1.1*graythresh(gray);
    bw = imbinarize(gray,thresh);  
%     subplot(1,2,2);
    imshow(bw);
    title('��ֵͼ��');
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
    % ͳ�ƶ�λ�ɹ���СԲ�ĸ���
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


% % ͼ����sobel���ӽ��о��
% % ����sobel����
% sobel_xl=[-1,0,1;-2,0,2;-1,0,1];
% sobel_xr=[1,0,-1;2,0,-2;1,0,-1];
% sobel_yl=[1,2,1;0,0,0;-1,-2,-1];
% sobel_yr=[-1,-2,-1;0,0,0;1,2,1];
% % ��ͼ����������ת��Ϊ˫���ȸ�������
% gray=im2double(gray);
% % ���
% A=conv2(gray,sobel_xl);
% B=conv2(gray,sobel_xr);
% C=conv2(gray,sobel_yl);
% D=conv2(gray,sobel_yr);
% % ͼ���ֵ��
% bw_A=imbinarize(A,graythresh(A));
% bw_B=imbinarize(B,graythresh(B));
% bw_C=imbinarize(C,graythresh(C));
% bw_D=imbinarize(D,graythresh(D));
% % ͼ�����
% bw_ABCD=bw_A+bw_B+bw_C+bw_D;
% %�������
% se=strel('disk',2);
% bw=imclose(bw_ABCD,se);


