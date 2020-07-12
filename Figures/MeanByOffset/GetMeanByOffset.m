function data = GetMeanByOffset()
%% Make connection to database
conn = database('rockmodeling','Yoni','Yoni','Vendor','MYSQL','Server','localhost','PortNumber',3306);

%% Execute query and fetch results
data = fetch(conn,['select NumGrains, ' ...
    '		Orientation, ' ...
    '        avg(weighted_mean) as weighted_mean, ' ...
    '        stddev(weighted_mean) as weighted_mean_err ' ...
    'from (SELECT ' ...
    '	_id, ' ...
    '    NumGrains, ' ...
    '    Orientation, ' ...
    '    SUM(POWER(ce.Area, 2)) / (SUM(ce.Area)) AS weighted_mean, ' ...
    '    SQRT(SUM(POWER(ce.Area, 3)) / (SUM(ce.Area)) - POWER(SUM(POWER(ce.Area, 2)) / (SUM(ce.Area)), ' ...
    '                    2)) AS weighted_sigma ' ...
    'FROM ' ...
    '    models AS m ' ...
    '        JOIN ' ...
    '    steps s ON m._id = s.modelId ' ...
    '        JOIN ' ...
    '    chunkevents ce ON ce.modelid = m._id ' ...
    '        AND ce.stepid = s.stepid ' ...
    'WHERE ' ...
    '    RockType = 3 AND Orientation != ''None'' ' ...
    '        AND DoloPercent <= 0.001 ' ...
    '        AND NumGrains IN (100 , 800, 1600) ' ...
    '        AND ce.Area > 10 ' ...
    'GROUP BY _id, NumGrains , Orientation ' ...
    'ORDER BY NumGrains , Orientation, _id ' ...
    ') as q ' ...
    'group by NumGrains, ' ...
    '		Orientation']);
%% Close connection to database
close(conn)

%% Clear variables
clear conn