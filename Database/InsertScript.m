%% Insert Data to MySQL Database
% database name - mysql_models configured as
% schema = rockmodeling, user = Yoni, pwd = Yoni
%% Connecting
conn = database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/rockmodeling?useSSL=false&');
if (isempty(conn.Message)) %Connection Succesfull
    %Query Model
    q = 'RockType=11';
%     n = length(ModelData.QueryModelDataPath(q));
    n = length(ModelResults.WS_FileName);
    parfor i=1:n
%         m = ModelData.LoadFromQuery(strcat(q),i);
        m = ModelData.Load(ModelResults.WS_FileName(i));
        % insert into Database
        model_id = InsertModelData(conn,m);
        disp(model_id);
    end
    close(conn);
else 
    disp(strcat('Connection Error - ',conn.Message));
end

%%
