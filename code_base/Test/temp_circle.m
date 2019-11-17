 % ͼƬԲ�����
img_path = '../pokemon dataset/val_set/';
img_dir = dir([img_path,'*.*g']);
img_num = length(img_dir);
for i=1:img_num
    img = imread([img_path, img_dir(i).name]); 
    [height, width, deep] = size(img);
    Area = height*width;   
    if deep==3
        gray = uint8(rgb2gray(img));
    else
        gray = uint8(img);
    end
    % BW1=edge(gray,'sobel');     % ��Sobel���ӽ��б�Ե���
    % BW2=edge(gray,'roberts');   % ��Roberts���ӽ��б�Ե���
    % BW3=edge(gray,'prewitt');   % ��Prewitt���ӽ��б�Ե���
    % BW4=edge(gray,'log');       % ��Log���ӽ��б�Ե���
    % BW5=edge(gray,'canny');     % ��Canny���ӽ��б�Ե���
    % h=fspecial('gaussian',5);   % ��˹�˲�
    % gray=imfilter(gray,h);      % Ϊ�˲����ֺڱߣ�ʹ�ò���'replicate'������ͼ����ⲿ�߽�ͨ�������ڲ��߽��ֵ����չ��  
    % BW6=edge(gray,'canny');     % ��˹�˲���ʹ��Canny���ӽ��б�Ե���
    
    gray(gray>200) = 255;
    gray(gray<50) = 0;  
    thresh = graythresh(gray);
    bw = imbinarize(gray,thresh);
    % bw = bwareaopen(bw,double(int32(Area/300))); 
    imshow(bw)
    [centers, radii] = imfindcircles(bw,[floor(height/65) floor(height/30)],'ObjectPolarity','bright');
    disp('Hello')
    disp(radii)
    disp([floor(height/65) floor(height/30)])
    disp('World')
    viscircles(centers, radii,'EdgeColor','b');  
    pause(0.5)
    % return
end