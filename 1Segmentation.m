clc;
clear all;
close all;
  
 for i = 1:93
     filename = strcat('...path\Mid Sagittal gray\',int2str(i),'.tif');
     I= im2double(imread(filename));
      figure(1);
      imshow(I);
%       path = strcat('...path\img3(1).png');
%      imwrite(I,path);
  % To subtract the background from the image
    I1=imtophat(I,strel('disk',20));
      figure(2);
      imshow(I1); 
%        path = strcat('...path\img3(2).png');
%      imwrite(I1,path);
  
  % Histogram equalization
     I2=imadjust(I1);
     figure(3);
     imshow(I2);
%       path = strcat('...path\img3(3).png');
%      imwrite(I2,path);
  % To apply threshold to the image
     level=graythresh(I2);
     BW = imbinarize(I2,level);
     figure(4);
     imshow(BW); 
    path = strcat('...path\',int2str(i),'.tif');
   imwrite(BW,path);
  % Region growing
     J = regiongrowing(BW);
     figure(5);
     imshow(J);
  end

 