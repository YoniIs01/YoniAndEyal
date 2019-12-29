function Data = RunModel( RockType, NumGrains, DoloRatio, Orientation, IsSmallSize)
%RUNMODEL Summary of this function goes here
%   RockType - 1 for voronoi, 2 for table, 3 for brickwall, 4 for
%   Stylolites 5 for hexagonals 6 for cracks
%   IsSmallSize - 1 for small size mode
%   DoloRatio - Case Rock Type is 1, Dolomite to Calcite ratio in the Rock is from 0 (all Calcite) to 1 (all Dolomite).
%   NumGrains - The number of grains in the simulated rock. The larger the number of
%               grains, the smaller the size of grains in the cross section. This 
%               parameter usually varies from 100 to 10000.
    rng('shuffle');
    addpath('./obj/');
    %% ModelData init
    Data = ModelData(RockType, NumGrains, DoloRatio);
    Data.Orientation = Orientation;
    %% Validating rock parameters 
%     if (NumGrains<1||NumGrains>10000||DoloRatio<0||DoloRatio>1)
%      %Checks if the input is valid and breaks in case it is not.  
%        disp('Wrong input parameters. please restart program!'); 
%        return;
%     end 
    %% Initializing Parameters
    %In this section we initialize the cells that will hold the rock's
    %properties in each time step and initiate other variables.
    Previous_Rock_Matrix = []; %will hold the rock's matrix in every timestep.
    %initializing the variables that holds the rock's boundary conditions.
    Width_Threshold=0;  
    Height_Threshold=0;
    %% Building the Rock (Time Step 0)
    % Create_Rock_Image_with_boundaries
    if (RockType == 1)
    [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
        =Create_Rock_Image_with_boundaries(DoloRatio,NumGrains);%creating the initial rock
    % Create_Rock_As_Table
    elseif (RockType == 2)
    [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
          =Create_Rock_As_Table(floor(sqrt(NumGrains)),DoloRatio);
    % Create_Rock_As_Brickwall
    elseif (RockType == 3)
    [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
          =Create_Rock_As_Brickwall(floor(sqrt(NumGrains)),DoloRatio,str2double(Orientation));
    % Create_Rock_As_Stylolites
    elseif (RockType == 4)
        % NumGrains this is only from 1 to 12!
        r = [2 5 6 7.2 8.1 9 9.8 10.8 11.7 13 14 16];
        t = [2 3 6 7.1 8 9.1 10 11 11.9 13 14.6 16];
        if (strcmp(Orientation,'Horizontal'))
            FileName = strcat('r',num2str(r(NumGrains)),'%.tiff');
        else
            FileName = strcat('t',num2str(t(NumGrains)),'%.tiff');
        end
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Stylolites(FileName);
    elseif (RockType == 5)
        % Create_Rock_As_Hex
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Hex(floor(sqrt(NumGrains)),DoloRatio);
    elseif (RockType == 6)
    % Create_Rock_As_Cracks, NumGrains 0 or 1
        if (NumGrains == 1)
            FileName = 'HighDenseCracks.jpg';
        elseif (NumGrains == 0)
            FileName = 'LowDenseCracks.jpg';
        elseif (NumGrains == 2)
            FileName = 'Cracks2.jpg';
        end
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Cracks(FileName);
    elseif (RockType == 7)
        % Create_Rock_As_Simon
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Simon(strcat(num2str(NumGrains),'.png'));
    elseif (RockType == 8)
        % Create_Rock_As_Brickwall_Diff_Ratio
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Brickwall_Diff_Ratio(floor(sqrt(NumGrains)),DoloRatio,0.5);
    elseif (RockType == 9)
        % Create_Rock_As_Hex_Diff_Ratio
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Hex_Diff_Ratio(floor(sqrt(NumGrains)),DoloRatio);
    elseif (RockType == 10)
        % Create_Rock_As_Table_Diff_Ratio
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_As_Table_Diff_Ratio(floor(sqrt(NumGrains)),DoloRatio);
      elseif (RockType == 11)
        % Create_Rock_Image_with_boundaries_DiffRatio
        [Previous_Rock_Matrix,Height_Threshold,Width_Threshold]...
              =Create_Rock_Image_with_boundaries_DiffRatio(DoloRatio,NumGrains);
          
    end
    % For testing
    if (IsSmallSize == 1)
        Previous_Rock_Matrix = Previous_Rock_Matrix(200:600,200:600,:);
    end
    Data.RockFirstImage = Previous_Rock_Matrix;

    %% Initializing Rock dissolution (Time Step 1)
    %copying the rock matrix and than replacing the upper layer with solution 
    Previous_Rock_Matrix(1,:)=0;%the value 0 represents dissolution
    Current_Rock_Matrix = Previous_Rock_Matrix;

    %% Creating frames for dissolution until complete dissolution (step 2:n)
    % In this section we first create a matrix of the bounding area where the
    % Dissolution is not influenced by boundary conditions. Later the
    % dissolution happens inside a while loop for as long as the area in the
    % bounding box has not been completely dissolved.
    % In every timestep the rock's matrix, chunk events and chunk area is being
    % calculated and the rock's image is being converted into frame.
    ii=1; %Time steps
    BBox=[1,length(Current_Rock_Matrix(:,1))-Height_Threshold,...
        Width_Threshold,length(Current_Rock_Matrix(1,:))-Width_Threshold];
    %the min row, max row, min col, max col in which calculation of procceses 
    % is not influenced by boundary conditions
    BboxMatrix=zeros(size(Current_Rock_Matrix));%initializing bbox matrix
    BboxMatrix(BBox(1):BBox(2),BBox(3):BBox(4))=1;%creating the matrix of bbox
    % first step
    CurStep = Step(ii);
    CurStep.Mechanical_Dissolution = 0;
    CurStep.Chemical_Dissolution = sum(sum((Previous_Rock_Matrix==0).*BboxMatrix));
    CurStep.SolutionContactLinearIndex = [];
    Data.Steps(length(Data.Steps) + 1) = CurStep;
    
    while (sum(sum(Previous_Rock_Matrix(BBox(1):BBox(2),BBox(3):BBox(4))~=0))>0)
    % Dissolution will stop when the pixels inside bbox have been disolved
        ii=ii+1; %time steps
        %The function 'Dissolve_Rock' is used here to calculate the rock
        %current matrix, Chunck_Events and Mechanical_Dissolution for each time
        %step.
        [ Current_Rock_Matrix,CurrentChunck_Events,...
        CurrentMechanical_Dissolution, CurrentChemical_Dissolution, CurrentSolutionContactLinearIndex]=...
        Dissolve_Rock(Previous_Rock_Matrix,BboxMatrix);
        Previous_Rock_Matrix = Current_Rock_Matrix;
        %% ModelData Update
        CurStep = Step(ii);
        for i = 1:length(CurrentChunck_Events)
            CurStep.ChunckEvents(length(CurStep.ChunckEvents) + 1) = ChunckEvent(CurrentChunck_Events(i));
        end
        CurStep.Mechanical_Dissolution = CurrentMechanical_Dissolution;
        CurStep.Chemical_Dissolution = CurrentChemical_Dissolution;
        CurStep.SolutionContactLinearIndex = CurrentSolutionContactLinearIndex;
        Data.Steps(length(Data.Steps) + 1) = CurStep;
    end
    Data.EndTime = clock;
end

