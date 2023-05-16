%Patiet wise
clc;
clear all;
close all;

%these two files contain the features only for training images (ie. for 70%)
stenosis=load('stenosisfeature.mat');
nonstenosis=load('nonstenosisfeature.mat');

featurestenosis=stenosis.featurestenosis;
featurenonstenosis=nonstenosis.featurenonstenosis;

%1:end --> only for 65 mid-sagittal images
train=[featurestenosis(1:end,1:643);featurenonstenosis(1:end,1:643)];
trainlabel=[featurestenosis(1:end,644);featurenonstenosis(1:end,644)];


Model = fitcknn(train,trainlabel,'NumNeighbors',3,'Standardize',1, 'Distance','euclidean');

predictlabel = predict(Model,train);
Ctrain = confusionmat(trainlabel,Model.Y); 
srcFile = dir('..path\test image\');  
i = 72
    filename = strcat('...\test image\',int2str(i),'.tif');
    I = imread(filename);
    figure(1);
    imshow(I);
    
    
 % to perform skeletonization
    
    A = bwskel(I);
    figure(2);
    imshow(A);
  
  % to find pixel positions
  
  count = 1;
  counter = 1;
  
  for pos = 25:5:450
      rowcount=1;
      for pos1 = 30:400
         if (A(pos,pos1)==1)
             if rowcount==1
               row=pos;
               col=pos1;
               hold on;
               plot( col,row,'yX', 'MarkerSize', 15);
               toprow=row-24; 
               topcol=col-30;
               plot(topcol,toprow,'yX', 'MarkerSize', 15);
               botrow=row+24;
               botcol=col+18;
               plot(botcol,botrow,'yX', 'MarkerSize', 15);
               hold off;

 % To draw a rectangle
            fn = strcat('....\Mid Sagittal gray\',int2str(i),'.tif');
             img = imread(fn);
    
               figure(3);
               imshow(img);
               hold on;
               rectangle('Position',[topcol,toprow,47,47],'EdgeColor', 'r', 'LineWidth',2,'LineStyle','-');
               c = imcrop(img,[topcol,toprow,47,47]); 
               feature{counter} = extractLBPFeatures(c,'CellSize',[16 16]);
               
               glcm = graycomatrix(c);
                stats = graycoprops(glcm);
                glcmstenosis(counter , :)=cell2mat(struct2cell(stats));
                
               boxPoint{counter} = [topcol,toprow,47,47];
               counter = counter + 1;
               count = count+1; 
                rowcount=rowcount+1;
             end
               
           end
      end
  end
  bbox = cell2mat(boxPoint');
  predictlabeltest = ones(length(feature),1);
  lbpstenosis = cell2mat(feature');
  P=[lbpstenosis glcmstenosis];
  
  [predictlabeltest, predictscore] = predict(Model,P); 
  
%   save(strcat('...\Predict Test Label Patientwise\',int2str(i),'.mat'),'predictlabeltest');
  
%   predictscore(:,1) --> Non stenosis
%   predictscore(:,2) --> Stenosis
 	get_detect = predictscore(:,2).*[predictscore(:,2)<1 & predictscore(:,2)>=0.8];

	img =  imread(strcat('....\Mid Sagittal gray\',int2str(i),'.tif')); 
    
  [r,c,v]= find(get_detect);
  tf = isempty(r);
  % If nostenosis in the image perform if statement
  if tf==1
%       I2 = insertObjectAnnotation(img,'rectangle',[50 120 75 75],'No Stenosis','Color','r','TextColor','black','FontSize' ,14);
        str = 'No Stenosis';
        I2=insertText(img,[20 40],str,'FontSize',14,'BoxColor','red','TextColor','white');
        figure(4);
        imshow(I2);
        % path to store the stenosis detected image
        %imwrite works well
%         imwrite(I2,strcat('....\Stenosis Output\',int2str(i),'.tif'));
  
  %if there is stenosis in the image perform else statement  
  else    
    for ix = 1:length(r)
         rects{ix}= boxPoint{r(ix)};
         thisrect{ix} = rects{ix};
    end
    boundbox = cell2mat(rects');
    [selectedBbox,selectedScore] = selectStrongestBbox(boundbox,v,'OverlapThreshold',0.05);
  
 
    label=['Stenosis'];
    I2 = insertObjectAnnotation(img,'rectangle',selectedBbox,cellstr(num2str(selectedScore)),'Color','r');
    figure(4);
    imshow(I2);
    %imwrite works well
%     imwrite(I2,strcat('....\Stenosis Output\',int2str(i),'.tif'));
  end
%   imsave(gcf);
  
 
  