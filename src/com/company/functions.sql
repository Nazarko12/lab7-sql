/* ------------- FUNCTIONS ----------------- */

/* 1. Для таблиці Співробітники написати функцію, яка буде шукати AVG стовпця Трудовий стаж .
Потім зробити вибірку даних (SELECT) більших за середнє значення, використовуючи дану функцію. */

DROP FUNCTION IF EXISTS get_medium_seniority()
DELIMITER //
CREATE FUNCTION get_medium_seniority()
  RETURNS FLOAT
BEGIN
    RETURN (SELECT AVG(seniority) FROM employee);
END //
DELIMITER ;

SELECT * FROM employee WHERE seniority > get_medium_seniority();


/* 2. Написати функцію, яка витягує за ключем між таблицями Вулиця та Аптечна установа значення поля Назва вулиці .
Потім зробити вибірку усіх даних (SELECT) з таблиці Аптечна установа, використовуючи дану функцію. */

DROP FUNCTION IF EXISTS get_street_of_pharmace_by_pharmacy_id
DELIMITER //
CREATE FUNCTION get_street_of_pharmacy_by_pharmacy_id(pharmacy_id INT)
  RETURNS VARCHAR(45)
BEGIN
  DECLARE name_of_the_street VARCHAR(45);
    SELECT street_of_pharmacy INTO name_of_the_street FROM pharmacy WHERE id = street_of_pharmacy_id;
    RETURN (SELECT name FROM name_of_the_street WHERE id=street_of_pharmacy);
END //
DELIMITER ;

Select *, get_street_of_pharmace_by_pharmacy_id(employee.id) FROM employee;
