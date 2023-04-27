-- registration form --
INSERT INTO users (fullname, dob, email, username, u_password, brokerID, customerID, wallet)
VALUES ('', '', '', '', '', '', '');

-- profile --
SELECT fullname, dob, email, username, brokerID, customerID, wallet FROM users WHERE username = '"+str(username)"';

-- transactions --
WITH temp as 
(SELECT * FROM Orderbook WHERE customerID = /var),
temp2 as
(SELECT temp.*, Transactions.t_date FROM temp JOIN Transactions ON temp.transactionID = Transactions.transactionID)
SELECT temp2.*, stockexchange.Exchange_name FROM temp2 JOIN stockexchange ON temp2.exchangebrokerID = stockexchange.exchangebrokerID 
ORDER BY t_date DESC;

-- portfolio --
SELECT Stock_name, exchangebrokerID, stockvolume FROM portfolio WHERE customerID = /var;

-- profile update wallet --
UPDATE users
SET wallet = /var
WHERE customerID = /var;

-- portfolio --
select stock_name,Exchange_name,stockvolume
from portfolio
join stockexchange
on stockexchange.exchangebrokerID = portfolio.exchangebrokerID
where customerID = %s


-- transactions
select t_date, transactionID, stock_name, Exchange_name, stockvolume, stockprice 
from Orderbook
join stockexchange
on stockexchange.exchangebrokerID = Orderbook.exchangebrokerID
where customerID = %s
order by t_date

-- nasdaq --

select stock_name, high, low, open, close
from company 
where cdate = '2005-09-27' and Exchange_name = 'nasdaq';

SELECT COUNT(*) FROM company where cdate = '2005-09-27' and Exchange_name = 'nasdaq'


select stock_name, high, low, open, close from company 
where cdate = %s and Exchange_name = %s and high is not null and low is not null and open is not null and close is not null
order by stock_name LIMIT %s OFFSET %s;



--- Buying of stock ---


-- BEGIN TRANSACTION;

-- -- Check if user exists
-- IF EXISTS (SELECT * FROM users WHERE username = '<username>') THEN
--     -- Check user's wallet balance
--     SELECT wallet FROM users WHERE username = '<username>';

--     -- Check if user has sufficient balance
--     IF ((SELECT wallet FROM users WHERE username = '<username>') >= (<stock_volume> * <stock_price>)) THEN
--         -- Check if user already has the stock in their portfolio
--         IF EXISTS (SELECT * FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>') THEN
--             -- Update user's portfolio stock volume
--             UPDATE Portfolio SET stockvolume = stockvolume + <stock_volume>
--             WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';
--         ELSE
--             -- Add new stock to user's portfolio
--             INSERT INTO Portfolio (stockvolume, exchangebrokerID, Stock_name, customerID)
--             VALUES (<stock_volume>, '<exchange_broker_id>', '<stock_name>', <customer_id>);
--         END IF;

--         -- Buy stock from company table
--         INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date)
--         VALUES ('<stock_name>', <customer_id>, '<exchange_broker_id>', <stock_volume>, <stock_price>, '<transaction_date>');

--         -- Update user's wallet balancei
--         UPDATE users SET wallet = wallet - (<stock_volume> * <stock_price>) WHERE username = '<username>';

--     ELSE
--         -- Throw an error if user has insufficient balance
--         RAISE EXCEPTION 'Insufficient balance in user wallet.';
--     END IF;
-- ELSE
--     -- Throw an error if user does not exist
--     RAISE EXCEPTION 'User does not exist.';
-- END IF;

-- COMMIT;





BEGIN TRANSACTION;

-- Check if user exists
IF EXISTS (SELECT 1 FROM users WHERE username = '<username>') THEN
-- Check user's wallet balance
SELECT wallet FROM users WHERE username = '<username>';

-- Check if user has sufficient balance
IF ((SELECT wallet FROM users WHERE username = '<username>') >= (<stock_volume> * <stock_price>)) THEN
    -- Check if user already has the stock in their portfolio
    IF EXISTS (SELECT 1 FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>') THEN
        -- Update user's portfolio stock volume
        UPDATE Portfolio SET stockvolume = stockvolume + <stock_volume>
        WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';
    ELSE
        -- Add new stock to user's portfolio
        INSERT INTO Portfolio (stockvolume, exchangebrokerID, Stock_name, customerID)
        VALUES (<stock_volume>, '<exchange_broker_id>', '<stock_name>', <customer_id>);
    END IF;

    -- Buy stock from company table
    INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date)
    VALUES ('<stock_name>', <customer_id>, '<exchange_broker_id>', <stock_volume>, <stock_price>, '<transaction_date>');

    -- Update user's wallet balance
    UPDATE users SET wallet = wallet - (<stock_volume> * <stock_price>) WHERE username = '<username>';

ELSE
    -- Throw an error if user has insufficient balance
    RAISE EXCEPTION 'Insufficient balance in user wallet.';
END IF;

ELSE
-- Throw an error if user does not exist
RAISE EXCEPTION 'User does not exist.';
END IF;

COMMIT;



----- Selling of Stocks -----

-- BEGIN TRANSACTION;

-- -- Check if user exists
-- IF EXISTS (SELECT * FROM users WHERE username = '<username>') THEN
--     -- Check user's portfolio stock volume
--     SELECT stockvolume FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';
--     -- Check if user has sufficient stock volume
--     IF ((SELECT stockvolume FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>') >= <stock_volume>) THEN
--         -- Update user's portfolio stock volume
--         UPDATE Portfolio SET stockvolume = stockvolume - <stock_volume>
--         WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';

--         -- Sell stock to company table
--         INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date)
--         VALUES ('<stock_name>', <customer_id>, '<exchange_broker_id>', <stock_volume>, <stock_price>, '<transaction_date>');

--         -- Update user's wallet balancei
--         UPDATE users SET wallet = wallet + (<stock_volume> * <stock_price>) WHERE username = '<username>';

--     ELSE
--         -- Throw an error if user has insufficient stock volume
--         RAISE EXCEPTION 'Insufficient stock volume in user portfolio.';
--     END IF;

-- ELSE
--     -- Throw an error if user does not exist
--     RAISE EXCEPTION 'User does not exist.';
-- END IF;

-- COMMIT;


BEGIN TRANSACTION;

-- Check if user exists
IF EXISTS (SELECT * FROM users WHERE username = '<username>') THEN
    -- Check user's portfolio stock volume
    SELECT stockvolume FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';
    -- Check if user has sufficient stock volume
    IF ((SELECT stockvolume FROM Portfolio WHERE customerID = <customer_id> AND Stock_name = '<stock_name>') >= <stock_volume>) THEN
        -- Update user's portfolio stock volume
        UPDATE Portfolio SET stockvolume = stockvolume - <stock_volume>
        WHERE customerID = <customer_id> AND Stock_name = '<stock_name>';

        -- Sell stock to company table
        INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date)
        VALUES ('<stock_name>', <customer_id>, '<exchange_broker_id>', <stock_volume>, <stock_price>, '<transaction_date>');

        -- Update user's wallet balance
        UPDATE users SET wallet = wallet + (<stock_volume> * <stock_price>) WHERE username = '<username>';

    ELSE
        -- Throw an error if user has insufficient stock volume
        RAISE EXCEPTION 'Insufficient stock volume in user portfolio.';
    END IF;

ELSE
    -- Throw an error if user does not exist
    RAISE EXCEPTION 'User does not exist.';
END IF;

COMMIT;





