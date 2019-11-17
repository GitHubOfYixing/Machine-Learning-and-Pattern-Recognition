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
% (1)�ж��Ƿ���ȡ��ͼ��
if isempty(id_img)
    disp('Img Extract Fail...')
    return
end
%****************************************************************************%
% (2)IDͼ��ʶ��
id_data = get_id_vector(id_img);
id_temp = char(predict(model(1).data.model_id,id_data));
ID = str2double(id_temp);
% disp(ID)
%****************************************************************************%
% (3)CPͼ��ʶ��
cp_data = get_cp_vector(cp_img);
if isempty(cp_data)
    disp('CP Extract Fail...')
else
    CP = char(predict(model(2).data.model_num,cp_data))';
    % �ų���ĸ����
    CP(CP == '_') = '0';
    CP(CP == 'H') = '0';
    CP(CP == 'P') = '0';
    CP = str2double(CP);
    % disp(CP)
end
%****************************************************************************%
% (4)HPͼ��ʶ��
hp_data = get_hp_vector(hp_img);
if isempty(hp_data)
    disp('HP Extract Fail...')
else
    HP = char(predict(model(2).data.model_num,hp_data))';
    % ��λ'H'��'_'��λ��
    p1 = find(HP == 'H');
    p2 = find(HP == '_');
    if ~isempty(p1) && ~isempty(p2)
        if p1(1)<p2(1) % H��ǰ��_�ں�(HPxxx_xxx)
            if p2(1)-p1(1)>2 %HP_Ӱ��
                HP = HP(p1(1)+2:p2(1)-1); 
            end
        else %(xxx_xxxHP)
            if p1(1)-p2(1)>1 %_HPӰ��
                HP = HP(p2(1)+1:p1(1)-1); 
            end
        end
    end
    % �ų���ĸ����
    HP(HP == '_') = '0';
    HP(HP == 'H') = '0';
    HP(HP == 'P') = '0';
    HP = str2double(HP); 
    % disp(HP)
end
%****************************************************************************%
% (5)SDͼ��ʶ��
sd_data = get_sd_vector(sd_img);
if isempty(sd_data)
    disp('Stardust Extract Fail...')
else
    stardust = char(predict(model(2).data.model_num,sd_data))';
    % �ų���ĸ����
    stardust(stardust == '_') = '0';
    stardust(stardust == 'H') = '0';
    stardust(stardust == 'P') = '0';   
    stardust = str2double(stardust);
    % disp(stardust)
end
%****************************************************************************%
% (6)CIRͼ��ʶ��
% point_data�׵�(a,b,r); cir_data��Բ(a,b,r)
[point_data, cir_data] = get_cir_data(cir_img);
% ��ԭͼ�еĲü��ߴ�cir_img_pos = [x,y,w,h]
% �׵������
level = point_data(1:2)+cir_img_pos(1:2);
% ��Բ������
cir_center = cir_data(1:2)+cir_img_pos(1:2);

end
