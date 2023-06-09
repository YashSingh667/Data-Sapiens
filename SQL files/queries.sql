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

-- get exchangebrokerid
select temp.exchangebrokerid
from stockexchange
join (
    select * from users
    join brokert
    on brokert.brokerid = users.brokerid and users.customerid = 6
) as temp
on temp.exchangebrokerid = stockexchange.exchangebrokerid and stockexchange.exchange_name = 'nasdaq';

-- create Index 
CREATE INDEX idx_company_cdate_exchange_name ON company (cdate, Exchange_name);

-- create buy procedure
CREATE OR REPLACE PROCEDURE buy_stock(
    user_id INTEGER,
    cost NUMERIC,
    stockName VARCHAR(50),
    quantity INTEGER,
    ex_brok_id VARCHAR(50),
    stock_price NUMERIC,
    date_ DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE customerid = user_id) THEN 
        IF (SELECT wallet FROM users WHERE customerid = user_id) >= cost THEN 
            IF EXISTS (SELECT * FROM Portfolio WHERE customerID = user_id AND Stock_name = stockName) THEN 
                UPDATE Portfolio SET stockvolume = stockvolume + quantity WHERE customerID = user_id AND Stock_name = stockName;
            ELSE 
                INSERT INTO Portfolio (stockvolume, exchangebrokerID, Stock_name, customerID) VALUES (quantity, ex_brok_id, stockName, user_id);
            END IF;
            INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date) VALUES (stockName, user_id, ex_brok_id, quantity,(-1)*cost, date_);
            UPDATE users SET wallet = wallet - cost WHERE customerid = user_id;
        ELSE 
            RAISE EXCEPTION 'Insufficient balance in user wallet.';
        END IF;
    ELSE 
        RAISE EXCEPTION 'User does not exist.';
    END IF;
END;
$$;




-- sell procedure
CREATE OR REPLACE PROCEDURE sell_stock(IN user_id integer,IN cost numeric, IN stockName varchar(50), IN quantity integer, IN ex_brok_id VARCHAR(50), IN stock_price numeric, IN date_ date)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT * FROM users WHERE customerid = user_id) THEN
        IF (SELECT stockvolume FROM Portfolio WHERE customerID = user_id AND Stock_name = stockName) >= quantity THEN
            UPDATE Portfolio SET stockvolume = stockvolume - quantity WHERE customerID = user_id AND Stock_name = stockName;
            INSERT INTO Orderbook (Stock_name, customerID, exchangebrokerID, stockvolume, stockprice, t_date) VALUES (stockName, user_id, ex_brok_id, quantity, cost, date_);
            UPDATE users SET wallet = wallet + cost WHERE customerid = user_id;
        ELSE
            RAISE EXCEPTION 'Insufficient stock volume in user portfolio.';
        END IF;
    ELSE
        RAISE EXCEPTION 'User does not exist.';
    END IF;
END;
$$;

