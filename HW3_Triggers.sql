--Hiren Patel, Homework 3 Part 1
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_EMPLOYEE_ID
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW 
DECLARE
    maximumID INTEGER;
    rowCount NUMBER;
BEGIN
    SELECT COUNT(EMPLOYEEID) INTO rowCount
    FROM Employee;
    SELECT MAX(EMPLOYEEID) INTO maximumID
    FROM Employee;
    
    IF (rowCount != 0)THEN
        UPDATE Employee 
        SET EMPLOYEEID = maximumID + 1;
        
    ELSIF (rowCount = 0)THEN
       UPDATE Employee
       SET EMPLOYEEID = 1;
      
    END IF;
END;

--------------------------------------------------------------------------------------------------------------------------------

--Hiren Patel, Homework 3 Part 1

CREATE OR REPLACE TRIGGER TRG_EMPLOYEE_LOG
AFTER INSERT OR DELETE OR UPDATE ON EMPLOYEE
FOR EACH ROW 
BEGIN
    IF (INSERTING) THEN
        INSERT INTO Employee_Log VALUES (:NEW.EMPLOYEEID, USER, 'I', SYSDATE,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        :NEW.FIRSTNAME, :NEW.LASTNAME, :NEW.ADDR_LINE1, :NEW.ADDR_LINE2, 
        :NEW.CITY, :NEW.STATE, :NEW.ZIP);
    ELSIF (DELETING) THEN
        INSERT INTO Employee_Log VALUES (:OLD.EMPLOYEEID, USER, 'D', SYSDATE,
        :OLD.FIRSTNAME, :OLD.LASTNAME, :OLD.ADDR_LINE1, :OLD.ADDR_LINE2,
        :OLD.CITY, :OLD.STATE, :OLD.ZIP,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    ELSIF (UPDATING) THEN
        INSERT INTO Employee_log VALUES (:OLD.EMPLOYEEID, USER, 'U', SYSDATE,
        :OLD.FIRSTNAME, :OLD.LASTNAME, :OLD.ADDR_LINE1, :OLD.ADDR_LINE2,
        :OLD.CITY, :OLD.STATE, :OLD.ZIP,
        :NEW.FIRSTNAME, :NEW.LASTNAME, :NEW.ADDR_LINE1, :NEW.ADDR_LINE2, 
        :NEW.CITY, :NEW.STATE, :NEW.ZIP);
    END IF;
END;