%% Plotting Stylos Rate, By Orientation and Denstity
figure;
hold on;
%% Horizontal 
r = [2 5 6 7.2 8.1 9 9.8 10.8 11.7 13 14 16];
% OLD - r = [2.0 2.10 5.0 13.0 14.0 16.0];
% Query Data
data = ModelData.QueryExcel(strcat('RockType=4;Orientation=Horizontal'));
% Rates Columns = 11
% Rates = [data{:,11}];
% GrainNums is index for r array (took from RunModel, line 44).
GrainNums = [data{:,3}];
% Unique GrainNums
UGrainNums = unique(GrainNums);
% Mechanical Dissolution percent
MechanicalDissolutionPercent = [data{:,7}];
% Calculating Standard deviations and Mean of Rates
Densities = [UGrainNums];
Tau_Factors=[UGrainNums];
Stds = [UGrainNums];
MeanRates = [UGrainNums];
MeanMechanicalDissolutionPercent = [UGrainNums];
InitialSproradity = [UGrainNums];
JunctionCounter= [UGrainNums];
ObjectsNumber = [UGrainNums];
for NumGrain = UGrainNums
    Rates = [];
    BoundaryPercent = [];
    for i=1:10
        m = ModelData.LoadFromQuery(strcat('RockType=4;Orientation=Horizontal;NumGrains=',num2str(NumGrain)),i);
        LastStep = m.SolutionOutOfBBoxStepId;
        FirstStep = LastStep-500;
        steps = m.Steps(FirstStep:LastStep);
        Rates(i) = sum([steps.TotalDissolution])/(LastStep - FirstStep);
        BoundaryPercent(i) = sum(m.RockFirstImage(:) == 100)/length(m.RockFirstImage(:));
    end
    Temp_Tau_Factor=TauFactor('InLine',1,1,0,m.RockFirstImageInBB~=100,[1 0 0;0 0 0;0 0 0],[1 1 1]);
    Tau_Factors(NumGrain)=Temp_Tau_Factor.Tau_B1.Tau;
    Densities(NumGrain)=mean(BoundaryPercent);
    Stds(NumGrain) = std(Rates);
    MeanRates(NumGrain) = mean(Rates);
    MeanMechanicalDissolutionPercent(NumGrain) = mean(MechanicalDissolutionPercent(GrainNums == NumGrain));
    BW = (im2bw(label2rgb(m.RockFirstImage),0.12)== 0);
    CC = bwconncomp(BW);
    ObjectsNumber(NumGrain) = CC.NumObjects;
    S = regionprops(CC);
    Centers = cat(1,S.Centroid);
    Center = [560 420]/2;
    MeanCentroid = mean(Centers);
    RStdCentroid = norm(std(Centers));
    Sproradity = RStdCentroid/norm(MeanCentroid - Center);
    JunctionCounter(NumGrain) = sum(sum(bwmorph(bwmorph(m.RockFirstImage~=10,'skel',inf),'branchpoints')));
    InitialSproradity(NumGrain) =Sproradity;
