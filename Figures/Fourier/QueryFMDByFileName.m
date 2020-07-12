function FMD = QueryFMDByFileName(FileName)
%% FMD - Filtered Mechanical Dissolution (steps without big particles detached becomes zero)

%% Automate Importing Data by Generating Code Using the Database Explorer App
% This code reproduces the data obtained using the Database Explorer app by
% connecting to a database, executing a SQL query, and importing data into the
% MATLAB(R) workspace. To use this code, add the password for connecting to the
% database in the database command.

% Auto-generated by MATLAB Version 9.5 (R2018b) and Database Toolbox Version 9.0 on 12-Aug-2019 13:01:09

%% Make connection to database
% conn = database('rockmodeling','Yoni','Yoni','Vendor','MYSQL','Server','localhost','PortNumber',3306);
conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/rockmodeling?useSSL=false&');
%% Execute query and fetch results
data = fetch(conn,['select _id, ' ...
    '	   s.stepid, ' ...
    '       case when count(ce.Area) != 0 then s.Mechanical_Dissolution ' ...
    '            else 0 ' ...
    '		end AS Filtered_Mechanical_Dissolution ' ...
    '        from models m ' ...
    'join steps s ' ...
    'on m._id = s.modelId ' ...
    'left outer join chunkevents ce ' ...
    'on s.modelid = ce.modelid and s.stepid = ce.stepid and ce.Area > 10 ' ...
    'where m.FileName = ''',FileName,''' ' ...
    'group by _id, s.stepid']);
%% Close connection to database
close(conn)

%% Clear variables
clear conn
FMD = data.Filtered_Mechanical_Dissolution;
end
