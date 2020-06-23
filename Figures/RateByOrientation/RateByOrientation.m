% Horizontal
r = [2 5 6 7.2 8.1 9 9.8 10.8 11.7 13 14 16]; 
% Vertical
t = [2 3 6 7.1 8 9.1 10 11 11.9 13 14.6 16];
data = GetData();
indexes = strcmp(data.Orientation,'Vertical');
createfigure5(t,data.Rate(indexes),data.Std(indexes),r,data.Rate(~indexes),data.Std(~indexes))
