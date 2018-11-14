function[ Rock_Matrix , Rock_Image, Height, Width]=...
        Create_Rock_As_Brickwall(Num_Of_Grains_In_Row)
%This Function recieves the Rock's Dolomite percentages (Out of 100% 
%Carbonatic Rock) and the Rock's grain size (Described as amount of grains
%inside the Rock's Matrix). The function returns a 2D image of the rock's 
%cross section and the Height and Width of the biggest grain that is used 
%as boundary conditions.
%% Create a rock As Brick Wall
Brick_Width = 1/Num_Of_Grains_In_Row;
Cood = 0:Brick_Width:1; 
[Line_X_Coordinates ,Line_Y_Coordinates]=meshgrid(Cood);
figure('Visible','Off'); 
hold on;
plot(Line_Y_Coordinates, Line_X_Coordinates,'black','LineWidth',0.1);
Brick_Offset_Divider = 5; % Default value
for i = 1:length(Cood)
    Y_Coods = [i*Brick_Width (i-1)*Brick_Width]';
    Y_Coods = repmat(Y_Coods,1,length(Cood));
    X_Coods_Offset = mod(i*Brick_Width/Brick_Offset_Divider,Brick_Width);
    plot(Line_X_Coordinates(1:2,:) + X_Coods_Offset,Y_Coods,'black','LineWidth',0.1); 
end
% lines that represents boundaries between grains
xlim([0 1]);
ylim([0 1]);
%% Focusing the diagram on relevant coordinates and Cropping the axis 
axis off;
set(gca, 'Position', [0 0 1 1]); %corresponding to the Rock's Coordinates
%% Turning the plot into a rgb image that represents the rock
%This section takes the voronoi diagram and by first turning it to a gray
%Scale image and later to a black and white image, we can control each
%individual grain (voronoi cell) color which represent a different mineral
%type.
%%
Rock_Frame = getframe(gcf);  %turns the plot into a struct
[Rock_Temp_Image,~] = frame2im(Rock_Frame); %turns the struct into an image
Rock_Gray_Image=rgb2gray(Rock_Temp_Image); %turns the image to grayscale 
Rock_BW_Image = im2bw(Rock_Gray_Image,0.9);%turns image to BW
%0.9 is the gray threshhold, designed to make a bold and significant
%border between grains
% Rock_BW_Image=im2bw(frame2im(getframe(gcf)),0.9);
%%
CC=bwconncomp(Rock_BW_Image); %finding coonected components in the rock 
Rock_Matrix = labelmatrix(CC); %labeling every grain in the rock's image
%% Defining the rock's composition

Rock_Matrix(Rock_Matrix~= (CC.NumObjects+1) & Rock_Matrix~=0)=...
     round(CC.NumObjects/2);%labeling no-dolomite with a unique number (color)
%% Definning a different dissolution coefficient to different boundaries
Calc=Boundaries(Rock_Matrix,round(CC.NumObjects/2),CC.NumObjects-2); %calcite boundaries
%% Assigning dissolution coeficients to pixels according to rock property
Rock_Matrix(Rock_Matrix==(round(CC.NumObjects/2)))=10; % Calcite
%Rock_Matrix(Rock_Matrix==0)=100; %Grain boundary
Rock_Matrix(Calc==CC.NumObjects-2)=100;%calcite-calcite boundary
Rock_Matrix(Rock_Matrix==0)=55;
%difining a different color to each 
%kind of mineral and to the boundaries between minerals

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