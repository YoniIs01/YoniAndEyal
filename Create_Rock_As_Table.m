function[ Rock_Matrix, Height, Width]=...
        Create_Rock_As_Table(Num_Of_Grains_In_Row, Dolomite_Percentage)
%This Function recieves the Rock's Dolomite percentages (Out of 100% 
%Carbonatic Rock) and the Rock's grain size (Described as amount of grains
%inside the Rock's Matrix). The function returns a 2D image of the rock's 
%cross section and the Height and Width of the biggest grain that is used 
%as boundary conditions.
%% Create a rock As A Table
[Line_X_Coordinates ,Line_Y_Coordinates]=meshgrid(0:1/Num_Of_Grains_In_Row:1);
figure('Visible','Off'); 
hold on;
plot(Line_X_Coordinates ,Line_Y_Coordinates,'black','LineWidth',0.2); 
plot(Line_Y_Coordinates, Line_X_Coordinates,'black','LineWidth',0.2); 
% lines that represents boundaries between grains
%% Focusing the diagram on relevant coordinates and Cropping the axis 
set(gcf, 'Position', [0 0 560 420]);
set(gca, 'Position', [0 0 1 1]); %corresponding to the Rock's Coordinates
axis off;
% xlim([0 1]);
% ylim([0 1]);
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
h = ceil(560/Num_Of_Grains_In_Row);
w = ceil(ceil(560/Num_Of_Grains_In_Row)*420/560);
a = ones(w,h);
a(:,h-1:h) = 0;
a(w-1:w,:) = 0;
Offset = 0;
x =repmat([repmat(a,1,Num_Of_Grains_In_Row);[a(:,floor(h*Offset)+1:end) repmat(a,1,Num_Of_Grains_In_Row-1) a(:,1:floor(h*Offset))]],Num_Of_Grains_In_Row/2,1);
Rock_BW_Image = x;
%0.9 is the gray threshhold, designed to make a bold and significant
%border between grains
%Rock_BW_Image=imbinarize(frame2im(getframe(gcf)));
%%
%%
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
%% Definning a different dissolution coefficient to different boundaries
Dolo=Boundaries(Rock_Matrix,CC.NumObjects+1,CC.NumObjects-1); %dolomite buandaries
Calc=Boundaries(Rock_Matrix,round(CC.NumObjects/2),CC.NumObjects-2); %calcite boundaries
%% Assigning dissolution coeficients to pixels according to rock property
Rock_Matrix(Rock_Matrix==(CC.NumObjects+1))=1; % Dolomite
Rock_Matrix(Rock_Matrix==(round(CC.NumObjects/2)))=10; % Calcite
%Rock_Matrix(Rock_Matrix==0)=100; %Grain boundary
Rock_Matrix(Dolo==CC.NumObjects-1)=10; %Dolomite-dolomite boundary
Rock_Matrix(Calc==CC.NumObjects-2)=100;%calcite-calcite boundary
Rock_Matrix((Dolo==CC.NumObjects-1 & Calc==CC.NumObjects-2))=55; %Dolomite-calcite boundary
Rock_Matrix(Rock_Matrix==0)=55;
%difining a different color to each 
%kind of mineral and to the boundaries between minerals
Rock_Matrix=double(Rock_Matrix);%turn Rock_Matrix from labels to double
%% Find width and height of largest grain
%  bb =regionprops(Rock_BW_Image,'BoundingBox');%find bounding boxes of grains
%  bbMatrix = vertcat(bb(:).BoundingBox); %turning into matrix
%  Height=max(bbMatrix(:,3));%largest height
%  Width=max(bbMatrix(:,4));%largest width
Height=129;
Width=109;
close all;
end