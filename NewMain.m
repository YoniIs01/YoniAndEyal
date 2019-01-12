clc, clear, close all;
%% Define Parameters:
IsSmallSize = 1;
ToPlot = 0;
SaveWsAndMovie = 0;
%% Run Model Several Times:
ExcelData = {};
for i=1:3
    Time = clock;
    TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),':',num2str(Time(5)),':',num2str(Time(6)));
    RockType = 4;
    NumGrains = 1100 - 100*i;
    DoloRatio = 0.1*i;
    [Model_Data, Total_Time_Steps,...
    Mechanical_Dissolution_percentage,...
    Chemical_Dissolution_percentage,...
    Mechanical_Dissolution_Events] = RunModel(RockType, NumGrains, DoloRatio, IsSmallSize, ToPlot, SaveWsAndMovie);
    WS_FileName = strcat('ModelData_',strrep(TimeStamp,':',''),'.mat');
    save(WS_FileName,'Model_Data','-v7.3');
    ExcelData = [ExcelData;{TimeStamp,RockType,NumGrains,DoloRatio,Total_Time_Steps,Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events,strcat(pwd,'\',WS_FileName)}];
end;
%% write data to Excel
Time = clock;
TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),'-',num2str(Time(5)));
filename = strcat(TimeStamp,'ModelResults.xlsx');
Titles = {'RunTime','RockType','NumGrains','DoloRatio','StepsCounter',...
        'Mechanical_Dissolution_percentage','Chemical_Dissolution_percentage','Mechanical_Dissolution_Events','WS_FileName'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,[Titles;ExcelData],sheet,xlRange);