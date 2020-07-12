function createfigure4_3(Y1, Y2, Y3, E1, E2, E3,T1,T2,T3)
% Create figure
figure1 = figure('Color',[1 1 1]);

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
hold(subplot1,'on');

%scatter(X1,Y1,'Parent',subplot1,'MarkerFaceColor',[0, 0, 0.75],...
 %   'MarkerEdgeColor',[0, 0, 0.75]);
errorbar(T1,Y1,E1,'o','MarkerSize',8,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],'Color',[0 0 0],'DisplayName','\mu_0=2160');
set(subplot1,'FontSize',20,'Ycolor','k');
ylim([min(min([Y1 Y2 Y3]))-5,max(max([Y1 Y2 Y3]))+5]);
xlim([min(min([T1 T2 T3]))-0.1,max(max([T1 T2 T3]))+0.1]);
legend('Orientation','horizontal','Location','northeast','Box', 'off','AutoUpdate','off');
box(subplot1,'on');

% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure1);
hold(subplot2,'on');
errorbar(T2,Y2,E2,'o','MarkerSize',8,'MarkerFaceColor',[0, 0, 0.75],...
    'MarkerEdgeColor',[0, 0, 0.75],'Color',[0, 0, 0.75],'DisplayName','\mu_0=234');
% Create ylabel
legend('Orientation','horizontal','Location','northeast','Box', 'off','AutoUpdate','off');
set(subplot2,'FontSize',20,'Ycolor','b');
ylabel('Rate [Pixels/Step]','HorizontalAlignment','center','Color','k','FontSize',20);
ylim([min(min([Y1 Y2 Y3]))-5,max(max([Y1 Y2 Y3]))+5]);
xlim([min(min([T1 T2 T3]))-0.1,max(max([T1 T2 T3]))+0.1]);
box(subplot2,'on');

% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure1);
hold(subplot3,'on');
% Create scatter
errorbar(T3,Y3,E3,'o','MarkerSize',8,'MarkerFaceColor',[.75, 0, 0],...
    'MarkerEdgeColor',[.75, 0, 0],'Color',[.75, 0, 0],'DisplayName','\mu_0=108');
% Create xlabel
legend('Orientation','horizontal','Location','northeast','Box', 'off');
set(subplot3,'FontSize',20,'Ycolor','r');
ylim([min(min([Y1 Y2 Y3]))-5,max(max([Y1 Y2 Y3]))+5]);
xlim([min(min([T1 T2 T3]))-0.1,max(max([T1 T2 T3]))+0.1]);
xlabel('Tortuosity Factor','HorizontalAlignment','center');
box(subplot3,'on');
% Set the remaining axes properties
