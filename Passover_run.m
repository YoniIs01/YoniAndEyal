clc, clear, close all;
count_dol=1;
count_Numgrains=1;
Mechanical_Dissolution_prenentage=zeros(50,7);
Total_chunk_events=zeros(50,7); 
timesteps=zeros(50,7);
for DoloRatio= 0.02:0.02:1;
    for NumGrains = [100,200,400,800,1600,3200,6400]
close all;
%% initializing Rock matrices(stop 0)
Rock_Images=cell(1,[]);
Rock_Matrixes=cell(1,[]);
Width_Threshold=0; 
Height_Threshold=0;
[Rock_Matrixes{1,1},Rock_Images{1,1},Height_Threshold,Width_Threshold]...
    =Create_Rock_Image_with_boundaries(DoloRatio,NumGrains);%creating the initial rock
Rock_Frames(1)=im2frame(Rock_Images{1,1});%creating frame from 1st rock
%% initializing Rock disolution(step 1)
Rock_Matrixes{1,2}=Rock_Matrixes{1,1};
Rock_Matrixes{1,2}(1,:)=0;
Rock_Images{1,2}=label2rgb(Rock_Matrixes{1,2});
Rock_Frames(2)=im2frame(Rock_Images{1,2});
%% creating frames for dissolution until complete disolution (step 2:n)   
ii=2; %time steps
Chunck_Events(1:2)=0; %calcultes the total chunk events
Mechanical_Dissolution(1:2)=0; %calculates the total chunk pixel area
BBox=[1,length(Rock_Matrixes{1,2}(:,1))-Height_Threshold,Width_Threshold,...
    length(Rock_Matrixes{1,ii}(1,:))-Width_Threshold];
%the min row, max row, min col, max col in which calculation of procceses 
% is not influenced by boundary conditions
BboxMatrix=zeros(size(Rock_Matrixes{1,ii}));
BboxMatrix(BBox(1):BBox(2),BBox(3):BBox(4))=1;%creating the matrix of bbox
while (sum(sum(Rock_Matrixes{1,ii}(BBox(1):BBox(2),BBox(3):BBox(4))~=0))>0)
%while (Rock_Matrixes{1,ii}(BBox(1):BBox(2),BBox(3):BBox(4))~=0)
% Dissolution will stop when the pixels inside threshold have been disolved
    ii=ii+1; %time steps
    [Rock_Matrixes{1,ii},CurrentChunck_Events,CurrentMechanical_Dissolution]=...
    Dissolve_Rock(Rock_Matrixes{1,ii-1},BboxMatrix); %dissolving step
    Chunck_Events(ii)= CurrentChunck_Events; %updating chuck 
    %events
    Mechanical_Dissolution(ii)=CurrentMechanical_Dissolution; %updating chunck area
    Rock_Images{1,ii}=label2rgb(Rock_Matrixes{1,ii}); %saving as images
    Rock_Frames(ii)=im2frame(Rock_Images{1,ii}); %saving as frame
end
Mechanical_Dissolution_prenentage(count_dol,count_Numgrains)...
    =sum(Mechanical_Dissolution)./(BBox(2).*(BBox(4)-BBox(3)+1));
Total_chunk_events(count_dol,count_Numgrains) = sum(Chunck_Events);
timesteps(count_dol,count_Numgrains)=ii;

%% creating a movie from the frames
filename=strcat(num2str(NumGrains),' grains ',num2str(DoloRatio),' Dolomite '...
    ,num2str(length(Rock_Frames)),' timesteps ', num2str(sum(Chunck_Events)),...
    ' Chunk Events ', num2str(sum(Mechanical_Dissolution)), ' chunk area','.mat' );
save(filename,'Rock_Frames');

%movie2avi(Rock_Frames,'video3');

count_Numgrains=count_Numgrains+1;    
    end
    disp(count_dol);
    count_dol=count_dol+1;
end
DoloRatio= 0.02:0.02:1;
NumGrains = [100,200,400,800,1600,3200,6400];
figure(2)
surf(NumGrains,100*DoloRatio,100*Mechanical_Dissolution_percentage);
title('Mechanical Dissolution Ratio Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
zlabel('Mechanical Dissolution Ratio')
colorbar;
%% Mechanical Dissolution EVENTS figure
figure(3)
imagesc(NumGrains,100*DoloRatio,Total_chunk_events)
title('Mechanical Dissolution EVENTS Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
xlim([0,10000])
colorbar;
%% Dissolution Timesteps figure
figure(4)
surf(NumGrains,100*DoloRatio,timesteps)
title('Total timesteps Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
zlabel('Total Timesteps');
colorbar;