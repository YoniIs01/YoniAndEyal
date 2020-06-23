
m = ModelData.LoadFromQuery(strcat('RockType=11;NumGrains=800;DoloRatio=50'),1);
data1 = m.GetInitialDistribution();
data2 = m.GetDetachedDistribution();
m = ModelData.LoadFromQuery(strcat('RockType=11;NumGrains=800;DoloRatio=20'),1);
data3 = m.GetDetachedDistribution();
m = ModelData.LoadFromQuery(strcat('RockType=11;NumGrains=800;DoloRatio=10'),1);
data4 = m.GetDetachedDistribution();
m = ModelData.LoadFromQuery(strcat('RockType=11;NumGrains=800;DoloRatio=5'),1);
data5 = m.GetDetachedDistribution();
m = ModelData.LoadFromQuery(strcat('RockType=11;NumGrains=800;DoloRatio=3'),1);
data6 = m.GetDetachedDistribution();

createfigure2(data1, data2, data3, data4, data5, data6);
createfigure2interp(data1, data2, data3, data4, data5, data6);