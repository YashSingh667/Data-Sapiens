BEGIN TRANSACTION;

\COPY company FROM 'D:/Semester8/COL362 DBMS/PROJECT/complete_data_new.csv' WITH CSV HEADER DELIMITER AS ',';
END TRANSACTION;

BEGIN TRANSACTION;
\COPY Broker_details FROM 'D:/Semester8/COL362 DBMS/PROJECT/home/small_data/brokers_list.csv' WITH CSV HEADER DELIMITER AS ',';

\COPY BrokerT FROM 'D:/Semester8/COL362 DBMS/PROJECT/home/small_data/brokerT.csv' WITH CSV HEADER DELIMITER AS ',';

\COPY stockexchange FROM 'D:/Semester8/COL362 DBMS/PROJECT/home/small_data/stockexchange_brokerid.csv' WITH CSV HEADER DELIMITER AS ',';

\COPY users(u_password, brokerID, username, email, dob, fullname) FROM 'D:/Semester8/COL362 DBMS/PROJECT/home/small_data/users_sample.csv' DELIMITER ',' CSV HEADER;

END TRANSACTION;

