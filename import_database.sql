BEGIN TRANSACTION;

COPY company FROM '/home/postgres/Project/nasdaq_nyse_all.csv' WITH CSV HEADER DELIMITER AS ',';

COPY Broker_details FROM '/home/postgres/Project/small_data/brokers_list.csv' WITH CSV HEADER DELIMITER AS ',';

COPY BrokerT FROM '/home/postgres/Project/small_data/brokerT.csv' WITH CSV HEADER DELIMITER AS ',';

COPY stockexchange FROM '/home/postgres/Project/small_data/stockexchange_brokerid.csv' WITH CSV HEADER DELIMITER AS ',';

END TRANSACTION;

