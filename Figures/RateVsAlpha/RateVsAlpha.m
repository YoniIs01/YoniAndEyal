for RockType = 11
    for NumGrains = [800]%[100 200 400 800 1600 3200] 
        indexes = [];
        Rates = [];
        %% Make connection to database
        conn = database('rockmodeling?useSSL=false','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');
        RockType = num2str(RockType);
        NumGrains = num2str(NumGrains);
        %% Execute query and fetch results
        data = fetch(conn,['select m.DoloPercent AS Alphas, sum(ce.Area) / count(distinct m._id, s.stepid) AS M_Rate ' ...
                            'from models m ' ...
                            'JOIN ' ...
                            '    steps s ' ...
                            '    ON m._id = s.modelId ' ...
                            'LEFT JOIN chunkevents ce ' ...
                            '	on ce.modelid = m._id and ce.stepid = s.stepid and ce.area > 10 ' ...
                            ' WHERE rocktype = ' RockType ' ' ...
                            '	AND m.NumGrains = ' NumGrains ' ' ...
                            '    GROUP BY m.DoloPercent ' ...
                            'order by m.DoloPercent']);

        %% Close connection to database
        close(conn)
        %% Clear variables
        clear conn
        
        data2 = getChecmicalRates(RockType, NumGrains);
        %% Plotting
        X1 = data.DoloPercent;
        Y1 = [data.M_Rate data2.C_Rate data.M_Rate+data2.C_Rate];
        indexOfInterest = [1:10];
        X2 = X1(indexOfInterest);
        Y2 = Y1(indexOfInterest,:);
        createfigure(X1,Y1,X2,Y2);
    end
end