end
%Ploting with Error bars
figure;
plot(Tau_Factors,MeanRates,'o');
figure;
hold on;
plot(r(UGrainNums),100*Densities,'ob');
plot(r(UGrainNums),MeanRates,'or');
plot(r(UGrainNums),MeanMechanicalDissolutionPercent*100,'-r');
plot(r(UGrainNums),100*InitialSproradity/max(InitialSproradity),'--r');
plot(r(UGrainNums),100*ObjectsNumber/max(ObjectsNumber),'-*r');
plot(r(UGrainNums),100*JunctionCounter/max(JunctionCounter),'--*r');
errorbar(r(UGrainNums),MeanRates,Stds,'*r');
% 
% %% Vertical 
% t = [2 3 6 7.1 8 9.1 10 11 11.9 13 14.6 16];
% % OLD - t = [2.0 3.0 6.0 13.0 13.10 16.0];
% % Query Data
% data = ModelData.QueryExcel(strcat('RockType=4;Orientation=Vertical'));
% % Rates Columns = 11
% % Rates = [data{:,11}];
% % GrainNums is index for r array (took from RunModel, line 44).
% GrainNums = [data{:,3}];
% % Unique GrainNums
% UGrainNums = unique(GrainNums);
% % Mechanical Dissolution percent
% MechanicalDissolutionPercent = [data{:,7}];
% % Calculating Standard deviations and Mean of Rates
% Stds = [UGrainNums];
% MeanRates = [UGrainNums];
% MeanRates2 = [UGrainNums];
% MeanRates3 = [UGrainNums];
% MeanRates4 = [UGrainNums];
% MeanMechanicalDissolutionPercent = [UGrainNums];
% JunctionCounter= [UGrainNums];
% InitialSproradity = [UGrainNums];
% StdSizes = [UGrainNums];
% ObjectsNumber = [UGrainNums];
% for NumGrain = UGrainNums
%     Rates = [];
%     Rates2 = [];
%     Rates3 = [];
%     Rates4 = [];
%     for i=1:2
%         m = ModelData.LoadFromQuery(strcat('RockType=4;Orientation=Vertical;NumGrains=',num2str(NumGrain)),i);
%         LastStep = m.SolutionContactStabilizedLastStepId;
%         LastStep2 = m.SolutionOutOfBBoxStepId;
%         FirstStep = m.SolutionContactStabilizedStepId;
%         steps = m.Steps(FirstStep:LastStep);
%         steps2 = m.Steps(LastStep2 - 500:LastStep);
%         steps3 = m.Steps(LastStep - 500:LastStep);
%         Rates(i) = sum([steps.TotalDissolution])/(LastStep - FirstStep);
%         Rates2(i) = sum([steps2.TotalDissolution])/(500);
%         Rates3(i) = sum([steps3.TotalDissolution])/(500);
%         Rates4(i) = m.TotalDissolution/m.TotalTimeSteps;
%     end
%     Stds(NumGrain) = std(Rates);
%     MeanRates(NumGrain) = mean(Rates);
%     MeanRates2(NumGrain) = mean(Rates2);
%     MeanRates3(NumGrain) = mean(Rates3);
%     MeanRates4(NumGrain) = mean(Rates4);
%     MeanMechanicalDissolutionPercent(NumGrain) = mean(MechanicalDissolutionPercent(GrainNums == NumGrain));
%     BW = (im2bw(label2rgb(m.RockFirstImage),0.12)== 0);
%     CC = bwconncomp(BW);
%     ObjectsNumber(NumGrain) = CC.NumObjects;
%     S = regionprops(CC);
%     Centers = cat(1,S.Centroid);
%     Center = [560 420]/2;
%     MeanCentroid = mean(Centers);
%     RStdCentroid = norm(std(Centers));
%     Sproradity = RStdCentroid/norm(MeanCentroid - Center);
%     JunctionCounter(NumGrain) = sum(sum(bwmorph(bwmorph(m.RockFirstImage~=10,'skel',inf),'branchpoints')));
%     Sizes = cellfun(@(x) length(x),CC.PixelIdxList);
%     StdSizes(NumGrain) = std(Sizes);
%     InitialSproradity(NumGrain) =Sproradity;
% end
% %Ploting with Error bars
% plot(t(UGrainNums),MeanRates,'ob');
% plot(t(UGrainNums),MeanRates2,'or');
% plot(t(UGrainNums),MeanRates3,'om');
% plot(t(UGrainNums),MeanRates4,'og');
% plot(t(UGrainNums),MeanMechanicalDissolutionPercent*100,'-b');
% plot(t(UGrainNums),100*InitialSproradity/max(InitialSproradity),'--b');
% plot(t(UGrainNums),100*ObjectsNumber/max(ObjectsNumber),'-*b');
% plot(t(UGrainNums),100*JunctionCounter/max(JunctionCounter),'--*b');
% plot(t(UGrainNums),100*StdSizes/max(StdSizes),'--*b');
% 
% errorbar(t(UGrainNums),MeanRates,Stds,'*b');
% 
% %% Decorating
% title('Stylolites Rate By Stylolites Density')
% xlabel('Stylolites Density [%]')
% ylabel('Rate [Pixel/Step])')
legend({'Horizontal','HorizontalErr','Vertical','VerticalErr'});



% 
