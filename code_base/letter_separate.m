% 字母分离函数,将分离后的字母转成1024列向量
function data = letter_separate(bw, condition) 

%********************************************************************************************%
[height, width] = size(bw);
Area = height*width; 
[I_Labeled,~] = bwlabel(bw,4);  
stats = regionprops(I_Labeled,'all');
obj_num = size(stats);
data = [];
if obj_num == 0
    return
end
count = 0;

% figure(2)
for index=1:obj_num
    box = stats(index).BoundingBox;
    x = box(:,1);
    y = box(:,2);
    w = box(:,3);
    h = box(:,4);
    % 筛选满足条件的图片
    if eval(condition)
        count = count+1;
        bw_img = imcrop(bw,[x-w/8,y-h/8,w+2*w/8,h+2*h/8]);
        bw_img = imclearborder(bw_img,8);  
        img_size = [32,32];
        bw_img = imresize(bw_img, img_size);
        data(count,:) = img_to_vector(bw_img, img_size);     
        
%         if condition=="h > 1.3*height/4"
%             subplot(1,6,count)
%             imshow(bw_img)  
%         end      
    end
end

