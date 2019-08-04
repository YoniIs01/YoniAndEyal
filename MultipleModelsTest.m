a={};
% a{1} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_144732.037.mat';
% a{2} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_144847.39.mat';
% a{3} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_14502.165.mat';
% a{4} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145114.257.mat';
% a{5} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145227.372.mat';
% a{6} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145343.841.mat';
% a{7} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_14550.284.mat';
% a{8} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145612.666.mat';
% a{9} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145729.118.mat';
% a{10} = 'D:\Program Files\Results Archive\complete run 2\ModelData_2019-6-3_145845.107.mat';

a{1} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_183415.468.mat';
a{2} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_183911.465.mat';
a{3} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_18445.336.mat';
a{4} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_18493.738.mat';
a{5} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_18543.415.mat';
a{6} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_18595.273.mat';
a{7} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_19414.275.mat';
a{8} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_19930.553.mat';
a{9} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_191451.909.mat';
a{10} = 'D:\Program Files\Results Archive\ModelData_2019-6-3_19208.8.mat';
ModulesNumber =  length(a);
BinSize = 30;
ProbalityPerBin = [];
for i =1:ModulesNumber
    load(a{i});
    M = Model_Data;
    e = [M.Steps.ChunckEvents];
    figure;
    histobj = histogram([e.Area],'BinWidth',BinSize,'Normalization','probability');
    
    ProbalityPerStep = [];
    for j = 1:histobj.NumBins
        p = histobj.Values(j);
        if length(ProbalityPerBin) < j
            ProbalityPerBin(j) = 0;
        end
        ProbalityPerBin(j) = ProbalityPerBin(j) + p;
        ProbalityPerStep(j) = p;
    end
    close gcf;
end

MeanProbalityPerBin = ProbalityPerBin/ModulesNumber;
MinRepeats = [];
for j = 1:length(ProbalityPerBin)
    NRepeat = 1;
    Success = geocdf(NRepeat,MeanProbalityPerBin(j));
    while Success<0.7
        NRepeat = NRepeat + 1;
        Success = geocdf(NRepeat,MeanProbalityPerBin(j));
    end
    MinRepeats(j) = NRepeat;
end

XBarValues = (1:length(MeanProbalityPerBin))*BinSize - BinSize/2;
yyaxis left
bar(XBarValues(2:end),MeanProbalityPerBin(2:end),1,'FaceColor','w','EdgeColor',[0 .5 .5],'LineWidth',1.5);
binranges = round(linspace(min(XBarValues(2:end)), max(XBarValues(2:end)),length(XBarValues)));
set(gca,'XTick',binranges)
set(gca,'fontsize',18,'ycolor',[0 .5 .5]);
xlabel('Detachment size [Pixels]','fontsize',18);
ylabel('Detachment Probality','fontsize',18);
yyaxis right
bar(XBarValues(2:end),MinRepeats(2:end),1,'FaceColor','w','EdgeColor',[.5 .5 .5],'LineWidth',1.5);
ylabel('#Steps to detachment','fontsize',18);

