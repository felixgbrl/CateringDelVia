USE CateringdelVia

-- Staff
GO
CREATE PROCEDURE Sp_Staff
            @StaffID CHAR(5),
            @StaffName VARCHAR(255),
            @Position CHAR(5),
            @Gender VARCHAR(9),
            @Email VARCHAR(255),
            @PhoneNum VARCHAR(13),
            @StaffAddress VARCHAR(255),
            @Salary INT
AS INSERT INTO Staff VALUES (@StaffID, @StaffName, @Position, @Gender, @Email, @PhoneNum, @StaffAddress, @Salary)
-- EXEC Sp_Staff 'ST014', 'Nando', 'SP010', 'Male', 'nando@gmail.com', '08155247', 'Kemanggisan', 1000000

-- Service Transaction
GO
CREATE PROCEDURE Sp_Service
            @SeTransID CHAR(5),
            @Staff CHAR(5),
            @Cust CHAR(5),
            @TransDate DATE,
            @ReservationType VARCHAR(50),
            @ReservationAddress VARCHAR(255),
            @Menu CHAR(5),
            @Pax INT
AS 
BEGIN
    INSERT INTO ServiceTransaction VALUES (@SeTransID, @Staff, @Cust, @TransDate, @ReservationType, @ReservationAddress)
    INSERT INTO ServiceList VALUES (@SeTransID, @Menu, @Pax)
END
-- EXEC Sp_Service 'TR016', 'ST012', 'CU001', '2020-12-23', 'Delivery', 'Jakarta Utara', 'ME006', 15

-- Purchase Transaction
GO
CREATE PROCEDURE Sp_Purchase
            @PuTransID CHAR(5) ,
            @Staff CHAR(5),
            @Vendor CHAR(5),
            @PurchaseDate DATE,
            @Ing CHAR(5),
            @Qty INT
AS 
BEGIN
    INSERT INTO PurchaseTransaction VALUES (@PuTransID, @Staff, @Vendor, @PurchaseDate)
	INSERT INTO PurchaseList VALUES (@PuTransID, @Ing, @Qty)
END
-- EXEC Sp_Purchase 'PU016', 'ST011', 'VE001', '2020-12-18', 'ID003', 25