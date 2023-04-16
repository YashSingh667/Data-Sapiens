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


DROP TABLE IF EXISTS User;
CREATE TABLE User ( 
    customerID varchar(50) NOT NULL,
    u_password varchar(50) NOT NULL,
    broker_id varchar(50) NOT NULL,
    username varchar(50) NOT NULL,
    dob DATE NOT NULL,
    fullname varchar(50) NOT NULL,
    PRIMARY KEY (customerID),
    CONSTRAINT fk_brokerID_User
    FOREIGN KEY (brokerID)
    REFERENCES Broker_details(brokerID)

);

DROP TABLE IF EXISTS BrokerT;
CREATE TABLE BrokerT ( 
    brokerID varchar(50) NOT NULL,
    exchangebrokerID varchar(50) DEFAULT NULL,
    PRIMARY KEY (exchangebrokerID),
    CONSTRAINT fk_brokerID_BrokerT
    FOREIGN KEY (brokerID)
    REFERENCES Broker_details(brokerID)

);

DROP TABLE IF EXISTS stockexchange;
CREATE TABLE stockexchange (
    exchangename varchar(50) NOT NULL,
    exchangebrokerID varchar(50) NOT NULL,
    PRIMARY KEY(exchangebrokerID),
    CONSTRAINT fk_exchangebrokerID_stockexchange
    FOREIGN KEY (exchangebrokerID)
    REFERENCES BrokerT

);

DROP TABLE IF EXISTS company;
CREATE TABLE company (
    companyID varchar(50) NOT NULL,
    exchangename varchar(50) NOT NULL,
    cdate DATE NOT NULL,
    highprice FLOAT DEFAULT NULL,
    lowprice FLOAT DEFAULT NULL,
    PRIMARY KEY (companyID, exchangename, cdate),
    CONSTRAINT fk_exchangename_company
    FOREIGN KEY (exchangename)
    REFERENCES stockexchange
);

DROP TABLE IF EXISTS Orderbook;
CREATE TABLE Orderbook (
    transactionID varchar(50) NOT NULL,

);


