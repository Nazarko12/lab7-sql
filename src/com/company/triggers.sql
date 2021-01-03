/ ------------- TRIGGERS ----------------- /



/* 1. Забезпечити цілісність значень для структури БД. */

drop trigger if exists pharmacy_integrity_delete;

delimiter !!
create trigger pharmacy_integrity_delete
before delete
on pharmacy for each row
begin
 delete  pharmacy_has_list_of_medicines from  pharmacy_has_list_of_medicines where pharmacy_has_list_of_medicines.pharmacy_id=old.id;
 delete  street_of_pharmacy from street_of_pharmacy where street_of_pharmacy.id=old.street_of_pharmacy_id;
 end !!
 Delimiter ;

drop trigger if exists pharmacy_integrity_update;

delimiter !!
create trigger pharmacy_integrity_update
before update
on pharmacy for each row
begin
if old.street_of_pharmacy_id!=new.street_of_pharmacy.id
then signal sqlstate "45000"
 set message_text = "Your can't update village id";
 end if;
 end !!
 Delimiter ;

 /*The first constraint*/

drop trigger if exists employee_integrity_insert;

delimiter !!
create trigger employee_integrity_insert
before insert
on employee for each row
begin
if (select  distinct id from pharmacy where pharmacy.id=new.pharmacy_id) is null
then signal sqlstate "45000"
 set message_text = "Your can't insert this row this pharmacy don't exist";
 end if;
 end !!
 Delimiter ;

 drop trigger if exists employee_integrity_update;

delimiter !!
create trigger employee_integrity_update
before update
on employee for each row
begin
if (select  distinct id from pharmacy where pharmacy.id=new.pharmacy_id) is null
then signal sqlstate "45000"
 set message_text = "Your can't update this row this pharmacy don't exist";
 end if;
 end !!
 Delimiter ;

 /*The second constraint*/
  drop trigger if exists street_of_pharmacy_integrity_delete;

 delimiter !!
create trigger street_of_pharmacy_integrity_delete
before delete
on street_of_pharmacy for each row
begin
 signal sqlstate "45000"
 set message_text = "Your can't delete this name street of pharmacy";
 end !!
 Delimiter ;


 /*The third constraint*/
 drop trigger if exists pharmacy_integrity_delete;

delimiter !!
create trigger pharmacy_integrity_delete
before delete
on pharmacy for each row
begin
delete from pharmacy where street_of_pharmacy.pharmacy_id=old.id;
delete from street_of_pharmacy where street_of_pharmacy.pharmacy_id = old.id;
end !!
Delimiter ;

 /*The fourth constraint*/
drop trigger if exists pharmacy_has_list_of_medicines_integrity_insert;

 delimiter !!
create trigger pharmacy_has_list_of_medicines_integrity_insert
before insert
on pharmacy_has_list_of_medicines for each row
begin
if (select distinct id from pharmacy where pharmacy.id=new.pharmacy_id) is Null
then  signal sqlstate "45000"
 set message_text = "Your can't insert this pharmacy_id it not exist";
end if;
if (select distinct id from list_of_medicines where list_of_medicines.id=new.list_of_medicines_id) is Null
then  signal sqlstate "45000"
 set message_text = "Your can't insert this list_of_medicines it not exist";
end if;
end !!
Delimiter ;


 drop trigger if exists pharmacy_has_list_of_medicines_integrity_update;

 delimiter !!
create trigger pharmacy_has_list_of_medicines_integrity_update
before update
on pharmacy_has_list_of_medicines for each row
begin
if old.pharmacy_id!=new.pharmacy_id and (select distinct id from pharmacy where pharmacy.id=new.pharmacy_id) is Null
then  signal sqlstate "45000"
 set message_text = "Your can't update to this pharmacy_id it not exist";
end if;
if old.list_of_medicines_id!=new.list_of_medicines_id and (select distinct id from pharmacy where list_of_medicines.id=new.list_of_medicines_id) is Null
then  signal sqlstate "45000"
 set message_text = "Your can't update to this list_of_medicines it not exist";
end if;
end !!
Delimiter ;

/* 2. 'У полі "Співробітники" → "Ім’я" допускається ввід лише таких імен: 'Василь', 'Іван', 'Галина' та 'Олександра'. */

DROP TRIGGER IF EXISTS employee_name_insert_trigger;
DELIMITER //
CREATE TRIGGER employee_name_insert_trigger BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
   IF new.first_name NOT IN ('Vasyl', 'Ivan', 'Galina', 'Oleksandra') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid name: should be Vasyl or Ivan or Galina or Oleksandra';
   END IF;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS employee_name_update_trigger;
DELIMITER //
CREATE TRIGGER employee_name_update_trigger BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
   IF new.first_name NOT IN ('Vasyl', 'Ivan', 'Galina', 'Oleksandra') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid name: should be Vasyl or Ivan or Galina or Oleksandra';
   END IF;
END;
//
DELIMITER ;


/* 3. Для Співробітники → Серія та номер паспорту забезпечити
формат вводу: 2 букви + пробіл + 6 цифр ; */

DROP TRIGGER IF EXISTS employee_passport_insert_trigger;
DELIMITER //
CREATE TRIGGER employee_passport_insert_trigger BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
   IF new.passport_number not rLIKE '^[A-Z]{2}\\s[0-9]{6}$' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid passport_no: should be 2 letters, space, 6 numbers';
   END IF;
END;
//
DELIMITER ;

DROP TRIGGER employee_passport_update_trigger;
DELIMITER //
CREATE TRIGGER employee_passport_update_trigger BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
   IF new.passport_number not rLIKE '^[A-Z]{2}\\s[0-9]{6}$' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid passport_no: should be 2 letters, space, 6 numbers';
   END IF;
END;
//
DELIMITER ;


/* 4. Заборонити будь-яку модифікацію даних в таблиці Аптечна
установа. */

DROP TRIGGER IF EXISTS before_delete_street_of_pharmacy;
DELIMITER //
CREATE TRIGGER before_delete_street_of_pharmacy
BEFORE DELETE ON street_of_pharmacy
FOR EACH ROW BEGIN
 SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = "You can't delete street of pharmacy";
END//
DELIMITER ;



