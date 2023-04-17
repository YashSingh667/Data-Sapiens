BEGIN TRANSACTION;

COPY People FROM '/home/postgres/Project/Project/nasdaq_nyse_all.csv' WITH CSV HEADER DELIMITER AS ',';

END TRANSACTION;
