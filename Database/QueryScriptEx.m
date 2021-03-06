%% Automate Importing Data by Generating Code Using the Database Explorer App
% This code reproduces the data obtained using the Database Explorer app by
% connecting to a database, executing a SQL query, and importing data into the
% MATLAB(R) workspace. To use this code, add the password for connecting to the
% database in the database command.

% Auto-generated by MATLAB Version 9.5 (R2018b) and Database Toolbox Version 9.0 on 04-Aug-2019 14:04:53

%% Make connection to database
conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/rockmodeling?useSSL=false&');

%% Execute query and fetch results
if (isempty(conn.Message))
    data = fetch(conn,['select ' ...
        '	m._id ,tf.TotalDissolution /count(*) ' ...
        'from models as m ' ...
        'join models_info as mi ' ...
        'on mi.modelid = m._id ' ...
        'join totaldissolutionon500stepsfrombottom as tf ' ...
        'on tf.modelId = m._id ' ...
        'join steps s ' ...
        '	on s.modelid = m._id ' ...
        '    and s.stepId >= mi.SolutionOutOfBBoxStepId - 500 ' ...
        '    and s.stepId <= mi.SolutionOutOfBBoxStepId ' ...
        'group by m._id;']);
else 
    disp(strcat('Connection Error - ',conn.Message));
end
%% Close connection to database
close(conn)

%% Clear variables
clear conn