NumGrains = [1:10];
figure; hold on;
for NumGrain = NumGrains
    q = strcat('RockType=7;NumGrains=',num2str(NumGrain));
%     models = ModelData.QueryModelDataPath(q);
%     for i = 1:length(models)
        m = ModelData.LoadFromQuery(q,1);
        BW = (im2bw(label2rgb(m.RockFirstImage(1:420-129,109:560-109)),0.12)== 0);
        CC = bwconncomp(BW);
        rp = regionprops(CC,'Perimeter');
        MeanPerimeter = mean([rp.Perimeter]);
        StdPerimeter = std([rp.Perimeter]);
        disp(strcat('Mean: ',num2str(MeanPerimeter), '   Std:', num2str(StdPerimeter),'   Ratio', num2str(StdPerimeter/MeanPerimeter)));
        DominentFrequenciesAndMagnitudes = [];
        modeldatapath = ModelData.QueryModelDataPath(q);
        for FileName = modeldatapath';
            fmd = QueryFMDByFileName(FileName{1});
            DominentFrequenciesAndMagnitudes = [DominentFrequenciesAndMagnitudes;FFTPeakFinder(fmd)];
        end
        if ~isempty(DominentFrequenciesAndMagnitudes)
            plot(DominentFrequenciesAndMagnitudes(:,1),DominentFrequenciesAndMagnitudes(:,2),'*');
        end
%     end
end
xlabel('Period [steps]'); ylabel('Magnitude [Pixels]');
title('Spectral analysis using fft');
legend(cellstr(num2str(NumGrains')));