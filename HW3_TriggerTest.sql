--Hiren Patel, Homework 3 Part 1

UPDATE EMPLOYEE SET EMPLOYEEID = 112227, FIRSTNAME = 'Dwight', LASTNAME = 'Schrute',
ADDR_LINE1 = '1725 Slough Avenue', ADDR_LINE2 = 'Suite 200', CITY = 'Scranton', STATE = 'Pennsylvania', ZIP = '18505'

WHERE EMPLOYEEID IS NULL;


INSERT INTO EMPLOYEE VALUES(112227, 'Dwight', 'Schrute', '1725 Slough Avenue', 'Suite 200', 'Scranton', 'PA' ,'18505');


DELETE FROM EMPLOYEE WHERE EMPLOYEEID = 112227;