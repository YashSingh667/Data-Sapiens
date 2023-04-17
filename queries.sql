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



