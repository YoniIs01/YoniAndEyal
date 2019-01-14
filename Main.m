clc, clear, close all;
%% Define Parameters:
IsSmallSize = 1;
ToPlot = 0;
%% Run Model Several Times:
ExcelData = {};
DesktopPath = char(getSpecialFolder('Desktop'));
FolderPath = strcat(DesktopPath,'\Results\');
mkdir(FolderPath);
for i=1:3
    Time = clock;
    TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),':',num2str(Time(5)),':',num2str(Time(6)));
    RockType = 4;
    NumGrains = 1100 - 100*i;
    DoloRatio = 0.1*i;
    Model_Data = RunModel(RockType, NumGrains, DoloRatio, IsSmallSize);
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
      ,num2str(NumGrains),' grains\n\t'...
      ,num2str(DoloRatio),'%% Dolomite\n\t'...
      ,num2str(Total_Time_Steps),' timesteps\n\t'...
      ,num2str(Mechanical_Dissolution_Events),' Chunk Events\n\t'...
      ,num2str(Mechanical_Dissolution_percentage),' Mechanical Dissolution Percentage\n'));
    %% Save Data
    WS_FileName = strcat(FolderPath,'ModelData_',strrep(TimeStamp,':',''),'.mat');
    save(WS_FileName,'Model_Data','-v7.3');
    ExcelData = [ExcelData;{TimeStamp,RockType,NumGrains,DoloRatio,Total_Time_Steps,Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,strcat(pwd,'\',WS_FileName)}];
end;
%% write data to Excel
Time = clock;
TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),'-',num2str(Time(5)));
filename = strcat(FolderPath,TimeStamp,'ModelResults.xlsx');
Titles = {'RunTime','RockType','NumGrains','DoloRatio','StepsCounter',...
        'Mechanical_Dissolution_percentage','Chemical_Dissolution_percentage','Mechanical_Dissolution_Events','WS_FileName'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,[Titles;ExcelData],sheet,xlRange);