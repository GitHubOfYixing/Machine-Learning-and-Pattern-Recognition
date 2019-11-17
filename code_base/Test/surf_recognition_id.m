% ����ͼ���ָ�ƣ���Ԥ�����ǩ
function [label, score] = surf_recognition_id(img) 

if nargin~=1
    return
end
%****************************************************************************************************%
% ��ȡ����ͼƬ��SURF����
[~,~,deep] = size(img);
if deep==3
    test_gray_img = rgb2gray(img);
else
    test_gray_img = uint8(img);
end
thresh = graythresh(test_gray_img); 
test_bw_img = imbinarize(test_gray_img,thresh);
test_img_points = detectSURFFeatures(test_bw_img);
[test_img_Features, test_img_Points] = extractFeatures(test_bw_img, test_img_points);
%****************************************************************************************************%
% ����ѵ��ͼƬ���ݿ�
doc_path = '..\pokemon dataset\img_train_set\';
doc_dir = dir([doc_path,'*']);
doc_num = length(doc_dir);
doc_dir = doc_dir(3:doc_num);
doc_num = length(doc_dir);
max_score = zeros(1,doc_num);
max_score_name = strings(doc_num,1);
for j=1:doc_num
    img_path = strcat(doc_path,doc_dir(j).name,'\');
    img_dir = dir([img_path,'*.*g']);
    img_num = length(img_dir);
    for i = 1:1%img_num 
        img = imread([img_path, img_dir(i).name]); 
        [~,~,deep] = size(img);
        if deep==3
            gray_img = rgb2gray(img);
        else
            gray_img = img;
        end
        thresh = graythresh(gray_img);
        bw_img = imbinarize(gray_img,thresh);
        % ���img��SURF����
        img_points = detectSURFFeatures(bw_img);
        % ��ȡ����������
        [img_Features, img_Points] = extractFeatures(bw_img, img_points);
        % ��������ͼ���ƥ���
        boxPairs = matchFeatures(test_img_Features, img_Features, 'Prenormalized', true);
        % ��ʾƥ�䵽������
        matched_test_img_Points = test_img_Points(boxPairs(:, 1), :);
        matched_img_Points = img_Points(boxPairs(:, 2), :);
        % showMatchedFeatures(test_gray_img, img, matched_sd_img_Points, matched_img_Points, 'montage');
        % plot(selectStrongest(img_points, 100));
        if ~isempty(boxPairs)
            % ɾ��������ƥ���('similarity'��'affine'��'projective')
            [~, inlierBoxPoints, inlierScenePoints,status] = estimateGeometricTransform(matched_test_img_Points, matched_img_Points, 'affine');
            if status~=0
                inlierScenePoints = 0;
            end
        end
        % showMatchedFeatures(test_gray_img, gray_img, inlierBoxPoints, inlierScenePoints, 'montage');
        % disp([length(boxPairs), length(inlierScenePoints)])
        max_score_name(j) = doc_dir(j).name; 
        % ���ÿ�������еĵ÷�
        max_score(j) = length(boxPairs);
        % return
    end
end
% ���Ԥ��ֵ
label = max_score_name(max_score==max(max_score));
label = label(1);
score = max(max_score);
% disp([label, score])








