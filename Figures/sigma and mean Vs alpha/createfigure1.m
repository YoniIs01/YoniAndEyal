function createfigure1(Alphas, Means, Sigmas, FitMu, FitSigma, InitialMean, InitialSigma)
%CREATEFIGURE1(X1, Y1, X2, YMatrix1, Y2, X3, YMatrix2)
%  X1:  scatter x
%  Y1:  scatter y
%  X2:  vector of x data
%  YMATRIX1:  matrix of y data
%  Y2:  scatter y
%  X3:  vector of x data
%  YMATRIX2:  matrix of y data

%  Auto-generated by MATLAB on 16-Dec-2019 14:39:46

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create scatter
scatter(Alphas,Means,'DisplayName','\mu_(_\alpha_)','MarkerEdgeColor',[0 0 0]);

% Create multiple lines using matrix input to plot
FitMuplot = plot(FitMu);
FitSigmaplot = plot(FitSigma);
set(FitMuplot,'DisplayName','\mu fit',...
    'Color',[0.313725501298904 0.313725501298904 0.313725501298904],...
    'LineWidth',1);
set(FitSigmaplot,'DisplayName','\sigma fit',...
    'Color',[[0 0 1]],...
    'LineWidth',1);

% Create scatter
scatter(Alphas,Sigmas,'DisplayName','\sigma_(_\alpha_)',...
    'MarkerEdgeColor',[0 0 1]);

% Create multiple lines using matrix input to plot
YMatrix2 = ones(1,length(Alphas)).*[InitialMean;InitialSigma];
plot2 = plot(Alphas,YMatrix2,'LineStyle','--');
set(plot2(1),'DisplayName','Initial Mean','Color',[0 0 0]);
set(plot2(2),'DisplayName','Initial Sigma',...
    'Color',[[0 0 1]]);

% Create ylabel
ylabel('\mu and \sigma [Pixels]','HorizontalAlignment','center');

% Create xlabel
xlabel({'\alpha',''},'HorizontalAlignment','center');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0 100]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[0 InitialMean + 40]);
% Set the remaining axes properties
set(axes1,'FontSize',16);
% Create textbox
annotation(figure1,'textbox',...
    [0.824007652108995 0.551544380017839 0.101127659574468 0.0394736842105265],...
    'Color',[0.0784313753247261 0.168627455830574 0.549019634723663],...
    'String','Initial \sigma',...
    'LineStyle','none',...
    'FontSize',14,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.817927958193355 0.880909901873327 0.101127659574468 0.0394736842105265],...
    'String','Initial \mu',...
    'LineStyle','none',...
    'FontSize',14,...
    'FitBoxToText','off');

% legend
legend off;
hold off;

