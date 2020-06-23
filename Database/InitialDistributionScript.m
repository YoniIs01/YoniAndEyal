%% Insert Data to MySQL Database
% database name - mysql_models configured as
% schema = rockmodeling, user = Yoni, pwd = Yoni
%% Connecting
conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/rockmodeling?useSSL=false&');
if (isempty(conn.Message)) %Connection Succesfull
    %Query Model
    for model_data_FileName = 'ImportedDataFromExcel'.WS_FileName'
        m = ModelData.Load(model_data_FileName);
        % insert into Database
        InsertInitialDistribution(conn,m);
        disp(model_data_FileName);
    end
    close(conn);
else 
    disp(strcat('Connection Error - ',conn.Message));
end

%%
