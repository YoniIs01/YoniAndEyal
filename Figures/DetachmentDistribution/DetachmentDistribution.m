clear;
q = strcat('RockType=6;NumGrains=1');
IsStylos = 0;

% ForStyols
OriginalRatio = 1/61;
Scale = 3.3;
Ratio = OriginalRatio*Scale; %in cm

initial = [];
final = [];
N = length(ModelData.QueryModelDataPath(q));
for i = 1:N
    m = ModelData.LoadFromQuery(q,i);
    initial = [initial m.GetInitialDistribution()];
    final = [final m.GetDetachedDistribution()];
end
if (IsStylos)
    Sinitial = initial*(Ratio^2);
    Sfinal = final*(Ratio^2);
    BinWidth = 5;
    %createfigureinterp(Sinitial, Sfinal, BinWidth, N);
    createfigureinterp2(Sinitial, Sfinal, BinWidth, N);
end

    BinWidth = 700;
%     createfigureinterp(initial, final, BinWidth, N);
    createfigureinterp2(initial, final, BinWidth, N);

if (IsStylos)
    xlabel('Particle diameter [cm^2]')
    ylabel('Normalized mass [cm^2]')
end
