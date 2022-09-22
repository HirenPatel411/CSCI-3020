--Hiren Patel, Project
SET SERVEROUTPUT ON;

DROP TYPE TEMP_CUST_OBJ;
DROP TYPE CUST_ORDERS;

CREATE TYPE CUST_ORDERSOBJ AS OBJECT
(
  CustomerID NUMBER, 
  SerialNumber NUMBER
);

CREATE TYPE TEMP_CUST_TABLEOBJECT IS TABLE OF CUST_ORDERS;

CREATE OR REPLACE PACKAGE BIKESHOP AS 
  PROCEDURE EXTRACT_BICYCLES(OUTPUT_TYPE IN VARCHAR2);
  PROCEDURE EXTRACT_CUSTOMERS(OUTPUT_TYPE IN VARCHAR2);
  FUNCTION  CUSTOMER_BIKES(CUSTOMER_ID IN NUMBER) RETURN TEMP_CUST_TABLEOBJECT;
  PROCEDURE ARCHIVE_CUSTOMER_BIKES;
END BIKESHOP;
/

CREATE OR REPLACE PACKAGE BODY BIKESHOP AS
PROCEDURE EXTRACT_BICYCLES (OUTPUT_TYPE VARCHAR2) AS
CURSOR cursBike IS
SELECT SERIALNUMBER, MODELTYPE, PAINTID, FRAMESIZE, ORDERDATE, STARTDATE,
        SHIPDATE, CONSTRUCTION, LISTPRICE, SALEPRICE, SALESTAX, SALESTATE
    FROM BIKE_SHOP.BICYCLE ORDER BY ORDERDATE ASC;
    
    rowBike cursBike%ROWTYPE;
    ROWCOUNT NUMBER := 0;
         
  BEGIN
      OPEN cursBike;
      LOOP
        FETCH cursBike INTO rowBike;
        EXIT WHEN cursBike%NOTFOUND;
        
            IF OUTPUT_TYPE = 'D' THEN
                INSERT INTO BICYCLES
                    VALUES(rowBike.SERIALNUMBER, rowBike.MODELTYPE, rowBike.PAINTID,
                    rowBike.FRAMESIZE, rowBike.ORDERDATE, rowBike.STARTDATE,
                    rowBike.SHIPDATE, rowBike.CONSTRUCTION, rowBike.LISTPRICE,
                    rowBike.SALEPRICE, rowBike.SALESTAX, rowBike.SALESTATE);
                            
            ROWCOUNT := ROWCOUNT + SQL%ROWCOUNT;
            COMMIT;
            
            ELSIF OUTPUT_TYPE = 'S' THEN
                DBMS_OUTPUT.PUT_LINE('Serial Number: ' || rowBike.SERIALNUMBER);
                DBMS_OUTPUT.PUT_LINE('Model: ' || rowBike.MODELTYPE);
                DBMS_OUTPUT.PUT_LINE('Paint: ' || rowBike.PAINTID);
                DBMS_OUTPUT.PUT_LINE('Frame Size: ' || rowBike.FRAMESIZE);
                DBMS_OUTPUT.PUT_LINE('Order Date: ' || rowBike.ORDERDATE);
                DBMS_OUTPUT.PUT_LINE('Start Date: ' || rowBike.STARTDATE);
                DBMS_OUTPUT.PUT_LINE('Ship Date: ' || rowBike.SHIPDATE);
                DBMS_OUTPUT.PUT_LINE('Construction: ' || rowBike.CONSTRUCTION);
                DBMS_OUTPUT.PUT_LINE('List Price: ' || rowBike.LISTPRICE);
                DBMS_OUTPUT.PUT_LINE('Sale Price: ' || rowBike.SALEPRICE);
                DBMS_OUTPUT.PUT_LINE('Sales Tax: ' || rowBike.SALESTAX);
                DBMS_OUTPUT.PUT_LINE('State Sale: ' || rowBike.SALESTATE); 
                
            ELSE
                DBMS_OUTPUT.PUT_LINE('*Error* Enter "S" to display data or
                                    "D" to insert data into the users schema');
            END IF;
        END LOOP;
        CLOSE cursBike;
  END EXTRACT_BICYCLES;
  
PROCEDURE EXTRACT_CUSTOMERS (OUTPUT_TYPE VARCHAR2) AS
CURSOR cursCust IS
SELECT cust.CUSTOMERID, cust.LASTNAME, cust.FIRSTNAME, cust.PHONE, 
        cust.ADDRESS, cust.CITY, cust.STATE, cust.ZIPCODE
    FROM BIKE_SHOP.CUSTOMER cust
        JOIN BIKE_SHOP.CITY shop
    ON cust.CITYID = shop.CITYID ORDER BY cust.LASTNAME ASC, cust.FIRSTNAME ASC;
    
    rowCust cursCust%ROWTYPE;
    ROWCOUNT NUMBER := 0;
    
  BEGIN
    OPEN cursCust;
    LOOP
        FETCH cursCust INTO rowCust;
        EXIT WHEN cursCust%NOTFOUND;
        
            IF OUTPUT_TYPE = 'D' THEN
                INSERT INTO CUSTOMERS
                    VALUES(rowCust.CUSTOMERID, rowCust.LASTNAME, 
                            rowCust.FIRSTNAME,  rowCust.PHONE, rowCust.ADDRESS, 
                            rowCust.CITY, rowCust.STATE, rowCust.ZIPCODE);
                            
                    ROWCOUNT := ROWCOUNT + SQL%ROWCOUNT;
                    
                ELSIF OUTPUT_TYPE = 'S' THEN
                  DBMS_OUTPUT.PUT_LINE('Customer ID: ' || rowCust.CUSTOMERID);
                  DBMS_OUTPUT.PUT_LINE('First Name: ' || rowCust.FIRSTNAME);
                  DBMS_OUTPUT.PUT_LINE('Last Name: ' || rowCust.LASTNAME);
                  DBMS_OUTPUT.PUT_LINE('Phone: ' || rowCust.PHONE);
                  DBMS_OUTPUT.PUT_LINE('Address: ' || rowCust.ADDRESS);
                  DBMS_OUTPUT.PUT_LINE('City: ' || rowCust.CITY);
                  DBMS_OUTPUT.PUT_LINE('State: ' || rowCust.STATE);
                  DBMS_OUTPUT.PUT_LINE('Zip Code: ' || rowCust.ZIPCODE);
                ELSE
                    DBMS_OUTPUT.PUT_LINE('*Error* Enter "S" to display data or
                                        "D" to insert data into 
                                        the users schema');
            END IF;
    END LOOP;
    CLOSE cursCust;
    
  END EXTRACT_CUSTOMERS;
  
  FUNCTION  CUSTOMER_BIKES (CUSTOMERID NUMBER) RETURN TEMP_CUST_TABLEOBJECT IS
  cust CUST_ORDERS_OBJ := CUST_ORDERS_OBJ(0,0); 
  custTable TEMP_CUST_TABLEOBJECT := TEMP_CUST_TABLEOBJECT();
  cntr NUMBER := 0;
  rowCtr NUMBER := 0; 

  BEGIN 

    FOR recrd IN (SELECT CUSTOMERID, SERIALNUMBER
          FROM BIKE_SHOP.BICYCLE
          WHERE CUSTOMERID = CUSTOMER_ID) LOOP

    custTable.extend(1);
    cntr := cntr + 1;

    cust := CUST_ORDERS_OBJ(recrd.CUSTOMERID, recrd.SERIALNUMBER);
    custTable(cntr) := cust;

    ROWCOUNT := ROWCOUNT + SQL%ROWCOUNT; 
    END LOOP;

       IF (ROWCOUNT = 0) THEN
          DBMS_OUTPUT.PUT_LINE('There are no rows!');
       END IF;

    RETURN TEMP_CUST_TABLEOBJECT;

  END CUSTOMER_BIKES;
  
  PROCEDURE ARCHIVE_CUSTOMER_BIKES IS custTable TEMP_CUST_TABLEOBJECT;
  BEGIN
    FOR rw IN (SELECT * FROM TABLE(CUSTOMER_BIKES)) 
        LOOP
            INSERT INTO CUSTOMER_BIKE
                VALUES(rw.CUSTOMERID, rw.SERIALNUMBER);
        END LOOP;
  END ARCHIVE_CUSTOMER_BIKES;
END BIKESHOP;
/
EXECUTE BIKESHOP.EXTRACT_CUSTOMERS('D');
EXECUTE BIKESHOP.EXTRACT_CUSTOMERS('S');
EXECUTE BIKESHOP.EXTRACT_BICYCLES('D');
EXECUTE BIKESHOP.EXTRACT_BICYCLES('S');

