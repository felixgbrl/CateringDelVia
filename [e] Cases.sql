USE CateringdelVia

--1
SELECT StaffName,
PositionName,
'Total Activity' = COUNT(StaffID)
FROM Staff S
JOIN StaffPosition SP
ON S.Position = SP.PositionID
JOIN ServiceTransaction ST
ON S.StaffID = ST.Staff
JOIN PurchaseTransaction PT
ON S.StaffID = PT.Staff
WHERE Salary BETWEEN 1000000 AND 4000000
GROUP BY StaffName, PositionName
HAVING COUNT(StaffID) > 2

--2
SELECT CustID,
CustName,
'Pax Bought' = SUM(Pax)
FROM Customer C
JOIN ServiceTransaction ST
ON C.CustID = ST.Cust
JOIN ServiceList SL
ON ST.SeTransID = SL.STID
WHERE Gender = 'Male'
AND MONTH(TransDate) <=6
GROUP BY CustID, CustName

--3
SELECT IngName,
'Ingredient Bought' = SUM(Qty),
'Purchase Count' = COUNT(Ing),
'Total Expenses' = SUM(Qty * Price)
FROM Ingredient I
JOIN PurchaseList PL
ON I.IngID = PL.Ing
JOIN PurchaseTransaction PT
ON PL.PTID = PT.PuTransID
WHERE MONTH(PurchaseDate) % 2 = 0
AND ((DAY(PurchaseDate) % 7) + 1) BETWEEN 2 AND 5
GROUP BY IngName

--4
SELECT 'First Name' = CASE WHEN LEN(StaffName) - LEN(REPLACE(StaffName, ' ', '')) < 2 
            THEN StaffName
            ELSE LEFT(StaffName, CHARINDEX(' ', StaffName, CHARINDEX(' ', StaffName) + 1))
			END,
'Transaction Count' = COUNT(SeTransID),
'Pax Sold' = SUM(Pax)
FROM Staff S
JOIN ServiceTransaction ST
ON S.StaffID = ST.Staff
JOIN ServiceList SL
ON ST.SeTransID = SL.STID
WHERE CAST(RIGHT(StaffID, 1) AS INT) % 2 = 1
AND CAST(RIGHT(Cust, 1) AS INT) % 2 = 0
GROUP BY StaffName

--5
SELECT 'Vendor Name' = RIGHT(VendorName, CHARINDEX(' ', REVERSE(VendorName))),
IngName,
'Ingredient Price' = 'Rp. ' + CAST(Price AS VARCHAR)
FROM Vendor V
JOIN PurchaseTransaction PT
ON V.VendorID = PT.Vendor
JOIN PurchaseList PL
ON PT.PuTransID = PL.PTID
JOIN Ingredient I
ON PL.Ing = I.IngID,
(SELECT 'avgPrice' = AVG(Price) FROM Ingredient) AS avgPrice
WHERE Price >= avgPrice
AND Stock < 250

--6
SELECT CustName,
'Transaction Date' = CONVERT(VARCHAR, TransDate, 107),
MenuName,
Price,
'Brief Description' = CASE WHEN LEN(MenuDesc) - LEN(REPLACE(MenuDesc, ' ', '')) < 2 
            THEN MenuDesc
            ELSE LEFT(MenuDesc, CHARINDEX(' ', MenuDesc, CHARINDEX(' ', MenuDesc) + 1))
			END,
Pax,
'Total Price' = Price * Pax
FROM Customer C
JOIN ServiceTransaction ST
ON C.CustID = ST.Cust
JOIN ServiceList SL
ON ST.SeTransID = SL.STID
JOIN Menu M
ON SL.Menu = M.MenuID,
(SELECT 'avgPrice' = AVG(Price) FROM Menu) AS avgPrice
WHERE Price > avgPrice
AND Pax > 100

--7
SELECT 'Staff Name' =  UPPER(StaffName),
'Purchase Date' = CONVERT(VARCHAR, PurchaseDate, 107),
'Quantity Bought' = CAST(SUM(Qty) AS VARCHAR) + ' pcs'
FROM Staff S
JOIN PurchaseTransaction PT
ON S.StaffID = PT.Staff
JOIN PurchaseList PL
ON PT.PuTransID = PL.PTID
JOIN Ingredient I
ON PL.Ing = I.IngID,
(SELECT 'MaxPrice' = MAX(Price) FROM Ingredient) AS MaxPrice
WHERE MONTH(PurchaseDate) % 2 = 0
AND Price < MaxPrice
GROUP BY StaffName, PurchaseDate, PuTransID

--8
SELECT CustName,
'Email' = LEFT(Email, CHARINDEX('@', Email) - 1),
'Menu Name' = LOWER(MenuName),
'Pax Bought' = SUM(Pax)
FROM Customer C
JOIN ServiceTransaction ST
ON C.CustID = ST.Cust
JOIN ServiceList SL
ON ST.SeTransID = SL.STID
JOIN Menu M
ON SL.Menu = M.MenuID,
(SELECT 'avgPax' = AVG(Pax) FROM ServiceList) AS avgPax
WHERE Gender = 'Male'
AND Pax >= avgPax
GROUP BY CustName, Email, MenuName

--9
GO
CREATE VIEW LoyalCustomerView AS
	SELECT CustName,
	'Total Transaction' = COUNT(CustID),
	'Total Pax Purchased' = SUM(Pax),
	'Total Price' = SUM(Price * Pax)
	FROM Customer C
	JOIN ServiceTransaction ST
	ON C.CustID = ST.Cust
	JOIN ServiceList SL
	ON ST.SeTransID = SL.STID
	JOIN Menu M
	ON SL.Menu = M.MenuID
	WHERE Gender = 'Female'
	GROUP BY CustName
	HAVING COUNT(CustID) > 2
GO
--SELECT * FROM LoyalCustomerView

--10
GO
CREATE VIEW VendorRecapView AS
	SELECT VendorName,
	'Purchases Made' = COUNT(VendorID),
	'Ingredients Purchased' = SUM(Qty)
	FROM Vendor V
	JOIN PurchaseTransaction PT
	ON V.VendorID = PT.Vendor
	JOIN PurchaseList PL
	ON PT.PuTransID = PL.PTID
	JOIN Ingredient I
	ON PL.Ing = I.IngID
	WHERE Stock > 150
	GROUP BY VendorName
	HAVING COUNT(VendorID) > 1
GO
--SELECT * FROM VendorRecapView