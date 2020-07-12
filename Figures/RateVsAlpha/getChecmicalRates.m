function value = getChecmicalRates(RockType,NumGrains )

    %% Make connection to database
    conn = database('rockmodeling','Yoni','Yoni','Vendor','MYSQL','Server','localhost','PortNumber',3306);

    %% Execute query and fetch results
    data = fetch(conn,['select DoloPercent,  sum(C_Rate) / sum(steps) AS C_Rate ' ...
        'from ( ' ...
        'select m.DoloPercent, sum(ce.Area) as C_Rate, 0 Steps ' ...
        'from models m ' ...
        'JOIN ' ...
        '    steps s ' ...
        '    ON m._id = s.modelId ' ...
        'LEFT JOIN chunkevents ce ' ...
        '	on ce.modelid = m._id and ce.stepid = s.stepid and ce.area < 10 ' ...
        ' WHERE rocktype =  ' RockType '  ' ...
        '	AND m.NumGrains = ' NumGrains ' ' ...
        '    GROUP BY m.DoloPercent ' ...
        'union ' ...
        'select m.DoloPercent, sum(s.Chemical_Dissolution) as C_Rate, count(distinct  m._id, s.stepid) ' ...
        'from models m ' ...
        'JOIN ' ...
        '    steps s ' ...
        '    ON m._id = s.modelId ' ...
        ' WHERE rocktype =  ' RockType '  ' ...
        '	AND m.NumGrains = ' NumGrains ' ' ...
        '    GROUP BY m.DoloPercent ' ...
        'order by DoloPercent ' ...
        ') t ' ...
        'group by DoloPercent']);
    value =data;
    %% Close connection to database
    close(conn);
    %% Clear variables
    clear conn;
end