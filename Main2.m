clc, clear, close all;
%% Receiving rock parameters from user
%Dolomite to Calcite ratio in the Rock is from 0 (all Calcite) to 1 (all
%Dolomite).
User_Message_1 = ...
'please insert Dolomite to Calcite ratio in the Rock (between 0 and 1): ';
DoloRatio = str2double(cell2mat(inputdlg(User_Message_1)));
%The number of grains in the simulated rock. The larger the number of
%grains, the smaller the size of grains in the cross section. This 
%parameter usually varies from 100 to 10000.
User_Message_2 = ...
'please insert the number of grains in the rock (between 100 and 10,000): ';
NumGrains = str2double(cell2mat(inputdlg(User_Message_2)));
if (NumGrains<100||NumGrains>10000||DoloRatio<0||DoloRatio>1)
%Checks if the input is valid and breaks in case it is not.  
   disp('Wrong input parameters. please restart program!'); 
   return;
end 
%% Initializing Parameters
%In this section we initialize the cells that will hold the rock's
%properties in each time step and initiate other variables.
Rock_Images=cell(1,[]); %will hold the rock's image in every timestep.
Rock_Matrixes=cell(1,[]); %will hold the rock's matrix in every timestep.
%initializing the variables that holds the rock's boundary conditions.
Width_Threshold=0;  
Height_Threshold=0;
%Creating the vectors that will contain the data of the mechanical
%dissolution; The Mechanical_Dissolution vector holds the total pixel area
%that was dissolved in chunk events (events when a whole chunk is detached
%from the rock to the solution). The Chunck_Events vector holds the amount
%of chunk events.
Mechanical_Dissolution(1:2)=0; %Calculates the total chunk pixel area
Chunck_Events(1:2)=0; %Calcultes the total chunk events
%% Building the Rock (Time Step 0) 
% The Rock is first built by the function 'Create_Rock_Image'.
[Rock_Matrixes{1,1},Rock_Images{1,1},Height_Threshold,Width_Threshold]...
    =Create_Rock_Image(DoloRatio,NumGrains);%creating the initial rock
Rock_Frames(1)=im2frame(Rock_Images{1,1});%creating frame from 1st rock
%every step is being recorded as a frame, all the frames will be converted 
%to a movie that visualizes the dissolution process.  
%% Initializing Rock dissolution (Time Step 1)
%copying the rock matrix and than replacing the upper layer with solution 
Rock_Matrixes{1,2}=Rock_Matrixes{1,1};%copying the matrix
Rock_Matrixes{1,2}(1,:)=0;%the value 0 represents dissolution
Rock_Images{1,2}=label2rgb(Rock_Matrixes{1,2});%saving the matrix as image
Rock_Frames(2)=im2frame(Rock_Images{1,2});%converting image to frame
%% Creating frames for dissolution until complete dissolution (step 2:n)
% In this section we first create a matrix of the bounding area where the
% Dissolution is not influenced by boundary conditions. Later the
% dissolution happens inside a while loop for as long as the area in the
% bounding box has not been completely dissolved.
% In every timestep the rock's matrix, chunk events and chunk area is being
% calculated and the rock's image is being converted into frame.
ii=2; %Time steps
BBox=[1,length(Rock_Matrixes{1,2}(:,1))-Height_Threshold,...
    Width_Threshold,length(Rock_Matrixes{1,ii}(1,:))-Width_Threshold];
%the min row, max row, min col, max col in which calculation of procceses 
% is not influenced by boundary conditions
BboxMatrix=zeros(size(Rock_Matrixes{1,ii}));%initializing bbox matrix
BboxMatrix(BBox(1):BBox(2),BBox(3):BBox(4))=1;%creating the matrix of bbox
while (sum(sum(Rock_Matrixes{1,ii}(BBox(1):BBox(2),BBox(3):BBox(4))~=0))>0)
% Dissolution will stop when the pixels inside bbox have been disolved
    ii=ii+1; %time steps
    %The function 'Dissolve_Rock' is used here to calculate the rock
    %current matrix, Chunck_Events and Mechanical_Dissolution for each time
    %step.
    [Rock_Matrixes{1,ii},CurrentChunck_Events,...
     CurrentMechanical_Dissolution]=...
     Dissolve_Rock(Rock_Matrixes{1,ii-1},BboxMatrix);
    Chunck_Events(ii)= CurrentChunck_Events; %updating chuck events
    Mechanical_Dissolution(ii)=CurrentMechanical_Dissolution; ...
    %updating chunck area
    Rock_Images{1,ii}=label2rgb(Rock_Matrixes{1,ii}); %saving as image
    Rock_Frames(ii)=im2frame(Rock_Images{1,ii}); %saving as frame
end

%% Calculating Mechanical Dissolution percentage 
%We divide the total mechnical dissolution pixels inside the bounding box
%with the area of interest.
Mechanical_Dissolution_percentage...
    =sum(Mechanical_Dissolution)./(BBox(2).*(BBox(4)-BBox(3)+1));
%% Summary of Model output
disp(strcat('Model results for- ',num2str(NumGrains),' grains- '...
  ,num2str(DoloRatio),'% Dolomite is:',num2str(length(Rock_Frames)),...
  ' -timesteps ', num2str(sum(Chunck_Events)),...
  ' -Chunk Events ', num2str(Mechanical_Dissolution_percentage),...
  ' -Mechanical Dissolution Percentage'));
%% Creating a movie from the frames
filename=strcat(num2str(NumGrains)...
    ,'_Grains_',num2str(DoloRatio),'_%Dolomite''.mat' );
save(filename,'Rock_Frames');
implay(Rock_Frames);
%% Plotting process information
figure (2);
subplot(2,1,1);
plot (1:ii,Mechanical_Dissolution);
set(gca,'fontsize',16);
title('Mechanical Dissolution at every time step');  
xlabel('Timesteps');
ylabel('Mechanical Dissolution');
subplot (2,1,2)
plot (1:ii,Chunck_Events);
set(gca,'fontsize',16);
title('Mechanical Dissolution Events at every time step');  
xlabel('Timesteps');
ylabel('Mechanical Dissolution Events');

