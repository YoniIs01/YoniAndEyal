function[ Rock_Matrix, Height, Width]=...
        Create_Rock_As_Stylolites()
    %% Importing Image
    Rock_Gray_Image = rgb2gray(imread('StyloCut.png'));
    Rock_Gray_Image  = Rock_Gray_Image(:,1:1280,:);
    Rock_BW_Image = im2bw(Rock_Gray_Image,0.7);
    %% 
    CC=bwconncomp(Rock_BW_Image); %finding coonected components in the rock 
    Rock_Matrix = labelmatrix(CC); %labeling every grain in the rock's image
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
    Rock_Matrix=double(Rock_Matrix);%turn Rock_Matrix from labels to double
    %% Find width and height of largest grain
    %  bb =regionprops(Rock_BW_Image,'BoundingBox');%find bounding boxes of grains
    %  bbMatrix = vertcat(bb(:).BoundingBox); %turning into matrix
    %  Height=max(bbMatrix(:,3));%largest height
    %  Width=max(bbMatrix(:,4));%largest width
    Height=129;
    Width=109;
end
