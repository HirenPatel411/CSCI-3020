/*  Lab 5 - Data Warehouse Creation Script  */
/*  CSCI 3020 - Database Advanced Concepts  */

/*
  SNOWFLAKE SCHEMA
  
  Dimension Tables:
	Animal
	Customer
    DateLookup
	EMPLOYEE
	MERCHANDISE
	SUPPLIER
    
  Fact Tables:
    ORDERS
    SALES
*/

DROP TABLE ANIMAL CASCADE CONSTRAINTS;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS;
DROP TABLE DATELOOKUP CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE MERCHANDISE CASCADE CONSTRAINTS;
DROP TABLE ORDERS CASCADE CONSTRAINTS;
DROP TABLE SALES CASCADE CONSTRAINTS;
DROP TABLE SUPPLIER CASCADE CONSTRAINTS;

/******************************************************************************/
/* DIMENSION TABLES
/******************************************************************************/
CREATE TABLE DateLookup (
  DateID NUMBER(38,0),
  TheDate DATE,
  Month VARCHAR2(3),
  Day VARCHAR2(2),
  Year VARCHAR2(4),
  PRIMARY KEY (DateID)
);

CREATE TABLE Animal (
  ANIMALID	NUMBER(38,0),
  NAME	VARCHAR2(50 BYTE),
  CATEGORY	VARCHAR2(50 BYTE),
  BREED	VARCHAR2(50 BYTE),
  DATEBORN	DATE,
  GENDER	VARCHAR2(50 BYTE),
  REGISTERED	VARCHAR2(50 BYTE),
  COLOR	VARCHAR2(50 BYTE),
  LISTPRICE	NUMBER(38,4),
  PRIMARY KEY (AnimalID)
);

CREATE TABLE Supplier (
  SUPPLIERID	NUMBER(38,0),
  NAME	VARCHAR2(50 BYTE),
  CONTACTNAME	VARCHAR2(50 BYTE),
  PHONE	VARCHAR2(50 BYTE),
  ADDRESS VARCHAR2(50 BYTE),
  CITY	VARCHAR2(50 BYTE),
  STATE	VARCHAR2(50 BYTE),
  ZIPCODE	VARCHAR2(50 BYTE),
  PRIMARY KEY (SupplierID)
);

CREATE TABLE Merchandise (
  MerchandiseID NUMBER(38,0),
  DESCRIPTION	VARCHAR2(50 BYTE),
  QUANTITYONHAND	NUMBER(38,0),
  LISTPRICE	NUMBER(38,4),
  CATEGORY	VARCHAR2(50 BYTE),
  PRIMARY KEY (MerchandiseID)
);

CREATE TABLE Employee (
  EMPLOYEEID	NUMBER(38,0),
  NAME	VARCHAR2(101 BYTE),
  ADDRESS	VARCHAR2(200 BYTE),
  DATEHIRED	NUMBER(38,0),
  PRIMARY KEY (EmployeeID),
  FOREIGN KEY (DATEHIRED) REFERENCES DateLookup(DateID)
);

CREATE TABLE Customer (
  CUSTOMERID	NUMBER(38,0),
  PHONE	VARCHAR2(50 BYTE),
  FIRSTNAME	VARCHAR2(50 BYTE),
  LASTNAME	VARCHAR2(50 BYTE),
  ADDRESS	VARCHAR2(50 BYTE),
  CITY	VARCHAR2(50 BYTE),
  STATE	VARCHAR2(50 BYTE),
  ZIPCODE	VARCHAR2(50 BYTE),
  PRIMARY KEY (CustomerID)
);

/******************************************************************************/
/* FACT TABLES
/******************************************************************************/
CREATE TABLE Orders (
  OrderID NUMBER(38,0),
  OrderDate NUMBER(38,0),
  ReceivedDate NUMBER(38,0),
  Quantity NUMBER(38,0),
  Cost NUMBER(38,4),
  ShippingCost NUMBER(38,4),
  AnimalID NUMBER(38,0),
  MerchandiseID NUMBER(38,0),
  SupplierID NUMBER(38,0),
  EmployeeID NUMBER(38,0),
  PRIMARY KEY (OrderID),
  FOREIGN KEY (OrderDate) REFERENCES DateLookup(DateID),
  FOREIGN KEY (ReceivedDate) REFERENCES DateLookup(DateID),
  FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
  FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
  FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Sales (
  SaleFactID NUMBER(38,0),
  SaleID NUMBER(38,0),
  SaleDate NUMBER(38,0),
  EmployeeID NUMBER(38,0),
  CustomerID NUMBER(38,0),
  AnimalID NUMBER(38,0),
  MerchandiseID NUMBER(38,0),
  Quantity  NUMBER(38,0),
  SalePrice  NUMBER(38,4),
  SalesTax  NUMBER(38,4),
  PRIMARY KEY (SaleFactID),
  FOREIGN KEY (SaleDate) REFERENCES DateLookup(DateID),
  FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
  FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);