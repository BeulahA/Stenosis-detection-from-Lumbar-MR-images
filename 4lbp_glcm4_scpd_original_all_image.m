clc;
clear all;
close all;

srcFilestenosis = dir('...path\S\*.tif');

srcFilenonstenosis = dir('...path\NS\*.tif'); 

 for num = 1 :length(srcFilestenosis)
    gray = imread(strcat('...path\S\',srcFilestenosis(num).name));
    lbpstenosis(num , :) = extractLBPFeatures(gray,'CellSize',[16 16]);
    glcm = graycomatrix(gray, 'Offset',[0 1; -1 1; -1 0; -1 -1] );
    stats = graycoprops(glcm);
    G=cell2mat(struct2cell(stats));
    C=G(:);
    glcmstenosis(num , :)=C';
	scpdstenosis(num , :)=scpd(gray);
  end
    

disp('LBP stenosis completed');


 for num = 1 : length(srcFilenonstenosis)
     gray = imread(strcat('...path\NS\',srcFilenonstenosis(num).name));
     lbpnonstenosis(num , :) = extractLBPFeatures(gray,'CellSize',[16 16]);
     glcm = graycomatrix(gray, 'Offset',[0 1; -1 1; -1 0; -1 -1] );
    stats = graycoprops(glcm);
    G=cell2mat(struct2cell(stats));
    C=G(:);
    glcmnonstenosis(num , :)=C';
	scpdnonstenosis(num , :)=scpd(gray);
  end

disp('LBP nonstenosis completed');
  
labelstenosis= ones(1,1598);
labelnonstenosis= zeros(1,6366);
lbpfeaturestenosis = [lbpstenosis glcmstenosis scpdstenosis labelstenosis'];
lbpfeaturenonstenosis = [lbpnonstenosis glcmnonstenosis scpdnonstenosis labelnonstenosis'];

save('stenosisfeature_lbp_glcm4_scpd.mat','lbpfeaturestenosis');
save('nonstenosisfeature_lbp_glcm4_scpd.mat','lbpfeaturenonstenosis');

