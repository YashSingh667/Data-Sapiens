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



