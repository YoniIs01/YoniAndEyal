clc, clear, close all;
%% Define Parameters:
IsSmallSize = 0;
%% Run Model Several Times:
ExcelData = {};
% DesktopPath = char(getSpecialFolder('Desktop'));
% FolderPath = strcat(DesktopPath,'\Results\');
% mkdir(FolderPath);
FolderPath = 'D:\Program Files\Results Archive\';
%% write data to Excel
Time = clock;
TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),'-',num2str(Time(5)));
filename = strcat(FolderPath,TimeStamp,'ModelResults.xlsx');
Titles = {'RunTime','RockType','NumGrains','DoloRatio','StepsCounter',...
        'Mechanical_Dissolution_percentage','Chemical_Dissolution_percentage','Mechanical_Dissolution_Events','WS_FileName'};
sheet = 1;
col = 'A';
rown = 1;
xlswrite(filename,Titles,sheet,strcat(col,int2str(rown)));
%% Stylolites
DoloRatio = 0;
RockType = 4;
for Orientation = 1:2
    for NumGrains = 1:5
        for i =1:10
            Time = clock;
            Model_Data = RunModel(RockType, NumGrains, DoloRatio, Orientation, IsSmallSize);
            TimeStamp = Model_Data.TimeStamp;
            %% Calculating Data
            Total_Time_Steps = Model_Data.TotalTimeSteps;
            Mechanical_Dissolution = sum([Model_Data.Steps.Mechanical_Dissolution]);
            Chemical_Dissolution = sum([Model_Data.Steps.Chemical_Dissolution]);
            Total_Dissolution = Chemical_Dissolution + Mechanical_Dissolution;
            Mechanical_Dissolution_percentage = Mechanical_Dissolution/Total_Dissolution;
            Chemical_Dissolution_percentage = Chemical_Dissolution/Total_Dissolution;
            Mechanical_Dissolution_Events = length([Model_Data.Steps.ChunckEvents]);
            %% Summary of Model output
            fprintf(strcat('Model results for:\n\t'...
              ,num2str(RockType),' RockType\n\t'...  
              ,num2str(NumGrains),' grains\n\t'...
              ,num2str(DoloRatio),'%% Dolomite\n\t'...
              ,num2str(Total_Time_Steps),' timesteps\n\t'...
              ,num2str(Mechanical_Dissolution_Events),' Chunk Events\n\t'...
              ,num2str(Mechanical_Dissolution_percentage),' Mechanical Dissolution Percentage\n'));
            %% Save Data
            WS_FileName = strcat(FolderPath,Model_Data.FileName);
            save(WS_FileName,'Model_Data','-v7.3');
            rown = rown+1;
            ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,Total_Time_Steps,...
                Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
                WS_FileName};
            xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
        end
    end
end
%% Other
GrainNums = [100 200 400 800 1600 3200];
DoloRatios = [0:0.02:1];
for RockType = 1:3
    for GrainNumIndex = 1:length(GrainNums)
        NumGrains = GrainNums(GrainNumIndex);
        for DoloRatioIndex = 1:length(DoloRatios)
            DoloRatio = DoloRatios(DoloRatioIndex);
            Time = clock;
            Model_Data = RunModel(RockType, NumGrains, DoloRatio, 1, IsSmallSize);
            TimeStamp = Model_Data.TimeStamp;
            %% Calculating Data
            Total_Time_Steps = Model_Data.TotalTimeSteps;
            Mechanical_Dissolution = sum([Model_Data.Steps.Mechanical_Dissolution]);
            Chemical_Dissolution = sum([Model_Data.Steps.Chemical_Dissolution]);
            Total_Dissolution = Chemical_Dissolution + Mechanical_Dissolution;
            Mechanical_Dissolution_percentage = Mechanical_Dissolution/Total_Dissolution;
            Chemical_Dissolution_percentage = Chemical_Dissolution/Total_Dissolution;
            Mechanical_Dissolution_Events = length([Model_Data.Steps.ChunckEvents]);
            %% Summary of Model output
            fprintf(strcat('Model results for:\n\t'...
              ,num2str(RockType),' RockType\n\t'...  
              ,num2str(NumGrains),' grains\n\t'...
              ,num2str(DoloRatio),'%% Dolomite\n\t'...
              ,num2str(Total_Time_Steps),' timesteps\n\t'...
              ,num2str(Mechanical_Dissolution_Events),' Chunk Events\n\t'...
              ,num2str(Mechanical_Dissolution_percentage),' Mechanical Dissolution Percentage\n'));
            %% Save Data
            WS_FileName = strcat(FolderPath,Model_Data.FileName);
            save(WS_FileName,'Model_Data','-v7.3');
            rown = rown+1;
            ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,Total_Time_Steps,...
                Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
                WS_FileName};
            xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
        end
    end
end