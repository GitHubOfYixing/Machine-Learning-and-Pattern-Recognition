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
% 合并模型
for k=1:num      
    model(k).data = load (dir(k).name);
end
% 保存模型
save('model.mat','model'); 
% 加载模型
% load('model.mat');



