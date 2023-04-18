BEGIN TRANSACTION;

COPY company FROM '/home/postgres/Project/nasdaq_nyse_all.csv' WITH CSV HEADER DELIMITER AS ',';

END TRANSACTION;

