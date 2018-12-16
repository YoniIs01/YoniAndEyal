function [ Current_Rock_Matrix, Chunck_Events, Mechanical_Dissolution ] ...
    = Dissolve_Rock(Previous_Rock_Matrix, bbox)
%The function recieves the matrix of the rock in it's previous disolution 
%step and the bounding box in which the calculations are not effected from
%the boundaries. The function calculates the chemical dissolution, and the 
%mechanical dissolution area and events. It returns a matrix of the rock's
%current state, the amount of chunck events and the mechanical dissolution
%pixels that were dissolved in the current timestep within the bounding box
%~ Probability_Matrix = 100.*rand(size(Previous_Rock_Matrix)); %creating a 
% matrix of random numbers from 1 to 100. The matrix will be used to 
%calculate the chances of each pixel to be dissolved in this time step
%%%Dissolved_Neighbours=zeros(size(Previous_Rock_Matrix)); %initialize the 
% matrix of the number of dissolved neighbours of each pixel 
Limit=1; %limits the actual dissolution to run only within
%pixels that have 8 neighbours within the matrix
%% this loop calculates the matrix dissolved neighbours
%%% 1st Algorithm - Slowest and Heaviest PART!
% for row = (1+Limit):(length(Previous_Rock_Matrix(:,1))-Limit)
%     for col = (1+Limit):(length(Previous_Rock_Matrix(1,:))-Limit)
%       Dissolved_Neighbours(row,col)=sum...
%           ([Previous_Rock_Matrix(row-1,col-1:col+1) ...
%       Previous_Rock_Matrix(row, col-1) Previous_Rock_Matrix(row,col+1)...
%       Previous_Rock_Matrix(row+1,col-1:col+1)]==0); %summing the amount of 
%       %dissolved neighbours each pixel has 
%     end
% end
%% alternative algorithem: MUCH BETTER! 60 sec - > ~1 sec
SolutionIndexes = (Previous_Rock_Matrix == 0);
Dissolved_Neighbours = zeros(size(Previous_Rock_Matrix));
Dissolved_Neighbours(2:end - 1,2:end - 1) =... 
                        SolutionIndexes(1:end - 2,1:end - 2) +...
                        SolutionIndexes(1:end - 2,2:end - 1) +...
                        SolutionIndexes(1:end - 2,3:end) +...
                        SolutionIndexes(2:end - 1,1:end - 2) +...
                        SolutionIndexes(2:end - 1,3:end) +...
                        SolutionIndexes(3:end,1:end - 2) +...
                        SolutionIndexes(3:end,2:end - 1) +...
                        SolutionIndexes(3:end,3:end);
%Dissolved_Neighbours2(Zeros_Mat) = 0;
%% Calculating the current Rock state matrix after chemical dissolution
ExposedIndexes = Dissolved_Neighbours~=0;
Probability_Matrix = zeros(size(ExposedIndexes));
Probability_Matrix(ExposedIndexes) = rand(sum(sum(ExposedIndexes)),1).*100;
Current_Rock_Matrix = Previous_Rock_Matrix.*...
    (Previous_Rock_Matrix.*Dissolved_Neighbours.*0.125<=Probability_Matrix);
%Previous_Rock_Matrix(ExposedIndexes) = Previous_Rock_Matrix(ExposedIndexes).*()
%the current rock is calculated by multiplying each pixel in the previous 
% rock by the odds of each pixel to be dissolved in this current time step
% These odds are calculated by multyplying the pixel's value (that 
% represents it's content) by the normalized amount of dissolved
% neighbours. Then, if this calculation is smaller than the value in the
%Probability_Matrix the pixel is dissolved.
%% This section calculates the phisycal dissolution
Check_Chunck = (Current_Rock_Matrix~=0); %creates a matrix where every 
% dissoleved pixel holds a 0 and any other pixel value is 1   
CC=bwconncomp(Check_Chunck); %calculating the connected components (chunks)
Chunck_Events=[]; %%default if there is no Mechanical dissolution
Mechanical_Dissolution=0; %default if there is no Mechanical dissolution
Mechanical_Dissolution_Matrix=zeros(size(Current_Rock_Matrix));
%creating a new  matrix to insert into it places where mechanical
%dissolution occured
if (CC.NumObjects>1) %there are chunks in the dissolution
 Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
   ,'UniformOutput',false); %calculates the relevant vectors that holds the
   % pixels that should be dissolved during this time step
Mechanical_Dissolution_Matrix([Temp{:}])=1;
%inserting into the dissolution matrix places of mechanical dissolution
In_Bbox_Mechanical_Dissolution=Mechanical_Dissolution_Matrix.*bbox;
%creating a matrix of the rock where only the pixels inside the bounding
%box that were mechanically dissolved recieve the value 1.
Mechanical_Dissolution=sum(sum(In_Bbox_Mechanical_Dissolution));
%summing the total pixel area that were dissolved mechanically
CC_in_Bbox=bwconncomp(In_Bbox_Mechanical_Dissolution);
%calculating connected components (number of chunks) within bbox
%excluding places outside of bboxes and summing total no of chunks 

Chunck_Events = regionprops(CC_in_Bbox,'BoundingBox','MajorAxisLength','MinorAxisLength','Area');

end


Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
,'UniformOutput',false); %calculates the relevant vectors that holds all 
%the pixels that should be dissolved during this time step (including areas
%outside bounding box)
Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
end