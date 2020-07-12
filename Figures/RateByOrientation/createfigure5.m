function createfigure5(X1, Y1, Err1, X2, Y2,Err2)
%CREATEFIGURE5(X1, Y1, DMatrix1, X2, Y2)
%  X1:  scatter x
%  Y1:  scatter y
%  DMATRIX1:  errorbar delta matrix data
%  X2:  scatter x
%  Y2:  scatter y

%  Auto-generated by MATLAB on 27-Jan-2020 18:19:55

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create scatter
%scatter(X1,Y1,45,'DisplayName','Vertical','MarkerFaceColor',[0 0 0],...
 %   'MarkerEdgeColor','none');

% Create multiple error bars using matrix input to errorbar
errorbar(X1,Y1,Err1,'o','MarkerSize',6,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],'Color',[0 0 0],'DisplayName','Parallel Stylolites');
% %set(errorbar1,'DisplayName','Vertical+Error','-s','MarkerSize',10,...
%     'MarkerFaceColor',[0 0 0],...
%     'MarkerEdgeColor',[0 0 0],...
%     'Color',[0 0 0]);

% Create scatter
%scatter(X2,Y2,45,'DisplayName','Horizontal','MarkerFaceColor',[0 0 1],...
%    'MarkerEdgeColor','none');
hold on;
errorbar(X2,Y2,Err2,'o','MarkerSize',6,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],'Color',[0 0 1],'DisplayName','Perpendicular Stylolites');
% 
% set(errorbar2,'DisplayName','Horizontal Error','MarkerFaceColor',[0 0 1],...
%     'Color',[0 0 1]);

% Create ylabel
ylabel('Rate [Pixels/#Steps]','FontSize',18);

% Create xlabel
xlabel('Stylolites Density','FontSize',18);

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 17]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[20 100]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18);
% Create legend
legend1 = legend(axes1,'show','FontSize',18);
set(legend1,'Location','southeast');
xlim([1 17]);
ylim([20 100]);
xtickformat('percentage');