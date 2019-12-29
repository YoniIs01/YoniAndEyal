close all;


% X vector
dx = 0.01; %dont change this!
lower = dx;
upper = 800;
X = [lower:dx:upper];

% model parameters
alpha = 10; %ratio of dissolution- rate_boundaries/rate_interior
gamma = 0.0847; %gamma geometry parameter, 0.0847 value taken from mean of the model simultaions
sigma_inf = 0.1310; %  normalized (divided by mu) std on high alpha values, 0.1310 value taken from mean of the model simultaions
r = 2.0844; % 1/alpha power, 2.0844 value taken from mean of the model simultaions

%% input function
% f(x) is the discrete fmd function

% %% Execute query and fetch results
%% Model fmd
m = ModelData.LoadFromQuery(strcat('RockType=2;NumGrains=800;DoloRatio=0'),1);%,';Orientation=Vertical'
BW = (im2bw(label2rgb(m.RockFirstImage(1:420-129,109:560-109)),0.12)== 0);
CC = bwconncomp(BW);
if (CC.NumObjects == 0)
    BW = (im2bw(label2rgb(m.RockFirstImage(1:420-129,109:560-109)),0.2)== 0);
    CC = bwconncomp(BW);
end
if (CC.NumObjects == 1)
    CC = bwconncomp(BW == 0);
end
data = [cellfun(@(x) length(x),CC.PixelIdxList)];
ReweightedData = [];
for ga = data
    ReweightedData = [ReweightedData ga*ones(1,ga)];
end
dist = histogram(ReweightedData);
Xs = dist.BinEdges(1:end-1)'; %Xs = dist.BinEdges(1:end-1)';
Ys = dist.Values;
Ys = Ys/sum(Ys);
d = zeros(1,length(X));
d(~~sum(round(X,2) == round(Xs,2))) = Ys;
f = @(x) d(x == X)/dx;
M = sum(data);

%% lognormal fmd
% f_sigma = 1;
% f = @(x) exp(-((log((x))).^2)./(2*f_sigma^2))./(x.*sqrt(2*pi)*f_sigma);
% f = @(x) f(x).*(x > 0);
% M = 10;
%% delta fmd
% x0 = 70; x1 = 100;
% f = @(x) 0.5.*(double(x == x0) + double(x == x1));
% M = 280;



%% model functions
% m(x) grain size mass
m = @(x) x;
% n(x) Grain Size sumber of occurences
n = @(x) (f(x).*M)./m(x);
% mu(x) the mean of detached grain size x
mu = @(x) round(x.*(1-exp(-gamma*(alpha - 1))),2);
% sigma(x) the std of the detached grain size
sigma = @(x) ((sigma_inf + 1/(alpha^r)).*mu(x))./sqrt(n(x));
% Normal distribution
N = @(x,m,s) (exp(-(x - m).^2)./(2.*(s.^2)))./(s.*sqrt(2*pi));

%%  integral
g = zeros(1,length(X));
for Xi = X
    g = g + f(Xi)*N(X,mu(Xi),sigma(Xi)*100);
end
g = g/trapz(X,g);

%% modelResults
conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');
data = fetch(conn,['select ce.Area ' ...
    'from ChunkEvents ce ' ...
    'join models m ' ...
    'on ce.modelid = m._id ' ...
    'where rocktype = 2 ' ...
    '	and m.DoloPercent - 0  between 0 and 0.0001 ' ...
    '   and m.NumGrains = 800  '...
    '   /*and m.Orientation = ''Vertical''*/'...
    '   and ce.Area > 10 ']);
close(conn)
clear conn
GrainAreas = data.Area;
% weighting by mass
ReweightedData = [];
for ga = GrainAreas'
    ReweightedData = [ReweightedData ga*ones(1,ga)];
end
dist = histogram(ReweightedData);
Xs = dist.BinEdges(1:end-1)';
Ys = dist.Values;
close all;
Ys = Ys/sum(Ys);
d2 = zeros(1,length(X));
d2(~~sum(round(X,2) == round(Xs,2))) = Ys;
modelresult = @(x) d2(x == X)/dx;

%% Figures
figure;
hold on;
plot(X,modelresult(X)/30);
plot(X,f(X)/50);
plot(X,g);
xlim([0 max(X)]);
hold off;