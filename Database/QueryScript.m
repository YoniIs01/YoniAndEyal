conn= database('rockmodeling','Yoni','Yoni','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');
if (isempty(conn.Message)) %Connection Succesfull
    Query = 
    close(conn);
else 
    disp(strcat('Connection Error - ',conn.Message));
end