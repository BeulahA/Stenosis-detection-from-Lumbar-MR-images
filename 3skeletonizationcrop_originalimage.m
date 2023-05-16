clc;
clear all;
close all;

%%Get the input image
 for i =14
    filename = strcat('...path\train image\',int2str(i),'.tif');
    I = imread(filename);
    figure(1);
    imshow(I);
    fn = strcat('..path\Mid Sagittal gray\',int2str(i),'.tif');
    img = imread(fn);
    
  % to perform skeletonization
    A = bwskel(I);
    figure(2);
    imshow(A);
   
  % to find pixel positions
  count = 1;
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
               topcol=col-24;
               plot(topcol,toprow,'yX', 'MarkerSize', 15);
               botrow=row+24;
               botcol=col+24;
               plot(botcol,botrow,'yX', 'MarkerSize', 15);
               hold off;
               
 % To draw a rectangle
               figure(3);
               imshow(img); %consider original image for cropping
               hold on;
               rectangle('Position',[topcol,toprow,47,47],'EdgeColor', 'r', 'LineWidth',2,'LineStyle','-');
               c=imcrop(img,[topcol,toprow,47,47]);    
               hold off;
               w = waitforbuttonpress;
               if w==0
                       path = strcat('path\NS\',int2str(i),'_',int2str(count),'.tif');
                       imwrite(c,path);
               else 
                       path = strcat('path\S\',int2str(i),'_',int2str(count),'.tif');
                       imwrite(c,path);
               end
               count = count+1;
               rowcount=rowcount+1;
             end
         end
      end
  end
 end             
  