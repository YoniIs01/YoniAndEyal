
q1 = ModelData.QueryExcel('RockType=1;DoloRatio~0');
q2 = ModelData.QueryExcel('RockType=2;DoloRatio~0');
q3 = ModelData.QueryExcel('RockType=3;DoloRatio~0');

q = [q1;q2;q3];

fileNames = {q{:,10}};

for filename = fileNames
    movefile(fullfile('D:\Program Files\Results Archive\FinalResults',filename{1}),...
        fullfile('D:\Program Files\Results Archive\DolomiteResults'));
end