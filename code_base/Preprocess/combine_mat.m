clc;
clear
close all;
warning off;

path = '..\code_base\';
if exist(strcat(path,'model.mat'),'file')~=0
    delete model.mat
end

dir = dir([path,'*.mat']);
num = length(dir);
model = struct('data',{});
% �ϲ�ģ��
for k=1:num      
    model(k).data = load (dir(k).name);
end
% ����ģ��
save('model.mat','model'); 
% ����ģ��
% load('model.mat');



