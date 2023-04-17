-- registration form --
INSERT INTO users (fullname, dob, email, username, u_password, brokerID, customerID, wallet)
VALUES ('', '', '', '', '', '', '');

-- profile --
SELECT fullname, dob, email, username, brokerID, customerID, wallet FROM users WHERE username = '"+str(username)"';


