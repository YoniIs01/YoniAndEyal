data = GetMeanByOffset();
NumGrains = unique(data.NumGrains);

Y = [];
Errors = [];
for i = 1:length(unique(data.NumGrains))
    NumGrain = NumGrains(i);
    Indexes = data.NumGrains == NumGrain;
    Y = [Y data.weighted_mean(Indexes)];
    Errors = [Errors data.weighted_mean_err(Indexes)];
    
end

%X1 = cellfun(@str2num,data.Orientation(Indexes))*100;
%createfigure3(X1,Y(:,1),Y(:,2),Y(:,3),Errorsors(:,1),Errorsors(:,2),Errorsors(:,3))
createfigure4_3_GS(Y(:,1),Y(:,2),Y(:,3),Errors(:,1),Errors(:,2),Errors(:,3),Tau(:,1),Tau(:,2),Tau(:,3))
figure;
hold on;
errorbar(Tau(:,1),Y(:,1),Errors(:,1),'o','MarkerSize',5,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],'Color',[0 0 0],'DisplayName','\mu_0=2160');

errorbar(Tau(:,2),Y(:,2),Errors(:,2),'o','MarkerSize',5,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],'Color',[0 0 1],'DisplayName','\mu_0=234');
errorbar(Tau(:,3),Y(:,3),Errors(:,3),'o','MarkerSize',5,'MarkerSize',5,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],'Color',[1 0 0],'DisplayName','\mu_0=108');
xlabel('Turtuosity Factor','HorizontalAlignment','center');
ylabel('Mean Detachment Size [Pixels]','HorizontalAlignment','center','Color','k','FontSize',20);
ylim([min(min([Y(:,1) Y(:,2) Y(:,3)]))-10,max(max([Y(:,1) Y(:,2) Y(:,3)]))+10]);
xlim([min(min([Tau(:,1) Tau(:,2) Tau(:,3)]))-0.1,max(max([Tau(:,1) Tau(:,2) Tau(:,3)]))+0.1]);
legend('Orientation','horizontal','Location','northeast','Box', 'off');
set(gca,'FontSize',20,'box','on');