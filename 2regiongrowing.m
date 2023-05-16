function J=regiongrowing(I,x,y,reg_maxdist)


if(exist('reg_maxdist','var')==0)
    reg_maxdist=0.2;
end
if(exist('y','var')==0), figure, imshow(I,[]); 
    [y,x]=getpts;
    y=round(y(1)); 
    x=round(x(1));
end

J = zeros(size(I)); 
Isizes = size(I); 
% The mean of the segmented region
reg_mean = I(x,y); 
reg_size = 1; 
% Free memory to store neighbours 
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 

%distance of the new pixel in the region
pixdist=0; 

% Neighbor locations 
neigb=[-1 0; 1 0; 0 -1;0 1];

% Start regiogrowing until distance between region and posible new pixels become 
%higher than a certain treshold
while(pixdist<reg_maxdist&&reg_size<numel(I))

    % Add new neighbors pixels
    for j=1:4,
        % Calculate the neighbour coordinate and check whether it is inside
        % or outside the image
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        % Add neighbor if inside 
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end

    % Add a new block of free memory
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; 
        neg_list((neg_pos+1):neg_free,:)=0;
    end
    
    % Add pixel with intensity nearest to the mean of the region
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    J(x,y)=2; reg_size=reg_size+1;
    
    % Calculate the new mean of the region
    reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    
    
    % Save the x and y coordinates of the pixel 
    x = neg_list(index,1); 
    y = neg_list(index,2);
    
    % Remove the pixel from the neighbour list
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
end

% Return the segmented area 
J=J>1;




