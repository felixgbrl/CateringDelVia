CREATE DATABASE CateringdelVia

USE CateringdelVia

CREATE TABLE StaffPosition(
	PositionID CHAR(5) CHECK(PositionID LIKE 'SP[0-9][0-9][0-9]') PRIMARY KEY,
	PositionName VARCHAR(50) NOT NULL
)

CREATE TABLE Staff(
	StaffID CHAR(5) CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]') PRIMARY KEY,
	StaffName VARCHAR(255) NOT NULL,
	Position CHAR(5) FOREIGN KEY REFERENCES StaffPosition(PositionID) NOT NULL,
	Gender VARCHAR(9) NOT NULL,
	Email VARCHAR(255) CHECK(Email NOT LIKE '@%' AND (Email LIKE '%@yahoo.com' OR Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.co.id')) NOT NULL,
	PhoneNum VARCHAR(13) CHECK(PhoneNum LIKE '08%' AND ISNUMERIC(PhoneNum)=1) NOT NULL,
	StaffAddress VARCHAR(255),
	Salary INT CHECK (Salary >= 500000 AND Salary <=5000000) NOT NULL
)

CREATE TABLE Vendor(
	VendorID CHAR(5) CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]') PRIMARY KEY,
	VendorName VARCHAR(255) CHECK(VendorName LIKE 'PT. %') NOT NULL,
	PhoneNum VARCHAR(15) CHECK(PhoneNum LIKE '08%' AND ISNUMERIC(PhoneNum)=1) NOT NULL,
	VendorAddress VARCHAR(255) NOT NULL
)

CREATE TABLE Ingredient(
	IngID CHAR(5) CHECK(IngID LIKE 'ID[0-9][0-9][0-9]') PRIMARY KEY,
	IngName VARCHAR(255) NOT NULL,
	Stock INT NOT NULL,
	Price INT NOT NULL
)

--Ingredients yang dibeli ada pada table PurchaseList
CREATE TABLE PurchaseTransaction(
	PuTransID CHAR(5) CHECK(PuTransID LIKE 'PU[0-9][0-9][0-9]') PRIMARY KEY,
	Staff CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) NOT NULL,
	Vendor CHAR(5) FOREIGN KEY REFERENCES Vendor(VendorID) NOT NULL,
	PurchaseDate DATE NOT NULL
)
CREATE TABLE PurchaseList(
	PTID CHAR(5) FOREIGN KEY REFERENCES PurchaseTransaction(PuTransID) NOT NULL,
	Ing CHAR(5) FOREIGN KEY REFERENCES Ingredient(IngID) NOT NULL,
	Qty INT NOT NULL
)

CREATE TABLE Customer(
	CustID CHAR(5) CHECK(CustID LIKE 'CU[0-9][0-9][0-9]') PRIMARY KEY,
	CustName VARCHAR(255) NOT NULL,
	PhoneNum VARCHAR(13) CHECK(PhoneNum LIKE '08%' AND ISNUMERIC(PhoneNum)=1) NOT NULL,
	CustAddress VARCHAR(255),
	Gender VARCHAR(9) NOT NULL,
	Email VARCHAR(255) CHECK(Email NOT LIKE '@%' AND (Email LIKE '%@yahoo.com' OR Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.co.id')) NOT NULL
)

CREATE TABLE Menu(
	MenuID CHAR(5) CHECK(MenuID LIKE 'ME[0-9][0-9][0-9]') PRIMARY KEY,
	MenuName VARCHAR(255) CHECK(LEN(MenuName) > 5) NOT NULL,
	MenuDesc VARCHAR(255) NOT NULL,
	Price INT NOT NULL
)

--Menu yang terjual ada pada table ServiceList
CREATE TABLE ServiceTransaction(
	SeTransID CHAR(5) CHECK(SeTransID LIKE 'TR[0-9][0-9][0-9]') PRIMARY KEY,
	Staff CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) NOT NULL,
	Cust CHAR(5) FOREIGN KEY REFERENCES Customer(CustID) NOT NULL,
	TransDate DATE NOT NULL,
	ReservationType VARCHAR(50) NOT NULL,
	ReservationAddress VARCHAR(255) NOT NULL
)
CREATE TABLE ServiceList(
	STID CHAR(5) FOREIGN KEY REFERENCES ServiceTransaction(SeTransID) NOT NULL,
	Menu CHAR(5) FOREIGN KEY REFERENCES Menu(MenuID) NOT NULL,
	Pax INT NOT NULL
)