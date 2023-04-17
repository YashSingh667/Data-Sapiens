BEGIN TRANSACTION;

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    transactionID varchar(50) NOT NULL,
    t_date DATE NOT NULL,
    PRIMARY KEY (transactionID)

);

DROP TABLE IF EXISTS Broker_details;
CREATE TABLE Broker_details ( 
    brokerID varchar(50) NOT NULL,
    broker_name varchar(50) DEFAULT NULL,
    PRIMARY KEY (brokerID)

);


DROP TABLE IF EXISTS users;
CREATE TABLE users ( 
    customerID varchar(50) NOT NULL,
    u_password varchar(50) NOT NULL,
    brokerID varchar(50) NOT NULL,
    usersname varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    dob DATE NOT NULL,
    fullname varchar(50) NOT NULL,
    PRIMARY KEY (customerID),
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
    companyID varchar(50) NOT NULL,
    exchangename varchar(50) NOT NULL,
    cdate DATE NOT NULL,
    highprice FLOAT DEFAULT NULL,
    lowprice FLOAT DEFAULT NULL,
    PRIMARY KEY (companyID, exchangename, cdate)
);



DROP TABLE IF EXISTS stockexchange;
CREATE TABLE stockexchange (
    exchangename varchar(50) NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    PRIMARY KEY(exchangebrokerID),
    CONSTRAINT fk_exchangebrokerID_stockexchange
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT(exchangebrokerID)
    -- CONSTRAINT fk_exchangename_company
    -- FOREIGN KEY (exchangename)
    -- REFERENCES company(exchangename)

);







DROP TABLE IF EXISTS Orderbook;
CREATE TABLE Orderbook (
    transactionID varchar(50) NOT NULL,
    companyID varchar(50) NOT NULL,
    customerID varchar(50) NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    stockvolume int NOT NULL,
    stockprice FLOAT NOT NULL,
    PRIMARY KEY (transactionID),
    CONSTRAINT fk_transactionID_orderbook
    FOREIGN KEY (transactionID)
    REFERENCES Transactions(transactionID),
    -- CONSTRAINT fk_companyID_orderbook
    -- FOREIGN KEY (companyID)
    -- REFERENCES company(companyID),
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
    companyID varchar(50) NOT NULL,
    customerID varchar(50) NOT NULL,
    PRIMARY KEY(exchangebrokerID, companyID, customerID),
    -- CONSTRAINT fk_companyID_Portfolio
    -- FOREIGN KEY (companyID)
    -- REFERENCES company(companyID),
    CONSTRAINT fk_customerID_Portfolio
    FOREIGN KEY (customerID)
    REFERENCES users(customerID),
    CONSTRAINT fk_exchangebrokerID_Portfolio
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT(exchangebrokerID)

);

END TRANSACTION;



