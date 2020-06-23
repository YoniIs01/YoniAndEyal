m = ModelData.LoadFromQuery(strcat('RockType=4;NumGrains=10'),1);
% SurfaceBtTime = zeros(m.TotalTimeSteps,m.RockSize(2));
% n = m.TotalTimeSteps;
% for i = 1:n
%     [rows,cols] = ind2sub(m.RockSize,m.Steps(i).SolutionContactLinearIndex);
%     parfor j = 1:560
%         rs = rows(cols == j);
%         if isempty(rs)
%             SurfaceBtTime(i,j) = 1;
%         else
%             SurfaceBtTime(i,j) = min(rows(cols == j)) - 1;
%         end
%     end
% end

RockMatrixes = m.GetRockMatrixesByStep();
SurfaceBtTime = cellfun(@(CurrentMatrix) sum(CurrentMatrix==0),RockMatrixes,'UniformOutput',false);
SurfaceBtTime = SurfaceBtTime';
SurfaceBtTime = cell2mat(SurfaceBtTime);
RateByTimeByCol = diff(SurfaceBtTime(1:2:end-1,:) + SurfaceBtTime(2:2:end,:),1,1);

% surface 
% TimeToPlot = 100;
% figure; plot([1:319],SurfaceBtTime(TimeToPlot,1:319));
% rate spectra all steps
figure; imshow(label2rgb(RateByTimeByCol(:,119:560-119)));
% height color map single step
figure; imshow(label2rgb(SurfaceBtTime(5,119:560-119)));
% rock image
figure; m.ShowRockFirstFrame();

%height pdf single step
MeanHeights = (SurfaceBtTime(900,119:560-119));
MeanHeightsDist = sortrows(unique([MeanHeights' sum(MeanHeights==MeanHeights')'],'rows'),1);
Normalized = MeanHeightsDist(:,2)/trapz(MeanHeightsDist(:,1),MeanHeightsDist(:,2));
figure; plot(MeanHeightsDist(:,1),Normalized);