GrainNums = [100 200 400 800 1600 3200];
DoloRatios = [0:0.02:1];

figure;
hold on;
Dependence = [];
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=1;DoloRatio=',num2str(DoloRatio)));
    f = polyfit([data{:,3}],[data{:,11}],1);
    Dependence = [Dependence f(1)];
end
plot(DoloRatios,Dependence,'*');
title('Voronoi Rate to NumGrains Dependency By Dolomite Percent')
xlabel('Dolomite [%]')
ylabel('Rate/NumGrains [Pixel/(Step*#Grain)])')

figure;
hold on;
Dependence = [];
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=2;DoloRatio=',num2str(DoloRatio)));
    f = polyfit([data{:,3}],[data{:,11}],1);
    Dependence = [Dependence f(1)];
end
plot(DoloRatios,Dependence,'*');
title('Table Rate to NumGrains Dependency By Dolomite Percent')
xlabel('Dolomite [%]')
ylabel('Rate/NumGrains [Pixel/(Step*#Grain)])')

figure;
hold on;
Dependence = [];
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=3;DoloRatio=',num2str(DoloRatio)));
    f = polyfit([data{:,3}],[data{:,11}],1);
    Dependence = [Dependence f(1)];
end
plot(DoloRatios,Dependence,'*');
title('BrickWall Rate to NumGrains Dependency By Dolomite Percent')
xlabel('Dolomite [%]')
ylabel('Rate/NumGrains [Pixel/(Step*#Grain)])')