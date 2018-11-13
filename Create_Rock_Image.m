function[ Rock_Matrix , Rock_Image, Height, Width]=...
        Create_Rock_Image(Dolomite_Percentage,Grain_Size)
%This Function recieves the Rock's Dolomite percentages (Out of 100% 
%Carbonatic Rock) and the Rock's grain size (Described as amount of grains
%inside the Rock's Matrix). The function returns a 2D image of the rock's 
%cross section and the Height and Width of the biggest grain that is used 
%as boundary conditions.
%% Create a rock using Voronoi Diagram
%Extracting the x and y coordinates vectors from uniform distributed  
% numbers between 0 to 1 from Matlab's 'gallery' library 
Rock_x_Coordinates = gallery('uniformdata',[1 Grain_Size],0);
Rock_y_Coordinates = gallery('uniformdata',[1 Grain_Size],1);
[Vor_x_index,Vor_y_index]=voronoi(Rock_x_Coordinates,Rock_y_Coordinates);
%Voronoi diagram represents the grain distribution in the rock, the diagram
%recieves x and y coordinates, there is a corresponding region consisting 
%of all points closer to that coordinate than to any other. These regions
%are called Voronoi cells and they represent grains in the rock, every 
%grain consisting of a specific kind of mineral.
plot(Vor_x_index,Vor_y_index,'black','LineWidth',0.1); %plotting voronoi diagram with black
% lines that represents boundaries between grains
%% Focusing the diagram on relevant coordinates and Cropping the axis 
xlim([min(Rock_x_Coordinates) max(Rock_x_Coordinates)])
ylim([min(Rock_y_Coordinates) max(Rock_y_Coordinates)])
axis off;
set(gca, 'Position', [0 0 1 1]); %corresponding to the Rock's Coordinates
%% Turning the plot into a rgb image that represents the rock
%This section takes the voronoi diagram and by first turning it to a gray
%Scale image and later to a black and white image, we can control each
%individual grain (voronoi cell) color which represent a different mineral
%type.

%{ 
trying to change the path that it will have same results with thinner
boundaries between grains
Rock_Frame = getframe(gcf);  %turns the plot into a struct
[Rock_Temp_Image,~] = frame2im(Rock_Frame); %turns the struct into an image
Rock_Gray_Image=rgb2gray(Rock_Temp_Image); %turns the image to grayscale 
Rock_BW_Image = im2bw(Rock_Gray_Image,0.9);%turns image to BW
%0.9 is the gray threshhold, designed to make a bold and significant
%border between grains
%}
Rock_BW_Image=im2bw(frame2im(getframe(gcf)),0.9);
CC=bwconncomp(Rock_BW_Image); %finding coonected components in the rock 
Rock_Matrix = labelmatrix(CC); %labeling every grain in the rock's image
%% Defining the rock's composition
Dolomite_Grain_Index = randperm(CC.NumObjects,round...
    (Dolomite_Percentage*CC.NumObjects));%randomly selecting grains from 
% the rock to be Dolomite, in the amount relative to the applied percentage 
for ii=1:length(Dolomite_Grain_Index) %the loop converts grains to dolomite
    Rock_Matrix(Rock_Matrix(:,:)==Dolomite_Grain_Index(ii))=...
        (CC.NumObjects+1); %creating a new unique label for dolomite
end
Rock_Matrix(Rock_Matrix~= (CC.NumObjects+1) & Rock_Matrix~=0)=...
 round(CC.NumObjects/2);%labeling no-dolomite with a unique number (color)
% %% Definning a different dissolution coefficient to dolomite boundaries
% for r = (2):(length(Rock_Matrix(:,1))-1) %from 2nd to one before last row
%     for c = (2):(length(Rock_Matrix(1,:))-1) %2nd-one before last column 
%       if Rock_Matrix(r,c)==CC.NumObjects+1 %Dolomite grain
%          if(Rock_Matrix(r-1,c-1)==0)
%              Rock_Matrix(r-1,c-1)=10;
%          end
%          if(Rock_Matrix(r-1,c)==0)
%              Rock_Matrix(r-1,c)=10;
%          end
%          if(Rock_Matrix(r-1,c+1)==0)
%              Rock_Matrix(r-1,c+1)=10;
%          end
%          if(Rock_Matrix(r,c-1)==0)
%              Rock_Matrix(r,c-1)=10;
%          end
%          if(Rock_Matrix(r,c+1)==0)
%              Rock_Matrix(r,c+1)=10;
%          end
%          if(Rock_Matrix(r+1,c-1)==0)
%              Rock_Matrix(r+1,c-1)=10;
%          end
%          if(Rock_Matrix(r+1,c)==0)
%              Rock_Matrix(r+1,c)=10;
%          end
%          if(Rock_Matrix(r+1,c+1)==0)
%              Rock_Matrix(r+1,c+1)=10;
%          end
%       end
%     end
% end

%difining a different color to each 
%kind of mineral and to the boundaries between minerals
%% Assigning dissolution coeficients to pixels according to rock property
Rock_Matrix(Rock_Matrix==(CC.NumObjects+1))=1; % Dolomite
Rock_Matrix(Rock_Matrix==(round(CC.NumObjects/2)))=10; % Calcite
Rock_Matrix(Rock_Matrix==0)=100; %Grain boundary
Rock_Image=label2rgb(Rock_Matrix);%assigning the labels to an image
Rock_Matrix=double(Rock_Matrix);%turn Rock_Matrix from labels to double
%% Find width and height of largest grain
%  bb =regionprops(Rock_BW_Image,'BoundingBox');%find bounding boxes of grains
%  bbMatrix = vertcat(bb(:).BoundingBox); %turning into matrix
%  Height=max(bbMatrix(:,3));%largest height
%  Width=max(bbMatrix(:,4));%largest width
Height=129;
Width=109;
end