function createfigure3(X1, Y1, Y2, Y3, E1, E2, E3)
%CREATEFIGURE3(X1, Y1, Y2, Y3)
%  X1:  scatter x
%  Y1:  scatter y
%  Y2:  scatter y
%  Y3:  scatter y

%  Auto-generated by MATLAB on 23-Dec-2019 12:44:04

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
hold(subplot1,'on');

% Create scatter
% scatter(X1,Y1,'DisplayName','100','Parent',subplot1,...
%     'MarkerFaceColor',[0 0 0],...
%     'MarkerEdgeColor',[0 0 0]);
% errorbar(X1,Y1,E1,'o','color','k');
errorbar(X1,Y1,E1,'o','Color',[0 0 0],'MarkerSize',8,'MarkerFaceColor',[0 0 0],...
   'MarkerEdgeColor',[0 0 0],'DisplayName','\mu_0=2160');
box(subplot1,'on');
% Set the remaining axes properties
set(subplot1,'FontSize',20);
xtickformat('percentage');
xlabel('Offset');
legend('Orientation','horizontal','Location','northeast','Box', 'off');

%ylim([min(Y1)-0.5,max(Y1)+0.5]);


% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure1);
hold(subplot2,'on');

% Create scatter
% scatter(X1,Y2,'Parent',subplot2,...
%     'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
%     'MarkerEdgeColor',[0 0.447058826684952 0.74117648601532]);
% errorbar(X1,Y2,E2,'o','color',[0 0.447058826684952 0.74117648601532]);
errorbar(X1,Y2,E2,'o','Color',[0, 0, 0.75],'MarkerSize',8,'MarkerFaceColor',[0, 0, 0.75],...
   'MarkerEdgeColor',[0, 0, 0.75],'DisplayName','\mu_0=234');
% Create ylabel

box(subplot2,'on');
% Set the remaining axes properties
set(subplot2,'FontSize',20);
xtickformat('percentage');
legend('Orientation','horizontal','Location','northeast','Box', 'off');
xlabel('Offset');
ylabel('Mean Detachment Size [Pixels]','HorizontalAlignment','center');
ylim([min(Y2)-0.01*min(Y2),max(Y2)+0.021*max(Y2)]);
yticks([110 115 120 125]);


% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure1);
hold(subplot3,'on');

% Create scatter
% scatter(X1,Y3,'Parent',subplot3,'MarkerFaceColor',[.75, 0, 0],...
%     'MarkerEdgeColor',[.75, 0, 0]);
% errorbar(X1,Y3,E3,'o','color',[.75, 0, 0]);
errorbar(X1,Y3,E3,'o','Color',[.75, 0, 0],'MarkerSize',8,'MarkerFaceColor',[.75, 0, 0],...
   'MarkerEdgeColor',[.75, 0, 0],'DisplayName','\mu_0=108');
% Create xlabel

xlabel('Offset');
ylim([min(Y3)-0.01*min(Y3),max(Y3)+0.01*max(Y3)]);

box(subplot3,'on');
% Set the remaining axes properties
set(subplot3,'FontSize',20);
xtickformat('percentage');
legend('Orientation','horizontal','Location','northeast','Box', 'off');
