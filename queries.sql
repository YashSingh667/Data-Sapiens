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



--- Buying of stock ---

BEGIN TRANSACTION;

-- Check if user exists
SELECT * FROM users WHERE username = '<username>';

-- Check user's wallet balance
SELECT wallet FROM users WHERE username = '<username>';

-- Check if user has sufficient balance
IF ((SELECT wallet FROM users WHERE username = '<username>') >= (<stock_volume> * <stock_price>)) THEN
    -- Buy stock from company table
    INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date)
    VALUES ('<stock_name>', <customer_id>, '<exchange_broker_id>', <stock_volume>, <stock_price>, '<transaction_date>');

    -- Update user's wallet balance
    UPDATE users SET wallet = wallet - (<stock_volume> * <stock_price>) WHERE username = '<username>';

    -- Update user's portfolio
    INSERT INTO Portfolio (stockvolume, exchangebrokerID, Stock_name, customerID)
    VALUES (<stock_volume>, '<exchange_broker_id>', '<stock_name>', <customer_id>)
    ON DUPLICATE KEY UPDATE stockvolume = stockvolume + <stock_volume>;

ELSE
    -- Throw an error if user has insufficient balance
    RAISE EXCEPTION 'Insufficient balance in user wallet.';
END IF;

COMMIT;
