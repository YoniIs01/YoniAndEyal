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
Titles = {'RunTime','RockType','NumGrains','DoloRatio','Orientation','StepsCounter',...
        'Mechanical_Dissolution_percentage','Chemical_Dissolution_percentage','Mechanical_Dissolution_Events','WS_FileName'};
sheet = 1;
col = 'A';
rown = 1;
xlswrite(filename,Titles,sheet,strcat(col,int2str(rown)));
%% Stylolites
% DoloRatio = 0;
% RockType = 4;
% Orientations = ["Horizontal" "Vertical"];
% for O = Orientations
%     for NumGrains = 1:12
%         for i =1:10
%             Time = clock;
%             Model_Data = RunModel(RockType, NumGrains, DoloRatio, O, IsSmallSize);
%             TimeStamp = Model_Data.TimeStamp;
%             %% Calculating Data
%             Total_Time_Steps = Model_Data.TotalTimeSteps;
%             Mechanical_Dissolution = sum([Model_Data.Steps.Mechanical_Dissolution]);
%             Chemical_Dissolution = sum([Model_Data.Steps.Chemical_Dissolution]);
%             Total_Dissolution = Chemical_Dissolution + Mechanical_Dissolution;
%             Mechanical_Dissolution_percentage = Mechanical_Dissolution/Total_Dissolution;
%             Chemical_Dissolution_percentage = Chemical_Dissolution/Total_Dissolution;
%             Mechanical_Dissolution_Events = length([Model_Data.Steps.ChunckEvents]);
%             %% Summary of Model output
%             fprintf(strcat('Model results for:\n\t'...
%               ,num2str(RockType),' RockType\n\t'...  
%               ,num2str(NumGrains),' grains\n\t'...
%               ,num2str(DoloRatio),'%% Dolomite\n\t'...
%               ,num2str(Total_Time_Steps),' timesteps\n\t'...
%               ,num2str(Mechanical_Dissolution_Events),' Chunk Events\n\t'...
%               ,num2str(Mechanical_Dissolution_percentage),' Mechanical Dissolution Percentage\n'));
%             %% Save Data
%             WS_FileName = strcat(FolderPath,Model_Data.FileName);
%             save(WS_FileName,'Model_Data','-v7.3');
%             rown = rown+1;
%             ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,Model_Data.Orientation,Total_Time_Steps,...
%                 Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
%                 WS_FileName};
%             xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
%         end
%     end
% end
%% Cracks
% RockType = 6;
% DoloRatio = 0;
% GrainNums = [0 1];
% for i=1:10
%     for GrainNumIndex = 1:length(GrainNums)
%         NumGrains = GrainNums(GrainNumIndex);
%         Time = clock;
%         Model_Data = RunModel(RockType, NumGrains, DoloRatio, 'None', IsSmallSize);
%         TimeStamp = Model_Data.TimeStamp;
%         %% Calculating Data
%         Total_Time_Steps = Model_Data.TotalTimeSteps;
%         Mechanical_Dissolution = sum([Model_Data.Steps.Mechanical_Dissolution]);
%         Chemical_Dissolution = sum([Model_Data.Steps.Chemical_Dissolution]);
%         Total_Dissolution = Chemical_Dissolution + Mechanical_Dissolution;
%         Mechanical_Dissolution_percentage = Mechanical_Dissolution/Total_Dissolution;
%         Chemical_Dissolution_percentage = Chemical_Dissolution/Total_Dissolution;
%         Mechanical_Dissolution_Events = length([Model_Data.Steps.ChunckEvents]);
%         %% Summary of Model output
%         fprintf(strcat('Model results for:\n\t'...
%           ,num2str(RockType),' RockType\n\t'...  
%           ,num2str(NumGrains),' grains\n\t'...
%           ,num2str(DoloRatio),'%% Dolomite\n\t'...
%           ,num2str(Total_Time_Steps),' timesteps\n\t'...
%           ,num2str(Mechanical_Dissolution_Events),' Chunk Events\n\t'...
%           ,num2str(Mechanical_Dissolution_percentage),' Mechanical Dissolution Percentage\n'));
%         %% Save Data
%         WS_FileName = strcat(FolderPath,Model_Data.FileName);
%         save(WS_FileName,'Model_Data','-v7.3');
%         rown = rown+1;
%         ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,Model_Data.Orientation,Total_Time_Steps,...
%             Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
%             WS_FileName};
%         xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
%     end
% end
%% RockType 3 with hazazot
GrainNums = [100 800 1600];
% DoloRatios = [0:0.02:1];
DoloRatios = [0];
for RockType = 3:3
    for GrainNumIndex = 1:length(GrainNums)
        NumGrains = GrainNums(GrainNumIndex);
        for DoloRatioIndex = 1:length(DoloRatios)
            DoloRatio = DoloRatios(DoloRatioIndex);
            for i = [0:0.1:1]
                Time = clock;
                Model_Data = RunModel(RockType, NumGrains, DoloRatio, num2str(i),IsSmallSize);
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
                ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,num2str(i),Total_Time_Steps,...
                    Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
                    WS_FileName};
                xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
            end
        end
    end
end
%% Other

GrainNums = [100 200 400 800 1600 3200];
DoloRatios = [0:0.02:1];
for RockType = 2:3
    for GrainNumIndex = 1:length(GrainNums)
        NumGrains = GrainNums(GrainNumIndex);
        for DoloRatioIndex = 1:length(DoloRatios)
            DoloRatio = DoloRatios(DoloRatioIndex);
            Time = clock;
            if RockType == 3
                o = '0.5';
            else
                o = 'None';
            end
            Model_Data = RunModel(RockType, NumGrains, DoloRatio, o,IsSmallSize);
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
            ExcelRow = {TimeStamp,RockType,NumGrains,DoloRatio,o,Total_Time_Steps,...
                Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,...
                WS_FileName};
            xlswrite(filename,ExcelRow,sheet,strcat(col,int2str(rown)));
        end
    end
end