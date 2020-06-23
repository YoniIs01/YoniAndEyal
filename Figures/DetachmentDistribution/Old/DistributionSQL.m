DoloRatio = '0';
binSizes = [120 90 60 40 20 10]; 
Grains = [100 200 400 800 1600 3200];
figure; hold on;
for RockTypes = [5] % 1 2 3 5
    i = 0;
    RockType = num2str(RockTypes);
    for NumOfGrains = Grains
        NumGrains = num2str(NumOfGrains);
        i = i + 1;
%         if (i ~= 4)
%             continue;
%         end
        binSize = binSizes(i);
        %% Execute query and fetch results
        conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/rockmodeling?useSSL=false&');
        data = fetch(conn,['select ce.Area ' ...
            'from ChunkEvents ce ' ...
            'join models m ' ...
            'on ce.modelid = m._id ' ...
            'where rocktype = ' RockType ' ' ...
            '	and m.DoloPercent - ' DoloRatio '  between 0 and 0.0001 '  ...
            '   and m.NumGrains = ' NumGrains '  '...
            '   and ce.Area > 10 ' ]);
        close(conn)
        clear conn
        %% Detachement Distribution
        DetachedGrainAreas = data.Area;
        ReweightedDetachedData = [];
        for ga = DetachedGrainAreas'
            ReweightedDetachedData = [ReweightedDetachedData ga*ones(1,ga)];
        end

        if (1==0) % DistByCounterAndMass
            GrainAreaCounter = [1:length(DetachedGrainAreas)]';
            parfor i = 1:length(DetachedGrainAreas)
                GrainAreaCounter(i) = sum(DetachedGrainAreas == DetachedGrainAreas(i));
            end
            GrainAreasCounter = sortrows(unique([DetachedGrainAreas GrainAreaCounter],'rows'));
            GrainAreas = GrainAreasCounter(:,1);
            GrainAreasCounter = GrainAreasCounter(:,2);
            GrainSizeMass = GrainAreas.*GrainAreasCounter;
            figure; scatter(GrainAreas,GrainAreasCounter);
            figure; scatter(GrainAreas,GrainSizeMass/sum(GrainSizeMass));
        end
        subplot(3,1,1); hold on;
        MeanDetached = mean(ReweightedDetachedData);
        nbins = round(max(ReweightedDetachedData)/binSize);
    %     histogram(ReweightedDetachedData,nbins,'DisplayStyle','bar','LineWidth',1);
        histogram(ReweightedDetachedData,nbins,'DisplayStyle','stairs','LineWidth',3);
        %% Original Fragment Distribution
        m = ModelData.LoadFromQuery(strcat('RockType=',RockType,';NumGrains=',NumGrains,';DoloRatio=',DoloRatio),1);%,';Orientation=Vertical'
        OriginalGrainAreas = m.OriginalRockGrainAreas;
        ReweightedGrainAreas = [];
        for ga = OriginalGrainAreas
            ReweightedGrainAreas = [ReweightedGrainAreas ga*ones(1,ga)];
        end
        subplot(3,1,2); hold on;
        MeanOriginal = mean(ReweightedGrainAreas);
        nbins = round(max(ReweightedGrainAreas)/(binSize*2));
    %     histogram(ReweightedGrainAreas,nbins,'DisplayStyle','bar','LineWidth',1);
        histogram(ReweightedGrainAreas,nbins,'DisplayStyle','stairs','LineWidth',3);
        %%
        subplot(3,1,3); hold on;
        nbins = round(max(ReweightedGrainAreas)/(binSize*2));
        histogram(ReweightedDetachedData,nbins,'DisplayStyle','bar','LineWidth',3);
        histogram(ReweightedGrainAreas,nbins*2,'DisplayStyle','bar','LineWidth',3);
        disp(log(1-MeanDetached/MeanOriginal)/-9);
    end
end
subplot(3,1,1); hold on;
title('Detachment Distribution');
legend(num2str(Grains'));
subplot(3,1,2); hold on;
title('Original Fragment Distribution');
legend(num2str(Grains'));
hold off;