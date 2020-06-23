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

X1 = cellfun(@str2num,data.Orientation(Indexes))*100;
createfigure3(X1,Y(:,1),Y(:,2),Y(:,3),Errors(:,1),Errors(:,2),Errors(:,3))
%createfigure4_2_GS(X1,Y(:,1),Y(:,2),Y(:,3),Errors(:,1),Errors(:,2),Errors(:,3),Tau(:,1),Tau(:,2),Tau(:,3))
