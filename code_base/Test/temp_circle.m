 % 图片圆弧检测
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
    % BW1=edge(gray,'sobel');     % 用Sobel算子进行边缘检测
    % BW2=edge(gray,'roberts');   % 用Roberts算子进行边缘检测
    % BW3=edge(gray,'prewitt');   % 用Prewitt算子进行边缘检测
    % BW4=edge(gray,'log');       % 用Log算子进行边缘检测
    % BW5=edge(gray,'canny');     % 用Canny算子进行边缘检测
    % h=fspecial('gaussian',5);   % 高斯滤波
    % gray=imfilter(gray,h);      % 为了不出现黑边，使用参数'replicate'（输入图像的外部边界通过复制内部边界的值来扩展）  
    % BW6=edge(gray,'canny');     % 高斯滤波后使用Canny算子进行边缘检测
    
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