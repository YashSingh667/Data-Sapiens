BEGIN TRANSACTION;

-- DROP TABLE IF EXISTS Transactions;
-- CREATE TABLE Transactions (
--     transactionID SERIAL PRIMARY KEY,
--     t_date DATE NOT NULL,
--     PRIMARY KEY (transactionID)

-- );

DROP TABLE IF EXISTS Broker_details;
CREATE TABLE Broker_details ( 
    brokerID varchar(50) NOT NULL,
    broker_name varchar(50) DEFAULT NULL,
    PRIMARY KEY (brokerID)

);


DROP TABLE IF EXISTS users;
CREATE TABLE users ( 
    customerID SERIAL PRIMARY KEY,
    u_password varchar(50) NOT NULL,
    brokerID varchar(50) NOT NULL,
    username varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    dob DATE NOT NULL,
    fullname varchar(50) NOT NULL,
    user_role VARCHAR(50) NOT NULL DEFAULT 'user',
    wallet FLOAT DEFAULT 0.0,    
    CONSTRAINT fk_brokerID_users
    FOREIGN KEY (brokerID)
    REFERENCES Broker_details(brokerID)

);

DROP TABLE IF EXISTS BrokerT;
CREATE TABLE BrokerT ( 
    brokerID varchar(50) NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    PRIMARY KEY (exchangebrokerID),
    CONSTRAINT fk_brokerID_BrokerT
    FOREIGN KEY (brokerID)
    REFERENCES Broker_details(brokerID)

);

DROP TABLE IF EXISTS company;
CREATE TABLE company (
    
    Stock_name varchar(50) NOT NULL,
    Exchange_name varchar(50) NOT NULL,
    cdate DATE NOT NULL,
    High FLOAT DEFAULT NULL,
    Low FLOAT DEFAULT NULL,
    Open FLOAT DEFAULT NULL,
    Close FLOAT DEFAULT NULL,
    PRIMARY KEY (Stock_name, Exchange_name, cdate)
);



DROP TABLE IF EXISTS stockexchange;
CREATE TABLE stockexchange (
    Exchange_name varchar(50) NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    PRIMARY KEY(exchangebrokerID),
    CONSTRAINT fk_exchangebrokerID_stockexchange
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT(exchangebrokerID)
    -- CONSTRAINT fk_exchangename_company
    -- FOREIGN KEY (Exchange_name)
    -- REFERENCES company(Exchange_name)

);







DROP TABLE IF EXISTS Orderbook;
CREATE TABLE Orderbook (
    transactionID SERIAL PRIMARY KEY,
    Stock_name varchar(50) NOT NULL,
    customerID INT NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    stockvolume int NOT NULL,
    stockprice FLOAT NOT NULL,
    t_date DATE NOT NULL,
    -- CONSTRAINT fk_Stock_name_orderbook
    -- FOREIGN KEY (Stock_name)
    -- REFERENCES company(Stock_name),
    CONSTRAINT fk_customerID_orderbook
    FOREIGN KEY (customerID)
    REFERENCES users(customerID),
    CONSTRAINT fk_exchangebrokerID_orderbook
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT(exchangebrokerID)

);


DROP TABLE IF EXISTS Portfolio;
CREATE TABLE Portfolio (
    stockvolume int NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    Stock_name varchar(50) NOT NULL,
    customerID INT NOT NULL,
    PRIMARY KEY(exchangebrokerID, Stock_name, customerID),
    -- CONSTRAINT fk_Stock_name_Portfolio
    -- FOREIGN KEY (Stock_name)
    -- REFERENCES company(Stock_name),
    CONSTRAINT fk_customerID_Portfolio
    FOREIGN KEY (customerID)
    REFERENCES users(customerID),
    CONSTRAINT fk_exchangebrokerID_Portfolio
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT(exchangebrokerID)

);

END TRANSACTION;



