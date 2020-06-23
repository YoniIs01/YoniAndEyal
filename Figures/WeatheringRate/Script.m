ColumnsToDistinctIndex = [2:5];
StepCounterIndex = 6;

alldata = ModelData.QueryExcel('');
ColumnsToDistinct = alldata(2:end,ColumnsToDistinctIndex);
b=cellfun(@num2str,ColumnsToDistinct,'un',0);
c=arrayfun(@(x) horzcat(b{x,:}),(1:size(ColumnsToDistinct,1))','un',0);
[idx,idx]=unique(c);
DistinctData = ColumnsToDistinct(idx,:);

for i = 1:length(DistinctData)
    [RockType NumGrains DoloRatio Orientation] = DistinctData{i,:};
    data = ModelData.QueryExcel(Query);
    Rate = 99813/mean([data{:,StepCounterIndex}]);
    DistinctData{i,5} = Rate;
%     pathlist = ModelData.QueryModelDataPath(strcat('RockType=',num2str(row{1}),';NumGrains=',num2str(row{2}),';DoloRatio=',num2str(row{3}),';Orientation=',row{4}));
end


RefinedIndexes  = [1:size(DistinctData,1)];
RefinedIndexes = intersect(RefinedIndexes,find([DistinctData{1:end,1}] == ModelData.RockTypes.Voronoi));
RefinedIndexes = intersect(RefinedIndexes,find([DistinctData{1:end,2}] == 100));
plot([DistinctData{RefinedIndexes,3}],[DistinctData{RefinedIndexes,5}],'*');
    


    
