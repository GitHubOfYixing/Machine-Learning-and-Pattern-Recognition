function [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
% Please DO NOT change the interface
% INPUT: image; model(a struct that contains your classification model, detector, template, etc.)
% OUTPUT: ID(pokemon id, 1-201); level(the position(x,y) of the white dot in the semi circle); cir_center(the position(x,y) of the center of the semi circle)

ID = 1;
CP = 123;
HP = 26;
stardust = 600;
level = [327,165];
cir_center = [355,457];
%****************************************************************************%
[id_img, cp_img, hp_img, sd_img, cir_img, cir_img_pos] = img_extract(img);
% (1)判断是否提取到图像
if isempty(id_img)
    disp('Img Extract Fail...')
    return
end
%****************************************************************************%
% (2)ID图像识别
id_data = get_id_vector(id_img);
id_temp = char(predict(model(1).data.model_id,id_data));
ID = str2double(id_temp);
% disp(ID)
%****************************************************************************%
% (3)CP图像识别
cp_data = get_cp_vector(cp_img);
if isempty(cp_data)
    disp('CP Extract Fail...')
else
    CP = char(predict(model(2).data.model_num,cp_data))';
    % 排除字母干扰
    CP(CP == '_') = '0';
    CP(CP == 'H') = '0';
    CP(CP == 'P') = '0';
    CP = str2double(CP);
    % disp(CP)
end
%****************************************************************************%
% (4)HP图像识别
hp_data = get_hp_vector(hp_img);
if isempty(hp_data)
    disp('HP Extract Fail...')
else
    HP = char(predict(model(2).data.model_num,hp_data))';
    % 定位'H'与'_'的位置
    p1 = find(HP == 'H');
    p2 = find(HP == '_');
    if ~isempty(p1) && ~isempty(p2)
        if p1(1)<p2(1) % H在前，_在后(HPxxx_xxx)
            if p2(1)-p1(1)>2 %HP_影响
                HP = HP(p1(1)+2:p2(1)-1); 
            end
        else %(xxx_xxxHP)
            if p1(1)-p2(1)>1 %_HP影响
                HP = HP(p2(1)+1:p1(1)-1); 
            end
        end
    end
    % 排除字母干扰
    HP(HP == '_') = '0';
    HP(HP == 'H') = '0';
    HP(HP == 'P') = '0';
    HP = str2double(HP); 
    % disp(HP)
end
%****************************************************************************%
% (5)SD图像识别
sd_data = get_sd_vector(sd_img);
if isempty(sd_data)
    disp('Stardust Extract Fail...')
else
    stardust = char(predict(model(2).data.model_num,sd_data))';
    % 排除字母干扰
    stardust(stardust == '_') = '0';
    stardust(stardust == 'H') = '0';
    stardust(stardust == 'P') = '0';   
    stardust = str2double(stardust);
    % disp(stardust)
end
%****************************************************************************%
% (6)CIR图像识别
% point_data白点(a,b,r); cir_data半圆(a,b,r)
[point_data, cir_data] = get_cir_data(cir_img);
% 在原图中的裁剪尺寸cir_img_pos = [x,y,w,h]
% 白点的中心
level = point_data(1:2)+cir_img_pos(1:2);
% 半圆的中心
cir_center = cir_data(1:2)+cir_img_pos(1:2);

end
