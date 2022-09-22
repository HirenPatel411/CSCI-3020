
-- Hiren Patel, Lab 5 Part 2

drop table SkillLevel cascade constraint;
drop table Customer cascade constraint;
drop table PaymentMethod cascade constraint;
drop table Inventory cascade constraint;
drop table Rental cascade constraint;
drop table Sale cascade constraint;

CREATE TABLE SkillLevel (
  SkillLevel number(38,0),
  PRIMARY KEY (SkillLevel)
);

CREATE TABLE Customer (
  CustomerID number(38,0),
  LastName varchar2 (50),
  FirstName varchar2 (50),
  Phone varchar2 (50),
  Email varchar2 (120),
  Address varchar2 (50),
  City varchar2 (50),
  State varchar2 (50),
  Zip varchar2 (50),
  Gender varchar2 (50),
  DateOfBirth date,
  PRIMARY KEY (CustomerID)
);

CREATE TABLE PaymentMethod (
  PaymentMethod varchar2 (50),
  PRIMARY KEY (PaymentMethod)
);

CREATE TABLE Inventory (
  SKU varchar2 (50),
  ModelID varchar2 (50),
  ItemSize number,
  QuantityOnHand number(38,0),
  PRIMARY KEY (SKU)
);

CREATE TABLE Rental (
  RentID number(38,0),
  CustomerID number(38,0),
  SkillLevel number(38,0),
  PaymentMethod varchar2 (50),
  SKU varchar2 (50),
  RentDate date,
  ExpectedReturn date,
  PRIMARY KEY (RentID)
);

CREATE TABLE Sale (
  SaleID number(38,0),
  CustomerID number(38,0),
  SkillLevel number(38,0),
  PaymentMethod varchar2 (50),
  SKU varchar2 (50),
  SaleDate date,
  ShipAddress varchar2 (50),
  ShipCity varchar2 (50),
  ShipState varchar2 (50),
  ShipZip varchar2 (50),
  PRIMARY KEY (SaleID)
);

ALTER TABLE sale ADD (
  CONSTRAINT FK_customerID
  FOREIGN KEY (customerID) 
  REFERENCES customer (customerID));


ALTER TABLE sale ADD (
  CONSTRAINT FK_skillLevel
  FOREIGN KEY (skillLevel) 
  REFERENCES SkillLevel (skillLevel));
  
  ALTER TABLE sale ADD (
  CONSTRAINT FK_paymentMethod
  FOREIGN KEY (paymentMethod) 
  REFERENCES PaymentMethod (paymentMethod));
  
  ALTER TABLE sale ADD (
  CONSTRAINT FK_SKU
  FOREIGN KEY (SKU) 
  REFERENCES Inventory (SKU));

ALTER TABLE Rental ADD (
  CONSTRAINT CustomerID
  FOREIGN KEY (CustomerID) 
  REFERENCES customer (CustomerID));
  
  ALTER TABLE Rental ADD (
  CONSTRAINT skillLevel
  FOREIGN KEY (skillLevel) 
  REFERENCES SkillLevel (skillLevel));

ALTER TABLE Rental ADD (
  CONSTRAINT paymentMethod
  FOREIGN KEY (paymentMethod) 
  REFERENCES PaymentMethod (paymentMethod));

ALTER TABLE Rental ADD (
  CONSTRAINT SKU
  FOREIGN KEY (SKU) 
  REFERENCES Inventory (SKU));

