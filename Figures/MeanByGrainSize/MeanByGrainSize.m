RockType = 11;

%figure; hold on;
InitialMeanGrainSize = [];
YMatrix1 = [];
for alpha = [50 20 10 5 3]
    data = GetMeanGrainSize(RockType,alpha);
    for NumGrain = data.NumGrains'
        if (alpha == 50)
            m = ModelData.LoadFromQuery(strcat('RockType=',num2str(RockType),';DoloRatio=',num2str(alpha),';NumGrains=',num2str(NumGrain)),1);
            x = m.OriginalRockGrainAreas;
            x = x(x>10);
            InitialMeanGrainSize = [InitialMeanGrainSize mean(x.^2)/mean(x)];
        end
    end
    if (alpha == 50)
        YMatrix1 = [YMatrix1 InitialMeanGrainSize'];
    end
    YMatrix1 = [YMatrix1 data.WeightedMean];
end

createfigure6_colors2(InitialMeanGrainSize, YMatrix1);
createfigure7(flip(YMatrix1)')

imagesc(sorted)
nLvl = 36;
% get min and max values of Data
minData = min(min(YMatrix1));
maxData = max(max(YMatrix1));
% define colorbar values on log scale
c = logspace(minData,maxData,nLvl);

caxis(log([c(1) c(end)]));

colorbar('YTick',(c),'YTickLabel',c);

