GrainNums = [100 200 400 800 1600 3200];
DoloRatios = [0:0.02:1];

figure;
hold on;
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=1;DoloRatio=',num2str(DoloRatio)));
    plot([data{:,3}],[data{:,11}],'*');
end
legend(sprintfc('%d',DoloRatios));

figure;
hold on;
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=2;DoloRatio=',num2str(DoloRatio)));
    plot([data{:,3}],99813./[data{:,11}],'o');
end
legend(sprintfc('%d',DoloRatios));

figure;
hold on;
for DoloRatio = DoloRatios
    data = ModelData.QueryExcel(strcat('RockType=3;DoloRatio=',num2str(DoloRatio)));
    plot([data{:,3}],[data{:,11}],'s');
end
legend(sprintfc('%d',DoloRatios));