% ͼƬ�Ҷȷ�ת
img_path = '../pokemon dataset/num_train_set/P/';
img_dir = dir([img_path,'*.jpg']);
img_num = length(img_dir);
disp(img_num)

for i=1:img_num
    img = imread([img_path, img_dir(i).name]); 
    [~,~,deep] = size(img);
    if deep==3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    gray_img(gray_img<50) = 0;
    gray_img(gray_img>150) = 255;
    % imshow(gray_img)
    % pause(1)
    imwrite(gray_img,strcat(img_path,num2str(i),'.jpg'));
end