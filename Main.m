clc, clear, close all;
%% Receiving rock parameters from user
User_Message = ...
'please enter rock type, 1 for voronoi, 2 for table, 3 for brickwall: ';
RockType = str2double(cell2mat(inputdlg(User_Message)));
IsSmallSize = str2double(cell2mat(inputdlg('please enter 1 for small size mode')));
if (RockType == 1)
    %Dolomite to Calcite ratio in the Rock is from 0 (all Calcite) to 1 (all
    %Dolomite).
    User_Message_1 = ...
    'please insert Dolomite to Calcite ratio in the Rock (between 0 and 1): ';
    DoloRatio = str2double(cell2mat(inputdlg(User_Message_1)));
else
    DoloRatio = 0;
end
;
%The number of grains in the simulated rock. The larger the number of
%grains, the smaller the size of grains in the cross section. This 
%parameter usually varies from 100 to 10000.
User_Message_2 = ...
'please insert the number of grains in the rock (between 100 and 10,000):';
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
Chunck_Areas = []; %stores all area data as sparse data, for histogram
Chunck_Dimensions = []; %stores all area data as sparse data, for histogram
%% Building the Rock (Time Step 0)
% Create_Rock_Image_with_boundaries
if (RockType == 1)
[Rock_Matrixes{1,1},Rock_Images{1,1},Height_Threshold,Width_Threshold]...
    =Create_Rock_Image_with_boundaries(DoloRatio,NumGrains);%creating the initial rock
% Create_Rock_As_Table
elseif (RockType == 2)
[Rock_Matrixes{1,1},Rock_Images{1,1},Height_Threshold,Width_Threshold]...
      =Create_Rock_As_Table(floor(sqrt(NumGrains)));
% Create_Rock_As_Brickwall
elseif (RockType == 3)
[Rock_Matrixes{1,1},Rock_Images{1,1},Height_Threshold,Width_Threshold]...
      =Create_Rock_As_Brickwall(floor(sqrt(NumGrains)));
    end
% For testing
if (IsSmallSize == 1)
    Rock_Matrixes{1,1} = Rock_Matrixes{1,1}(200:600,200:600,:);
    Rock_Images{1,1} = Rock_Images{1,1}(200:600,200:600,:);
    Height_Threshold=5;
    Width_Threshold=5;
end
Rock_Frames(1)=im2frame(Rock_Images{1,1});
% creating frame from 1st rock
% every step is being recorded as a frame, all the frames will be converted 
% to a movie that visualizes the dissolution process.  
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
    [ Rock_Matrixes{1,ii},CurrentChunck_Events,...
    CurrentMechanical_Dissolution]=...
    Dissolve_Rock(Rock_Matrixes{1,ii-1},BboxMatrix);
    Chunck_Events(ii)= length(CurrentChunck_Events); %updating chuck events
    for i = 1:Chunck_Events(ii)
        Chunck_Area = CurrentChunck_Events(i).Area;
        Chunk_Width = CurrentChunck_Events(i).MajorAxisLength;
        Chunk_Height = CurrentChunck_Events(i).MinorAxisLength;
        Chunck_Dimension = ceil(Chunk_Width*Chunk_Height);
        %save chunck data as sparse array
        Chunck_Areas = [Chunck_Areas Chunck_Area];
        Chunck_Dimensions = [Chunck_Dimensions Chunck_Dimension];
    end
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
%% Summerizing Mechanical Dissolution by grain size and dimensions
%Counts how many chunks by size (index is size by pixel, value is counter)
Chunck_Areas_Counter = sum(Chunck_Areas==Chunck_Areas');
Chunck_Areas_Counter = unique([Chunck_Areas' Chunck_Areas_Counter'],'rows');
Chunck_Areas_Frequency = Chunck_Areas_Counter;
Chunck_Areas_Frequency(:,2) = Chunck_Areas_Frequency(:,2) ./ length(Rock_Frames);
%Counts how many chunks by size (index is size by width*height, value is counter)
Chunck_Dimensions_Counter = sum(Chunck_Dimensions==Chunck_Dimensions');
Chunck_Dimensions_Counter = unique([Chunck_Dimensions' Chunck_Dimensions_Counter'],'rows');
Chunck_Dimensions_Frequency = Chunck_Dimensions_Counter;
Chunck_Dimensions_Frequency(:,2) = Chunck_Dimensions_Frequency(:,2) ./ length(Rock_Frames);
%% Summary of Model output
disp(strcat('Model results for- ',num2str(NumGrains),' grains- '...
  ,num2str(DoloRatio),'% Dolomite is:',num2str(length(Rock_Frames)),...
  ' -timesteps ', num2str(sum(Chunck_Events)),...
  ' -Chunk Events ', num2str(Mechanical_Dissolution_percentage),...
  ' -Mechanical Dissolution Percentage'));
%% Creating a movie from the frames
filename=strcat(num2str(NumGrains),' Grains_'...
  ,num2str(DoloRatio),' % Dolomite_',num2str(length(Rock_Frames)),...
  ' -time steps_', num2str(sum(Chunck_Events)),...
  ' -Chunk Events_', num2str(Mechanical_Dissolution_percentage),...
  ' -Mechanical%''.mat');
save(filename,'Rock_Frames','-v7.3');

save(strcat('WS',filename),'*','-v7.3');

implay(Rock_Frames);
%% Plotting process information
figure (2);
subplot(4,2,1);
plot (1:ii,Mechanical_Dissolution);
set(gca,'fontsize',16);
title('Mechanical Dissolution at every time step');  
xlabel('Timesteps');
ylabel('Mechanical Dissolution');
subplot (4,2,2)
plot (1:ii,Chunck_Events);
set(gca,'fontsize',16);
title('Mechanical Dissolution Events at every time step');  
xlabel('Timesteps');
ylabel('Mechanical Dissolution Events');
subplot (4,2,3)
Histogram_Bin_size = 20;
Max_Chunck_Size = max(Chunck_Areas);
histogram(Chunck_Areas)
set(gca,'fontsize',16);
title('Mechanical Dissolution Events By Chunck Size');  
xlabel('Number Of Pixels');
ylabel('Mechanical Dissolution Events');
subplot (4,2,4)
Histogram_Bin_size = 20;
Max_Chunck_Dimension = max(Chunck_Dimensions);
histogram(Chunck_Dimensions)
set(gca,'fontsize',16);
title('Mechanical Dissolution Events By Chunck Dimension');  
xlabel('Dimension Area By Pixels');
ylabel('Mechanical Dissolution Events');
subplot (4,2,5)
scatter(Chunck_Areas_Frequency(:,1),Chunck_Areas_Frequency(:,2))
set(gca,'fontsize',16);
title('Mechanical Dissolution Frequncy By Chunck Size');  
xlabel('Number Of Pixels');
ylabel('Average Frequency');
subplot (4,2,6)
scatter(Chunck_Dimensions_Frequency(:,1),Chunck_Dimensions_Frequency(:,2))
set(gca,'fontsize',16);
title('Mechanical Dissolution Frequncy By Chunck Dimension');  
xlabel('Dimension Area By Pixels');
ylabel('Average Frequency');
%% saving movie as mp3
v=VideoWriter(filename,'MPEG-4');
open(v)
writeVideo(v,Rock_Frames);
close(v)