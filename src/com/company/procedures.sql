/* ------------- PROCEDURES ----------------- */

/* 1. Забезпечити параметризовану вставку нових значень у таблицю "Співробітники" */

DROP PROCEDURE IF EXISTS InsertIntoLogin;

DELIMITER //employee
CREATE PROCEDURE InsertIntoLogin(IN id int, IN first_name VARCHAR(25), IN surname VARCHAR(25), IN last_name VARCHAR(25), IN id_number int,
 IN passport_series int, IN passport_number int, IN seniority int, IN birthday VARCHAR(45))
BEGIN
    INSERT INTO `employee`(`id`,`first_name`, `surname`, `last_name`, `id_number`, `passport_series`, `passport_number`, `seniority`, `birthday`)
    VALUES (employee);
END
//
DELIMITER ;



/* 2. Створити пакет, який вставляє 10 стрічок в таблицю "Вулиця" у форматі < Noname+№> ,
наприклад: Noname5, Noname6, Noname7 і т.д. */

DROP PROCEDURE IF EXISTS insert_into_street_of_local
Delimiter //
CREATE PROCEDURE insert_into_street_of_local()
BEGIN
DECLARE my_index INT DEFAULT 0;
DECLARE my_name VARCHAR(45) DEFAULT 'No name';
DECLARE merged VARCHAR(10);
WHILE my_index < 10 DO
  SET my_index = my_index + 1;
  SET merged = CONCAT(my_name, my_index);
  INSERT INTO mydb.street_of_pharmacy (name_of_the_street) VALUES (merged);
END WHILE;
END //

Delimiter ;

CALL insert_into_street_of_local;


/* 3. Використовуючи курсор, забезпечити динамічне створення
таблиці, що містить стовпці з іменами із таблиці Аптечна
установа. Тип стовпців довільний */

DROP PROCEDURE IF EXISTS IdenticalTableForCopy()
DELIMITER //
CREATE PROCEDURE IdenticalTableForCopy()
BEGIN
	DECLARE done int DEFAULT false;
	DECLARE `name` VARCHAR(45);
	DECLARE pharmacy_cursor CURSOR FOR SELECT DISTINCT `name` FROM `pharmacy`;
    OPEN pharmacy_cursor;
	DROP TABLE IF EXISTS `pharmacy_copy`;
    SET @temp_query=CONCAT("CREATE TABLE `pharmacy_copy` (`id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY);");
	PREPARE myquery FROM @temp_query;
	EXECUTE myquery;
	DEALLOCATE PREPARE myquery;
    label:
    LOOP
		FETCH FROM pharmacy_cursor INTO `name`;
		IF done=true THEN LEAVE label;
		END IF;
		SET @temp_query=CONCAT("ALTER TABLE `pharmacy_copy` ADD ", `name`, " VARCHAR(45);");
		PREPARE myquery FROM @temp_query;
		EXECUTE myquery;
		DEALLOCATE PREPARE myquery;
	END LOOP;
    CLOSE pharmacy_cursor;
END;
//
