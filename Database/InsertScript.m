%% Insert Data to MySQL Database
% database name - mysql_models configured as
% schema = rockmodeling, user = Yoni, pwd = Yoni

%% Connecting
conn= database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');
if (isempty(conn.Message)) %Connection Succesfull
    %Query Model
    for i=1:15:800
        m = ModelData.LoadFromQuery(strcat(''),i);
        % insert into Database
        model_id = InsertModelData(conn,m);
        disp(model_id);
    end
    close(conn);
else 
    disp(strcat('Connection Error - ',conn.Message));
end

%%
