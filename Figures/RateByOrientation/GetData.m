function data = GetData()
%% Automate Importing Data by Generating Code Using the Database Explorer App
% This code reproduces the data obtained using the Database Explorer app by
% connecting to a database, executing a SQL query, and importing data into the
% MATLAB(R) workspace. To use this code, add the password for connecting to the
% database in the database command.

% Auto-generated by MATLAB Version 9.5 (R2018b) and Database Toolbox Version 9.0 on 27-Jan-2020 17:57:57

%% Make connection to database
conn = database('rockmodeling','Yoni','Yoni','Vendor','MYSQL','Server','localhost','PortNumber',3306);

%% Execute query and fetch results
data = fetch(conn,['select Orientation, ' ...
    '	   NumGrains, ' ...
    '       avg(Rate) AS Rate, ' ...
    '       stddev(Rate) AS Std ' ...
    'from ( ' ...
    '	select m._id, ' ...
    '		   Orientation, ' ...
    '		   NumGrains, ' ...
    '		   99813/count(distinct m._id, s.stepId) AS Rate ' ...
    '	from models as m ' ...
    '	join steps as s ' ...
    '	on m._id = s.modelId ' ...
    '	where rocktype = 4 ' ...
    '	group by m._id, NumGrains,Orientation ' ...
    ') as q ' ...
    'group by NumGrains,Orientation ' ...
    'order by Orientation,NumGrains']);
%% Close connection to database
close(conn)

%% Clear variables
clear conn
end