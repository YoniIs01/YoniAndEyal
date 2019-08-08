%% Insert Data to MySQL Database
% database name - mysql_models configured as
% schema = rockmodeling, user = Yoni, pwd = Yoni
%% Connecting
javaaddpath([matlabroot,'\java\jarext\mysql-connector-java-5.1.48-bin.jar'])
conn= database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');
if (isempty(conn.Message)) %Connection Succesfull
    %Query Model
    n = length(ModelData.QueryModelDataPath('RockType~1'));
    parfor i=174:n
        m = ModelData.LoadFromQuery(strcat('RockType~1'),i);
        % insert into Database
        model_id = InsertModelData(conn,m);
        disp(model_id);
    end
    close(conn);
else 
    disp(strcat('Connection Error - ',conn.Message));
end

%%
