CREATE DATABASE IF NOT EXISTS transaction_test;  
USE transaction_test;  
DROP TABLE IF EXISTS customer_accounts;  	  
DROP TABLE IF EXISTS customers;  
	  
CREATE TABLE customers(  
id int AUTO_INCREMENT PRIMARY KEY ,  
name VARCHAR(255) NOT NULL ,  
address VARCHAR(255)  
)ENGINE=InnoDB;  
	  
CREATE TABLE IF NOT EXISTS customer_accounts(  
id INT AUTO_INCREMENT PRIMARY KEY ,  
amount DOUBLE NOT NULL ,  
currency VARCHAR(10),  
customer_id INT NOT NULL ,  
CONSTRAINT FOREIGN KEY (customer_id)   
REFERENCES customers(id)   
ON DELETE RESTRICT ON UPDATE CASCADE  
)ENGINE=InnoDB;  
	  
INSERT INTO `transaction_test`.`customers` (`name`, `address`)   
VALUES ('Ivan Petrov Iordanov', 'Sofia, Krasno selo 1000');  
INSERT INTO `transaction_test`.`customers` (`name`, `address`)   
VALUES ('Stoyan Pavlov Pavlov', 'Sofia, Liuylin 7, bl. 34');  
INSERT INTO `transaction_test`.`customers` (`name`, `address`)   
VALUES ('Iliya Mladenov Mladenov', 'Sofia, Nadezhda 2, bl 33');  
	  
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`)   
VALUES ('5000', 'BGN', '1');  
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`)   
VALUES ('10850', 'EUR', '1');  
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`)   
VALUES ('1450000', 'BGN', '2');  
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`)   
VALUES ('17850', 'EUR', '2');  
    

#5
DELIMITER //
DROP PROCEDURE IF EXISTS transfer_money;
CREATE PROCEDURE transfer_money(IN from_acc_id INT, IN to_acc_id INT, IN transferAmount DECIMAL(10,2))
BEGIN
    DECLARE from_acc_balance DECIMAL(10, 2);
    DECLARE to_acc_balance DECIMAL(10, 2);

START TRANSACTION;

SELECT amount INTO from_acc_balance FROM customer_accounts 
WHERE id = from_acc_id FOR UPDATE;
SELECT amount INTO to_acc_balance FROM customer_accounts 
WHERE id = to_acc_id FOR UPDATE;

IF from_acc_balance < transferAmount THEN
   SET @error_message = 'Insufficient funds in transfer account.';
     ELSE
        UPDATE customer_accounts SET amount = amount - transferAmount WHERE id = from_acc_id;
           IF ROW_COUNT() = 0 THEN
              SET @error_message = 'Transaction failed.';
              ROLLBACK;
                SELECT @error_message;
           ELSE
                UPDATE customer_accounts SET amount = amount + transferAmount WHERE id = to_acc_id;
           IF ROW_COUNT() = 0 THEN
                SET @error_message = 'Transaction failed.';
                ROLLBACK;
                SELECT @error_message;
           ELSE
                COMMIT;
                SELECT 'The transaction was successful.';
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;

CALL transfer_money(1, 2, 5000);


#6
DELIMITER //
DROP PROCEDURE IF EXISTS transfer_money;
CREATE PROCEDURE transfer_money(
    IN sender_name VARCHAR(255),
    IN recipient_name VARCHAR(255),
    IN transferAmount DOUBLE,
    IN tempCurrency VARCHAR(10)
)
BEGIN
    DECLARE sender_id, recipient_id, affected_rows INT;
    DECLARE sender_balance, recipient_balance DOUBLE;
    
SELECT id INTO sender_id FROM customers 
WHERE name = sender_name;
SELECT id INTO recipient_id FROM customers 
WHERE name = recipient_name;
    
SELECT amount INTO sender_balance FROM customer_accounts 
WHERE customer_id = sender_id AND currency = tempCurrency;
SELECT amount INTO recipient_balance FROM customer_accounts 
WHERE customer_id = recipient_id AND currency = tempCurrency;
    
IF sender_balance < transferAmount THEN
      SELECT 'Not enough funds' AS error_message;
ELSE
      UPDATE customer_accounts SET amount = amount - transferAmount WHERE customer_id = sender_id AND currency = tempCurrency;
      SET affected_rows = ROW_COUNT();
      IF affected_rows = 0 THEN
            SELECT 'Transaction failed' AS error_message;
      ELSE
            UPDATE customer_accounts SET amount = amount + transferAmount WHERE customer_id = recipient_id AND currency = tempCurrency;
            SET affected_rows = ROW_COUNT();
            IF affected_rows = 0 THEN
                SELECT 'Transaction failed' AS error_message;
            ELSE
                SELECT 'Transaction successful' AS status_message;
            END IF;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL transfer_money('Ivan Petrov Iordanov', 'Stoyan Pavlov Pavlov', 1000.00, 'BGN');
