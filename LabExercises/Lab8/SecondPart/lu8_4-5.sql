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


#4
/*DELIMITER |
DROP PROCEDURE IF EXISTS converter;
CREATE PROCEDURE converter (IN amount DOUBLE, IN currency VARCHAR(5), OUT returnAmount DOUBLE)
BEGIN
	IF (currency = "BGN")
    THEN
		SET returnAmount = amount * 0.51;
	ELSE IF (currency = "EUR")
	THEN	
		SET returnAmount = amount * 1.94;
	END IF;
    END IF;
END;
|
DELIMITER ;

CALL converter('1000.00', 'BGN', @returnAmount)*/


#5
DROP PROCEDURE IF EXISTS transactionIds;
DELIMITER |
CREATE PROCEDURE transactionIds(IN firstId INT, IN secondId INT, IN transferAmount DOUBLE)
BEGIN
	DECLARE firstCurrency VARCHAR(5);
    DECLARE secondCurrency VARCHAR(5);
    
    SELECT currency
    INTO firstCurrency
    FROM customer_accounts
    WHERE id = firstId;
    
    SELECT currency
    INTO secondCurrency
    FROM customer_accounts
    WHERE id = secondId;
    
    IF ((firstCurrency != 'BGN' AND firstCurrency != 'EUR') AND (secondCurrency != 'BGN' AND secondCurrency != 'EUR'))
    THEN
		SELECT "Currencies must be either 'BGN' or 'EUR'!";
	ELSE
		IF ((SELECT amount
			FROM customer_accounts
			WHERE id = firstId) - transferAmount < 0)
		THEN
			SELECT "Not enough money to withdraw!";
		ELSE
			START TRANSACTION;
				UPDATE customer_accounts
                SET amount = amount - transferAmount
                WHERE id = firstId;
                
                IF (ROW_COUNT() = 0)
                THEN
					SELECT "Transaction couldn't execute!";
                    ROLLBACK;
				ELSE
					IF (firstCurrency != secondCurrency)
                    THEN
						SET @returnAmount = 0;
                        CALL converter(transferAmount, firstCurrency, @returnAmount);
					ELSE
						SET @returnAmount = transferAmount;
					END IF;
                    
                    UPDATE customer_accounts
                    SET amount = amount + @returnAmount
                    WHERE id = secondId;
                    
                    IF (ROW_COUNT() = 0)
                    THEN
						SELECT "Transaction couldn't execute!";
                        ROLLBACK;
					ELSE
						COMMIT;
					END IF;
				END IF;
			END IF;
		END IF;
END;
|
DELIMITER ;