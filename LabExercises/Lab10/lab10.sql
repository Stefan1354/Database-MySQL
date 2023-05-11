DROP DATABASE IF EXISTS `cableCompany`;
CREATE DATABASE `cableCompany`;
USE `cableCompany`;

CREATE TABLE `cableCompany`.`customers` (
	`customerID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`firstName` VARCHAR( 55 ) NOT NULL ,
	`middleName` VARCHAR( 55 ) NOT NULL ,
	`lastName` VARCHAR( 55 ) NOT NULL ,
	`email` VARCHAR( 55 ) NULL , 
	`phone` VARCHAR( 20 ) NOT NULL , 
	`address` VARCHAR( 255 ) NOT NULL ,
	PRIMARY KEY ( `customerID` )
) ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`accounts` (
	`accountID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
	`amount` DOUBLE NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers` ( `customerID` )
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`plans` (
	`planID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(32) NOT NULL,
	`monthly_fee` DOUBLE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`payments`(
	`paymentID` INT AUTO_INCREMENT PRIMARY KEY ,
	`paymentAmount` DOUBLE NOT NULL ,
	`month` TINYINT NOT NULL ,
	`year` YEAR NOT NULL ,
	`dateOfPayment` DATETIME NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,		
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	CONSTRAINT FOREIGN KEY ( `plan_id` ) 
		REFERENCES `cableCompany`.`plans` ( `planID` ) ,
	UNIQUE KEY ( `customer_id`, `plan_id`,`month`,`year` )
)ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`debtors`(
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,
	`debt_amount` DOUBLE NOT NULL ,
	FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	FOREIGN KEY ( `plan_id` )
		REFERENCES `cableCompany`.`plans`( `planID` ) ,
	PRIMARY KEY ( `customer_id`, `plan_id` )
) ENGINE = InnoDB;


INSERT INTO `customers` (`firstName`, `middleName`, `lastName`, `email`, `phone`, `address`)
VALUES 
    ('John', 'A.', 'Doe', 'johndoe@example.com', '555-1234', '123 Main St.'),
    ('Jane', 'B.', 'Doe', 'janedoe@example.com', '555-5678', '456 Oak Ave.'),
    ('Robert', 'C.', 'Johnson', 'robertj@example.com', '555-2468', '789 Maple Ln.'),
    ('Emily', 'D.', 'Smith', 'emilysmith@example.com', '555-1357', '246 Elm St.'),
    ('David', 'E.', 'Brown', 'davidbrown@example.com', '555-3691', '135 Cedar Ave.');


INSERT INTO `accounts` (`amount`, `customer_id`)
VALUES 
    (100.00, 1),
    (50.00, 2),
    (75.00, 3),
    (200.00, 4),
    (150.00, 5);


INSERT INTO `plans` (`name`, `monthly_fee`)
VALUES 
    ('Basic', 29.99),
    ('Standard', 49.99),
    ('Premium', 79.99),
    ('Ultimate', 99.99),
    ('Platinum', 149.99);


INSERT INTO `payments` (`paymentAmount`, `month`, `year`, `dateOfPayment`, `customer_id`, `plan_id`)
VALUES 
    (29.99, 1, 2022, '2022-01-01 00:00:00', 1, 1),
    (49.99, 2, 2022, '2022-02-01 00:00:00', 2, 2),
    (79.99, 3, 2022, '2022-03-01 00:00:00', 3, 3),
    (99.99, 4, 2022, '2022-04-01 00:00:00', 4, 4),
    (149.99, 5, 2022, '2022-05-01 00:00:00', 5, 5);

-- Вмъкване на тестови данни за таблица debtors
INSERT INTO `debtors` (`customer_id`, `plan_id`, `debt_amount`)
VALUES 
    (1, 1, 50.00),
    (2, 2, 25.00),
    (3, 3, 37.50),
    (4, 4, 100.00),
    (5, 5, 75.00);



#1
/*DELIMITER //

CREATE PROCEDURE makeMonthlyPayment(IN customerID INT, IN paymentAmount DOUBLE, OUT success BIT)
BEGIN
    DECLARE monthlyFee DOUBLE;
    DECLARE accountAmount DOUBLE;
    DECLARE debtAmount DOUBLE;
    */
    -- Намираме месечната такса на клиента
    /*SELECT monthly_fee INTO monthlyFee
    FROM plans
    WHERE planID = (
        SELECT plan_id
        FROM payments
        WHERE customer_id = customerID
        ORDER BY year DESC, month DESC
        LIMIT 1
    );*/
    
    /*SELECT plans.monthly_fee INTO monthlyFee
	FROM plans
	JOIN payments ON plans.planID = payments.plan_id
	JOIN customers ON customers.customer_id = payments.customer_id
	WHERE customers.customer_id = customerID
	ORDER BY payments.year DESC, payments.month DESC
	LIMIT 1;

    
    
    SELECT amount INTO accountAmount
    FROM accounts
    WHERE customer_id = customerID;
    
    IF accountAmount < monthlyFee THEN
        SET success = 0;
        SELECT CONCAT('Not enough funds. Required: ', monthlyFee) AS 'errorMessage';
    END IF;
    
   
    UPDATE accounts
    SET amount = amount - monthlyFee
    WHERE customer_id = customerID;
    
    
    INSERT INTO payments (paymentAmount, month, year, dateOfPayment, customer_id, plan_id)
    VALUES (paymentAmount, MONTH(NOW()), YEAR(NOW()), NOW(), customerID, (
        SELECT plan_id
        FROM payments
        WHERE customer_id = customerID
        ORDER BY year DESC, month DESC
        LIMIT 1
    ));
    
END //

DELIMITER ;*/


#2
/*DELIMITER $$
CREATE PROCEDURE makePayments()
BEGIN
    DECLARE customerID INT;
    DECLARE paymentAmount DECIMAL(10,2);
    DECLARE planID INT;
    DECLARE monthlyFee DECIMAL(10,2);
    DECLARE debt DECIMAL(10,2);
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE tempcur CURSOR FOR 
    SELECT customer_id, payment_amount, plan_id FROM payments;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    START TRANSACTION;
    
    OPEN tempcur;
    
    payment_loop: LOOP
        FETCH tempcur INTO customerID, paymentAmount, planID;
        
        IF done THEN
            LEAVE payment_loop;
        END IF;
        
        SELECT monthly_fee INTO monthlyFee
        FROM plans
        WHERE planID = (
            SELECT plan_id
            FROM payments
            WHERE customer_id = customerID
        );
        
        IF paymentAmount >= monthlyFee THEN
            UPDATE customers
            SET balance = balance - monthlyFee
            WHERE customer_id = customerID;
        ELSE
            SET debt = monthlyFee - paymentAmount;
            INSERT INTO debts(customer_id, amount) VALUES (customerID, debt);
        END IF;
        
        UPDATE payments
        SET paid = 1
        WHERE customer_id = customerID;
    END LOOP;
    
    CLOSE cur;
    
    COMMIT;
    
END $$
DELIMITER ;*/

#3
/*CREATE EVENT nameCalled
ON SCHEDULE EVERY 1 MONTH
STARTS '2023-05-28'
DO
CALL makeMonthlyPayment();
*/

#4
/*CREATE VIEW getNames AS
SELECT customers.firstName, customers.middleName, customers.lastName, payments.dateOfPayment, plans.name, debtors.debt_amount
FROM customers JOIN payments ON customers.customerID = payments.customer_id
JOIN plans ON payments.plan_id = plans.planID
JOIN debtors ON plans.planID = debtors.plan_id;
*/

#5
/*DELIMITER $$
CREATE TRIGGER addNames
AFTER INSERT ON plans
FOR EACH ROW
BEGIN
	IF NEW.monthly_fee < 10 THEN
		SIGNAL SQLSTATE 'The monthly fee must be at least 10 lev';
	END IF;
END;
$$
DELIMITER ;
    */


#6
/*DELIMITER $$
CREATE TRIGGER check_account_balance 
AFTER INSERT ON accounts 
FOR EACH ROW 
BEGIN 
    DECLARE debt DECIMAL(10,2);
    SELECT SUM(debt_amount) INTO debt
    FROM debtors
    WHERE customer_id = NEW.customer_id;

    IF NEW.amount < debt THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR';
    END IF;
END;
$$
DELIMITER ;

INSERT INTO `accounts` (`amount`, `customer_id`)
VALUES (140, 4);

SELECT * FROM debtors;
*/

#7
/*DELIMITER $$
CREATE PROCEDURE getAllInformation(IN client_name VARCHAR(255))
BEGIN
	SELECT customers.customerID, customers.firstName, customers.middleName, customers.lastName, customers.email, customers.phone, customers.address,
    payments.paymentID, payments.paymentAmount, payments.month, payments.year, payments.dateOfPayment
    FROM customers JOIN payments ON
    customers.customerID = payments.customer_id;
END;
$$
DELIMITER ;

CALL getAllInformation('some name');
*/

