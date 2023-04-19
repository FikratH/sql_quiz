--1

CREATE DATABASE Store

--2

CREATE TABLE Categories(
	ID int primary key identity,
	Name nvarchar(255) UNIQUE
)

CREATE TABLE Products(
	ID int primary key identity,
	ProductCode nvarchar(255) UNIQUE,
	CategoryID int foreign key references Categories(ID)
)

CREATE TABLE Stock(
	ID int primary key identity,
	ProductID int foreign key references Products(ID),
	CreatedDate datetime2 default GETDATE(),
	Count int
)

CREATE TABLE Sizes (
		ID int primary key identity,
		Letter nvarchar(5),
		Min int,
		Max int,
)

--3

ALTER TABLE Stock
ADD Size int

--4

INSERT INTO Categories
VALUES ('T-Shirts'),
	   ('Jeans'),
	   ('Shoes'),
	   ('Jackets')

INSERT INTO Products
VALUES ('AAA',1),
       ('AAB',1),
	   ('BBB',2),
	   ('BBA',2),
	   ('CCC',3),
	   ('CCB',3),
	   ('DDD',4),
	   ('DDC',4)

SELECT * FROM Products

INSERT INTO Stock
VALUES (17,'2023-04-19',5,150),
       (17,'2023-04-19',5,160),
	   (18,'2023-04-19',5,150),
       (18,'2023-04-19',5,160),
	   (19,'2023-04-19',5,150),
       (19,'2023-04-19',5,160),
	   (20,'2023-04-19',5,150),
       (20,'2023-04-19',5,160),
	   (21,'2023-04-19',5,150),
       (21,'2023-04-19',5,160),
	   (22,'2023-04-19',5,150),
       (22,'2023-04-19',5,160),
	   (23,'2023-04-19',5,150),
       (23,'2023-04-19',5,160),
	   (24,'2023-04-19',5,150),
       (24,'2023-04-19',5,160)


INSERT INTO Sizes
VALUES ('S',145,155),
	   ('M',155,165),
	   ('L',165,175),
	   ('XL',175,185)
--5
CREATE VIEW Products_View
AS
SELECT p.ProductCode 'Product Code', c.Name 'Category Name', s.CreatedDate,s.Count, s.Size, size.Letter FROM Products p
JOIN Categories c
ON p.CategoryID = c.ID
JOIN Stock s
ON s.ProductID = p.ID
JOIN Sizes size
ON s.Size > size.Min AND s.Size < size.Max

--6

CREATE PROCEDURE usp_products_on_size @size nvarchar(5)
AS
BEGIN
SELECT * FROM Products_View
WHERE Letter = @size
END

DROP PROCEDURE usp_products_on_size

EXEC usp_products_on_size 'S'

--7

CREATE FUNCTION ProductsCount(@category nvarchar(255))
RETURNS int
BEGIN
DECLARE @result int
SELECT @result = COUNT(*) FROM Products_View
WHERE [Category Name] = @category

RETURN @result
END

EXEC dbo.ProductsCount('XS')

--8

CREATE TRIGGER SecletOnAdd
ON Products
AFTER INSERT
AS
BEGIN
SELECT * FROM Products_View
END

--9


SELECT * FROM Stock
WHERE Count > (SELECT AVG (Count) FROM Stock)