clc, clear, close all;
%% Define Parameters:
IsSmallSize = 0;
ToPlot = 1;
SaveWsAndMovie = 0;
%% Run Model Several Times:
Data = {};
for i=1:10
    Time = clock;
    TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),':',num2str(Time(5)),':',num2str(Time(6)));
    RockType = 1;
    NumGrains = 1100 - 100*i;
    DoloRatio = 0.1*i;
    [Total_Time_Steps,...
    Mechanical_Dissolution_percentage,...
    Chemical_Dissolution_percentage,...
    Mechanical_Dissolution_Events] = RunModel(RockType, NumGrains, DoloRatio, IsSmallSize, ToPlot, SaveWsAndMovie);
    Data = [Data;{TimeStamp,RockType,NumGrains,DoloRatio,Total_Time_Steps,Mechanical_Dissolution_percentage,Chemical_Dissolution_percentage,Mechanical_Dissolution_Events}];
end;
%% write data to Excel
Time = clock;
TimeStamp = strcat(num2str(Time(1)),'-',num2str(Time(2)),'-',num2str(Time(3)),'_',num2str(Time(4)),'-',num2str(Time(5)));
filename = strcat(TimeStamp,'ModelResults.xlsx');
Titles = {'RunTime','RockType','NumGrains','DoloRatio','StepsCounter',...
        'Mechanical_Dissolution_percentage','Chemical_Dissolution_percentage','Mechanical_Dissolution_Events'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,[Titles;Data],sheet,xlRange);