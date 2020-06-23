GrainNums = [100 200 400 800 1600 3200];
DoloRatios = [0:0.02:1];

% 
% %% Voronoi all samples
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=1;NumGrains=',num2str(GrainNum)));
%     plot([data{:,4}].*100,[data{:,11}],'*');
% end
% set(gca,'fontsize',20);
% title('Voronoi Rate By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% %% Table all samples
% 
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=2;NumGrains=',num2str(GrainNum)));
%     plot([data{:,4}].*100,[data{:,11}],'o');
% end
% set(gca,'fontsize',20);
% title('Table Rate By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% %% Brickwall all samples
% 
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=3;NumGrains=',num2str(GrainNum)));
%     plot([data{:,4}].*100,[data{:,11}],'s');
% end
% set(gca,'fontsize',20);
% title('BrickWall Rate By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% %% Voronoi mean samples
% 
% 
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=1;NumGrains=',num2str(GrainNum)));
%     [G,I]=findgroups([data{:,4}]);
%     plot(I.*100,splitapply(@mean,[data{:,11}],findgroups([data{:,4}])),'*');
% end
% set(gca,'fontsize',20);
% title('Voronoi Mean Rate By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% 
% %% Table mean samples
% 
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=2;NumGrains=',num2str(GrainNum)));
%     [G,I]=findgroups([data{:,4}]);
%     plot(I.*100,splitapply(@mean,[data{:,11}],findgroups([data{:,4}])),'o');
% end
% set(gca,'fontsize',20);
% title('Table Mean By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% %% Brickwall mean samples
% 
% 
% figure;
% hold on;
% for GrainNum = GrainNums
%     data = ModelData.QueryExcel(strcat('RockType=3;NumGrains=',num2str(GrainNum)));
%     [G,I]=findgroups([data{:,4}]);
%     plot(I.*100,splitapply(@mean,[data{:,11}],findgroups([data{:,4}])),'s');
% end
% set(gca,'fontsize',20);
% title('BrickWall Mean Rate By Dolomite Percent','fontsize',20)
% xlabel('Dolomite [%]','fontsize',20)
% ylabel('Rate [Pixel/Step])','fontsize',20)
% legend(sprintfc('%d',GrainNums),'fontsize',16);
% 
% 
%% voronoi with shade std
figure;
hold on;
color_index=0;
for GrainNum = GrainNums
    color_index=color_index+1;
    %NumericColors={[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840]};
    colors=['k';'m';'c';'r';'g';'b'];
    data = ModelData.QueryExcel(strcat('RockType=1;NumGrains=',num2str(GrainNum)));
    data(:,4)=num2cell(round([data{:,4}],2,'significant'));
    data(:,11)=num2cell(99813./([data{:,6}]));
    [G,I]=findgroups([data{:,4}]);
    ordering = splitapply(@(x) {sortrows(x)},[data{:,11}],G);
    ordering = cell2mat(ordering(:));
    %shadedErrorBar(I.*100,splitapply(@mean,[data{:,11}],G),splitapply(@std,[data{:,11}],G))
    %stdshade(ordering',0.22,NumericColors(color_index),[0:2:100],9); 
    stdshade(ordering',0.22,colors(color_index),[0:2:100],9); 
end  
set(gca,'fontsize',20);
title('Voronoi Mean Rate By Dolomite Percent','fontsize',20)
xlabel('Dolomite [%]','fontsize',20)
ylabel('Rate [Pixel/Step])','fontsize',20)
legend([string(GrainNums);strcat('[',string(GrainNums),']')])
%legend(num2str(sort([GrainNums,GrainNums])'));
