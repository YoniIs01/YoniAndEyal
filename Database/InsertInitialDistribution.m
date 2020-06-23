function InsertInitialDistribution(conn,model_data)
    %InsertInitialDistribution Summary of this function goes here
    %   Detailed explanation goes here

    %% Constants
    initial_distribution_TABLE_NAME = 'initial_distribution';
    initial_distribution_COLNAMES = {'RockType', 'NumGrains', 'Orientation', 'GrainArea'};

    %% initial_distribution Tables Insert

    if (isempty(model_data.Orientation))
        model_data.Orientation = 'None';
    elseif isa(model_data.Orientation,'cell') 
        model_data.Orientation = model_data.Orientation{1};
    end
    values = {};
    for GrainArea = model_data.OriginalRockGrainAreas
        values(end+1,:) = {model_data.RockType,...
                          model_data.NumGrains,...
                          model_data.Orientation,...
                          GrainArea};
    end
    data = cell2table(values,'VariableNames',initial_distribution_COLNAMES);
    sqlwrite(conn,initial_distribution_TABLE_NAME,data);
end
