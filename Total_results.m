
%% Creating figures
%% Mechanical Dissolution Ratio figure
DoloRatio= 0.05:0.05:1;
NumGrains = [100,1000,5000,10000];
figure(2)
surf(NumGrains,100*DoloRatio,100*Mechanical_Dissolution_percentage);
title('Mechanical Dissolution Ratio Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
zlabel('Mechanical Dissolution Ratio')
colorbar;
%% Mechanical Dissolution EVENTS figure
figure(3)
imagesc(NumGrains,100*DoloRatio,Total_chunk_events)
title('Mechanical Dissolution EVENTS Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
xlim([0,10000])
colorbar;
%% Dissolution Timesteps figure
figure(4)
surf(NumGrains,100*DoloRatio,timesteps)
title('Total timesteps Vs Number of Grains and Dolomite Ratio');  
xlabel('Number of grains');
ylabel('Dolomite Ratio');
zlabel('Total Timesteps');
colorbar;