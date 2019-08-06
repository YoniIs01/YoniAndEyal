function model_id = InsertModelData(conn,model_data)
%INSERTTOMODELSTABLE Summary of this function goes here
%   Detailed explanation goes here

%% Constants
MODELS_TABLE_NAME = 'models';
MODELS_COLNAMES = {'TimeStamp', 'RockType', 'NumGrains', 'DoloPercent', 'Orientation', 'StartTime', 'EndTime', 'FileName'};
STEPS_TABLE_NAME = 'steps';
STEPS_COLNAMES = {'modelId', 'stepId', 'Mechanical_Dissolution', 'Chemical_Dissolution','Solution_Contact_Area'};
CHUNCK_EVENTS_TABLE_NAME = 'chunkevents';
CHUNCK_EVENTS_COLNAMES = {'modelId','Stepid','Area','Width','Height'};
MODELS_INFO_TABLE_NAME = 'models_info';
MODELS_INFO_COLNAMES = {'modelid','SolutionContactStabilizedStepId','SolutionOutOfBBoxStepId'};


%% Models Tables Insert

if (isempty(model_data.Orientation))
    model_data.Orientation = 'None';
elseif isa(model_data.Orientation,'cell') 
    model_data.Orientation = model_data.Orientation{1};
end
values = {model_data.TimeStamp,...
          model_data.RockType,...
          model_data.NumGrains,...
          model_data.DoloPercent,...
          model_data.Orientation,...
          datetime(model_data.StartTime),...
          datetime(model_data.EndTime),...
          model_data.FileName};
      
data = cell2table(values,'VariableNames',MODELS_COLNAMES);
sqlwrite(conn,MODELS_TABLE_NAME,data);
q = fetch(conn,strcat("select _id from models where filename = '",model_data.FileName,"'"));
model_id = q{1,1};

%% Steps and chunckEvents Table Insert
steps_values = {};
chunck_values = {};
    for step = model_data.Steps
        steps_values(end+1,:) = {model_id,...
                                step.StepId,...
                                step.Mechanical_Dissolution,...
                                step.Chemical_Dissolution,...
                                step.SolutionContactArea};
                            
        for chunck_event = step.ChunckEvents
            chunck_values(end+1,:) = {model_id,...
                                      step.StepId,...
                                      chunck_event.Area,...
                                      chunck_event.Width,...
                                      chunck_event.Height};
        end
    end
    
%% Writing Data to Steps

data = cell2table(steps_values,'VariableNames',STEPS_COLNAMES);
sqlwrite(conn,STEPS_TABLE_NAME,data);

%% Writing Data to chunkevents
if ~isempty(chunck_values)
    data = cell2table(chunck_values,'VariableNames',CHUNCK_EVENTS_COLNAMES);
    sqlwrite(conn,CHUNCK_EVENTS_TABLE_NAME,data);
end
%% Writing Data to modelsinfo
    modelsinfo_values = {model_id,...
                         model_data.SolutionContactStabilizedStepId,...
                         model_data.SolutionOutOfBBoxStepId};
    data = cell2table(modelsinfo_values,'VariableNames',MODELS_INFO_COLNAMES);
    sqlwrite(conn,MODELS_INFO_TABLE_NAME,data);
end

