

%{
clc,clear,close all;
%% Calculating 0% Dolomite Rocks initial boundaries Amount
% and Comparing Different Formation with Same Ammount

q1 = 'DoloRatio=0';
data = ModelData.QueryExcel(q1);

% % Caclclate initial Boundaries Amount
% BoundaryPercent = [1:size(data,1)];

for i = 1:size(data,1)
     m = ModelData.Load(data{i,10});
     Temp_Tau_Factor=TauFactor('InLine',1,1,0,m.RockFirstImageInBB~=100,[1 1 0;0 0 0;0 0 0],[1 1 1]);
     Tau_Factors_Down(i)=Temp_Tau_Factor.Tau_B1.Tau;
     Tau_Factors_LR(i)=Temp_Tau_Factor.Tau_B2.Tau;
     Densities(i)=100*Temp_Tau_Factor.Tau_B1.VolFrac;
     Surf_Area(i)=Temp_Tau_Factor.Metrics.SurfAreaDens_over_um;
end
% data_updated=[Tau_Factors_Down' Tau_Factors_LR' Surf_Area'];
% data3=[data num2cell(data_updated)];
%counting Boundary percent, with respect to 100 as calcite-calcite
%     Boundary, and the only boundary
%     BoundaryPercent(i) = sum(Model_Data.RockFirstImage(:) == 100)/length(Model_Data.RockFirstImage(:));
% end
%BoundaryPercent=[0.0721130952380952,0.102087585034014,0.146730442176871,0.206577380952381,0.287623299319728,0.395140306122449,0.0721130952380952,0.0721130952380952,0.0721130952380952,0.0721130952380952,0.0721130952380952,0.102087585034014,0.102087585034014,0.102087585034014,0.102087585034014,0.102087585034014,0.146730442176871,0.146730442176871,0.146730442176871,0.146730442176871,0.146730442176871,0.206577380952381,0.206577380952381,0.206577380952381,0.206577380952381,0.206577380952381,0.287623299319728,0.287623299319728,0.287623299319728,0.287623299319728,0.287623299319728,0.395140306122449,0.395140306122449,0.395140306122449,0.395140306122449,0.395140306122449,0.0816326530612245,0.113333333333333,0.159863945578231,0.220000000000000,0.265306122448980,0.360000000000000,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.113333333333333,0.113333333333333,0.113333333333333,0.113333333333333,0.113333333333333,0.159863945578231,0.159863945578231,0.159863945578231,0.159863945578231,0.159863945578231,0.220000000000000,0.220000000000000,0.220000000000000,0.220000000000000,0.220000000000000,0.298701298701299,0.298701298701299,0.298701298701299,0.298701298701299,0.298701298701299,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.0816326530612245,0.113333333333333,0.113333333333333,0.113333333333333,0.113333333333333,0.113333333333333,0.159863945578231,0.159863945578231,0.159863945578231,0.159863945578231,0.159863945578231,0.220000000000000,0.220000000000000,0.220000000000000,0.220000000000000,0.220000000000000,0.220000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.298701298701299,0.298701298701299,0.298701298701299,0.298701298701299,0.298701298701299,0.298701298701299,0.0199957482993197,0.0199957482993197,0.0199957482993197,0.0199957482993197,0.0199957482993197,0.0199957482993197,0.0199957482993197,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0540603741496599,0.0570578231292517,0.0199957482993197,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0570578231292517,0.0672831632653061,0.0672831632653061,0.0672831632653061,0.0672831632653061,0.0672831632653061,0.0672831632653061,0.0199957482993197,0.0199957482993197,0.0672831632653061,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.0672831632653061,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0829719387755102,0.0672831632653061,0.0829719387755102,0.0829719387755102,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0895365646258503,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.0672831632653061,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.0980144557823129,0.105429421768707,0.105429421768707,0.0753571428571429,0.0753571428571429,0.0753571428571429,0.105429421768707,0.125867346938776,0.125867346938776,0.125867346938776,0.125867346938776,0.125867346938776,0.125867346938776,0.125867346938776,0.125867346938776,0.105429421768707,0.125867346938776,0.125867346938776,0.136926020408163,0.136926020408163,0.136926020408163,0.136926020408163,0.136926020408163,0.136926020408163,0.136926020408163,0.105429421768707,0.136926020408163,0.136926020408163,0.136926020408163,0.162470238095238,0.162470238095238,0.162470238095238,0.162470238095238,0.162470238095238,0.162470238095238,0.105429421768707,0.162470238095238,0.162470238095238,0.162470238095238,0.162470238095238,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.0221386054421769,0.105429421768707,0.105429421768707,0.105429421768707,0.105429421768707,0.0260246598639456,0.0260246598639456,0.0260246598639456,0.0260246598639456,0.0260246598639456,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0260246598639456,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0599957482993197,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0664328231292517,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0260246598639456,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0742687074829932,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0837457482993197,0.0910629251700680,0.0910629251700680,0.0910629251700680,0.0910629251700680,0.0910629251700680,0.0910629251700680,0.0910629251700680,0.0260246598639456,0.0260246598639456,0.0260246598639456,0.0910629251700680,0.0910629251700680,0.0996386054421769,0.0996386054421769,0.0996386054421769,0.107036564625850,0.107036564625850,0.107036564625850,0.107036564625850,0.107036564625850,0.107036564625850,0.107036564625850,0.0910629251700680,0.107036564625850,0.107036564625850,0.107036564625850,0.126364795918367,0.126364795918367,0.126364795918367,0.126364795918367,0.126364795918367,0.126364795918367,0.126364795918367,0.126364795918367,0.0996386054421769,0.126364795918367,0.126364795918367,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.127729591836735,0.0996386054421769,0.127729591836735,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.161581632653061,0.0996386054421769,0.0996386054421769,0.0996386054421769,0.0996386054421769,0.0996386054421769,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.263843537414966,0.355497448979592,0.0741284013605442,0.139923469387755,0.0990646258503401,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.0990646258503401,0.263843537414966,0.190599489795918,0.355497448979592,0.139923469387755,0.190599489795918,0.263843537414966,0.355497448979592,0.0741284013605442,0.0990646258503401,0.139923469387755,0.190599489795918,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.0577168367346939,0.185505952380952,0.282402210884354,0.282402210884354,0.282402210884354,0.282402210884354,0.282402210884354,0.282402210884354,0.0992261904761905,0.0964923469387755,0.0939923469387755,0.0980484693877551,0.102648809523810,0.104829931972789,0.108443877551020,0.108847789115646,0.109574829931973,0.241250000000000,0.0992261904761905,0.0964923469387755,0.0939923469387755,0.0980484693877551,0.102648809523810,0.104829931972789,0.108443877551020,0.108847789115646,0.109574829931973,0.241250000000000,0.0992261904761905,0.0939923469387755,0.0964923469387755,0.0980484693877551,0.102648809523810,0.104829931972789,0.108443877551020,0.108847789115646,0.109574829931973,0.241250000000000,0.0992261904761905,0.0964923469387755,0.0939923469387755,0.0980484693877551,0.102648809523810,0.104829931972789,0.108443877551020,0.104829931972789,0.108847789115646,0.109574829931973,0.241250000000000,0.0992261904761905,0.0939923469387755,0.0964923469387755,0.0980484693877551,0.102648809523810,0.104829931972789,0.108443877551020,0.108443877551020,0.108847789115646,0.109574829931973,0.241250000000000,0.108847789115646,0.109574829931973,0.241250000000000,0.0992261904761905,0.0964923469387755,0.0939923469387755,0.0980484693877551,0.102648809523810];
%plot([1:length(BoundaryPercent)],BoundaryPercent,'o');
%% Selecting Data
% 
% for i=1:length(data3)
%     if (data3{i,3}==100 & data3{i,5}<1) 
%         SelectedData{i,:}=[data3{i,:}];
%     end 
% end
%MinRatio = 0.00001;
%MaxRatio = 1;
%}


SelectedData = data;%(find((BoundaryPercent>MinRatio ) .* (BoundaryPercent<=MaxRatio)),:);
%NumGrains=[SelectedData{:,3}]';
%SelectedData = SelectedData(find(NumGrains==100),:);
%SelectedData = table2cell(SelectedData);
%% yoni's fix
%SelectedData = data;
%%
Rates = (99813./[SelectedData{:,6}])';
%TauFac_Down = [SelectedData{:,13}]';
%TauFac_LR = [SelectedData{:,12}]';
%Surface = [SelectedData{:,13}]';

% Rates Column = 11
%Rates = [SelectedData{:,11}];
% RockTypes Column = 1
for i=1:length(SelectedData)
    if strcmp(SelectedData{i,13},'Inf')
        SelectedData{i,13}=100;
    end
    TauFac_Down(i,1) = SelectedData{i,13};
    if strcmp(SelectedData{i,5},'Vertical')
        SelectedData{i,2}=8;
    end 
end
RockTypes = [SelectedData{:,2}];
% Unique GrainNums
URockTypes = unique(RockTypes);

% Calculating Standard deviations and Mean of Rates
Stds = [URockTypes];
MeanRates = [URockTypes];
TauFac_DownS = [URockTypes];
TauFac_LRS = [URockTypes];
Surfaces = [URockTypes];
Densities_S = [URockTypes];
for RockTypeIndex = 1:length(URockTypes)
    RockType = URockTypes(RockTypeIndex);
    Stds(RockTypeIndex) = std(Rates(RockTypes == RockType));
    MeanRates(RockTypeIndex) = mean(Rates(RockTypes == RockType));
    TauFac_DownS(RockTypeIndex) = mean(Tau_Factors_Down(RockTypes == RockType));
    TauFac_LRS(RockTypeIndex) = mean(Tau_Factors_LR(RockTypes == RockType));
    Densities_S(RockTypeIndex)= mean(Densities(RockTypes == RockType));
    Surfaces(RockTypeIndex) = mean(Surf_Area(RockTypes == RockType));
end
%Ploting with Error bars
%close all;
figure;
hold on;
yyaxis left
Patterns=[{ 'Voronoi', 'Grid', 'Brick-wall','Stylolites (Perp.)', 'Honeycomb','Cracks (Diag.)', 'Cracks (Ortho.)','Stylolites (Para.)'}];
[S_MeanRates I]=sort(MeanRates,'descend');
%[MeanRates I]=sort(TauFac_DownS,'descend');

URockTypes=URockTypes(I);
sortedPatterns=Patterns(URockTypes);
S_TauFac_DownS = TauFac_DownS(I);
S_TauFac_LRS = TauFac_LRS(I);
S_Densities_S = Densities_S(I);
S_Surfaces = Surfaces(I);
%errorbar(MeanRates,0.5);

plot(1:length(URockTypes),S_Surfaces,'ob');

errorbar(S_MeanRates,Stds(I),'.k','MarkerSize',14);
hold on;
xticks([1:length(URockTypes)+1]);
%ylim ([40,110]);
xlim([0.5 length(URockTypes)+1]);
%xticklabels({ 'Grid', 'Honeycomb', 'Voronoi', 'Cracks (Ortho.)' ,'Stylolites (Perp.)', 'Brick-wall','Cracks (Diag.)'  ,'Stylolites (Para.)'});
xticklabels(sortedPatterns);


ylabel('rate [pixles/time step]','fontsize',20);
set (gca, 'fontsize',20,'box','on');

yyaxis right
hold on;

 
plot(1:length(URockTypes),S_TauFac_DownS,'*r');
plot(1:length(URockTypes),S_TauFac_LRS,'sg');

%plot(1:length(URockTypes),S_Densities_S,'ok');
%scatter(1:length(URockTypes),S_TauFac_DownS,'*r')
%scatter([1:1:8],S_TauFac_LRS,'*k')
%scatter([1:1:8],S_Surfaces,'or')
legend({'Surface Area','Rate','\tau factor perp.','\tau factor ortho.'});
x1=(1:length(URockTypes))';
ylabels=({'Rate','Surface Area','\tau factor'});

[ax,hlines] = multiplotyyy({x1,[S_MeanRates]},{x1,S_Surfaces},{x1,[S_TauFac_DownS;S_TauFac_LRS]},ylabels);

%disp(GOOD_order);
% disp('Voronoi=1, Table=2, Brickwall=3, Stylolites4,Hex5,Cracks6,Simon7,Vertical8');
figure;

for i=1:length(URockTypes)
    scatter(Tau_Factors_Down(RockTypes==i),Rates(RockTypes==i),50,'filled');
    hold on;
end
xlabel('Turtuosity Factor','HorizontalAlignment','center');
ylabel('Rate [Pixels/Step]','HorizontalAlignment','center','Color','k','FontSize',20);
%ylim([min(min([Y(:,1) Y(:,2) Y(:,3)]))-5,max(max([Y(:,1) Y(:,2) Y(:,3)]))+5]);
%xlim([min(min([Tau(:,1) Tau(:,2) Tau(:,3)]))-0.1,max(max([Tau(:,1) Tau(:,2) Tau(:,3)]))+0.1]);
set(gca,'FontSize',20,'box','on');
h=legend(Patterns);

    
%% Tau Factors up-down
A2=[SelectedData{:,2}];
A3=[SelectedData{:,3}];
[G,ID1,ID2] = findgroups(A2,A3);

URockTypes = unique(G);

% Calculating Standard deviations and Mean of Rates
Stds = [URockTypes];
MeanRates = [URockTypes];
TauFac_DownS = [URockTypes];
TauFac_LRS = [URockTypes];
Surfaces = [URockTypes];
Densities_S = [URockTypes];
for RockTypeIndex = 1:length(URockTypes)
    RockType = URockTypes(RockTypeIndex);
    Stds(RockTypeIndex) = std(Rates(G == RockType));
    MeanRates(RockTypeIndex) = mean(Rates(G == RockType));
    TauFac_DownS(RockTypeIndex) = mean(Tau_Factors_Down(G == RockType));
    TauFac_LRS(RockTypeIndex) = mean(Tau_Factors_LR(G == RockType));
    Densities_S(RockTypeIndex)= mean(Densities(G == RockType));
    Surfaces(RockTypeIndex) = mean(Surf_Area(G == RockType));
end

figure;
CM = colormap(lines);
LocationNums = [1,7,13,23,29,38,40,50];
for i=1:length(LocationNums+1)
    errorbar(TauFac_DownS(LocationNums(i)),MeanRates(LocationNums(i)),Stds(LocationNums(i)),...
    'o','color',CM(i,:),'MarkerSize',6,'MarkerFaceColor',CM(i,:));
    hold on;
end

for i=1:length(URockTypes)
    for j=1:length(unique(URockTypes))
       if (ID1(i)==j) 
            errorbar(TauFac_DownS(URockTypes==i),MeanRates(URockTypes==i),Stds(URockTypes==i),...
                    'o','color',CM(j,:),'MarkerSize',6,'MarkerFaceColor',CM(j,:));
            hold on;
       end
    end
end

xlabel('Turtuosity Factor','HorizontalAlignment','center');
ylabel('Rate [Pixels/Step]','HorizontalAlignment','center','Color','k','FontSize',20);
%ylim([min(min([Y(:,1) Y(:,2) Y(:,3)]))-5,max(max([Y(:,1) Y(:,2) Y(:,3)]))+5]);
%xlim([min(min([Tau(:,1) Tau(:,2) Tau(:,3)]))-0.1,max(max([Tau(:,1) Tau(:,2) Tau(:,3)]))+0.1]);
set(gca,'FontSize',20,'box','on');
legend(Patterns)


%%
figure;
CM = colormap(lines);
LocationNums = [1,7,13,23,29,38,40,50];
for i=1:length(LocationNums+1)
    errorbar(Densities_S(LocationNums(i)),MeanRates(LocationNums(i)),Stds(LocationNums(i)),...
    'o','color',CM(i,:),'MarkerSize',6,'MarkerFaceColor',CM(i,:));
    hold on;
end

for i=1:length(URockTypes)
    for j=1:length(unique(URockTypes))
       if (ID1(i)==j) 
            errorbar(Densities_S(URockTypes==i),MeanRates(URockTypes==i),Stds(URockTypes==i),...
                    'o','color',CM(j,:),'MarkerSize',6,'MarkerFaceColor',CM(j,:));
            hold on;
       end
    end
end

xlabel('% Discontinuity','HorizontalAlignment','center');
ylabel('Rate [Pixels/Step]','HorizontalAlignment','center','Color','k','FontSize',20);
%ylim([min(min([Y(:,1) Y(:,2) Y(:,3)]))-5,max(max([Y(:,1) Y(:,2) Y(:,3)]))+5]);
%xlim([min(min([Tau(:,1) Tau(:,2) Tau(:,3)]))-0.1,max(max([Tau(:,1) Tau(:,2) Tau(:,3)]))+0.1]);
set(gca,'FontSize',20,'box','on');
xtickformat('percentage');
legend(Patterns)

%% TauFac_LRS
figure;
CM = colormap(lines);
LocationNums = [1,7,13,23,29,38,40,50];
for i=1:length(LocationNums+1)
    errorbar(TauFac_LRS(LocationNums(i)),MeanRates(LocationNums(i)),Stds(LocationNums(i)),...
    'o','color',CM(i,:),'MarkerSize',6,'MarkerFaceColor',CM(i,:));
    hold on;
end

for i=1:length(URockTypes)
    for j=1:length(unique(URockTypes))
       if (ID1(i)==j) 
            errorbar(TauFac_LRS(URockTypes==i),MeanRates(URockTypes==i),Stds(URockTypes==i),...
                    'o','color',CM(j,:),'MarkerSize',6,'MarkerFaceColor',CM(j,:));
            hold on;
       end
    end
end

xlabel('Left-right Turtuosity','HorizontalAlignment','center');
ylabel('Rate [Pixels/Step]','HorizontalAlignment','center','Color','k','FontSize',20);
%ylim([min(min([Y(:,1) Y(:,2) Y(:,3)]))-5,max(max([Y(:,1) Y(:,2) Y(:,3)]))+5]);
%xlim([min(min([Tau(:,1) Tau(:,2) Tau(:,3)]))-0.1,max(max([Tau(:,1) Tau(:,2) Tau(:,3)]))+0.1]);
%xlim([1 5])
set(gca,'FontSize',20,'box','on');
legend(Patterns)

%% Stylolites
figure;
j=8;
for i=1:length(URockTypes)
    if (ID1(i)==j) 
            errorbar(TauFac_LRS(URockTypes==i),MeanRates(URockTypes==i),Stds(URockTypes==i),...
                    'o','MarkerSize',6,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],'Color',[0 0 0],'DisplayName','Parallel Stylolites');
            hold on;
    end
end
j=4;
for i=1:length(URockTypes)
    if (ID1(i)==j) 
            errorbar(TauFac_LRS(URockTypes==i),MeanRates(URockTypes==i),Stds(URockTypes==i),...
                    'o','MarkerSize',6,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],'Color',[0 0 1],'DisplayName','Perpendicular Stylolites');
    end
end
% Create ylabel
ylabel('Rate [Pixels/#Steps]','FontSize',18);

% Create xlabel
xlabel('Tau factor down','FontSize',18);


% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 17]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[20 100]);
set(gca,'FontSize',20,'box','on');
% Create legend
