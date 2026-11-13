-- Little Lemon Database Schema & Stored Procedures
DROP DATABASE IF EXISTS LittleLemonDB;
CREATE DATABASE LittleLemonDB;
USE LittleLemonDB;

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    CountryCode VARCHAR(10)
);

-- 2. MenuItems Table
CREATE TABLE MenuItems (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100),
    CuisineName VARCHAR(100),
    StarterName VARCHAR(100),
    DesertName VARCHAR(100),
    Drink VARCHAR(100),
    Sides VARCHAR(100)
);

-- 3. Bookings Table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID VARCHAR(20) NOT NULL,
    BookingDate DATE NOT NULL,
    TableNumber INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 4. Orders Table
CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID VARCHAR(20) NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    Sales DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID) ON DELETE CASCADE
);

-- 5. OrderDeliveryStatus Table
CREATE TABLE OrderDeliveryStatus (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID VARCHAR(20) NOT NULL,
    DeliveryDate DATE,
    DeliveryCost DECIMAL(10, 2) DEFAULT 0.00,
    Status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Sample Seed Data (Derived from LittleLemon_data.xlsx)
INSERT INTO Customers (CustomerID, CustomerName, City, Country, PostalCode, CountryCode) VALUES
('72-055-7985', 'Laney Fadden', 'Daruoyan', 'China', '993-0031', 'CN'),
('65-353-0657', 'Giacopo Bramich', 'Ongjin', 'North Korea', '216282', 'KP'),
('90-876-6799', 'Lia Bonar', 'Quince Mil', 'Peru', '663246', 'PE');

INSERT INTO MenuItems (CourseName, CuisineName, StarterName, DesertName, Drink, Sides) VALUES
('Greek salad', 'Greek', 'Olives', 'Greek yoghurt', 'Athens White wine', 'Tapas'),
('Bean soup', 'Italian', 'Flatbread', 'Ice cream', 'Corfu Red Wine', 'Potato salad'),
('Pizza', 'Italian', 'Minestrone', 'Cheesecake', 'Italian Coffee', 'Bruschetta');

INSERT INTO Orders (OrderID, OrderDate, CustomerID, MenuItemID, Quantity, Cost, Sales, Discount) VALUES
('54-366-6861', '2020-06-15', '72-055-7985', 1, 2, 125.00, 187.50, 20.00),
('63-761-3686', '2020-08-25', '65-353-0657', 2, 1, 235.00, 352.50, 15.00),
('65-351-6434', '2021-08-17', '90-876-6799', 3, 3, 75.00, 112.50, 10.52);

INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber) VALUES
(1, '72-055-7985', '2022-10-10', 5),
(2, '65-353-0657', '2022-11-12', 3),
(3, '90-876-6799', '2022-10-11', 2);

-- =============================================================================
-- REQUIRED STORED PROCEDURES
-- =============================================================================

-- 1. GetMaxQuantity()
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS "Max Quantity in Order" FROM Orders;
END //
DELIMITER ;

-- 2. ManageBooking()
DELIMITER //
CREATE PROCEDURE ManageBooking(IN booking_date DATE, IN table_no INT)
BEGIN
    DECLARE booking_status INT DEFAULT 0;
    SELECT COUNT(*) INTO booking_status
    FROM Bookings
    WHERE BookingDate = booking_date AND TableNumber = table_no;
    
    IF booking_status > 0 THEN
        SELECT CONCAT("Table ", table_no, " is already booked - booking cancelled") AS "Booking Status";
    ELSE
        SELECT CONCAT("Table ", table_no, " is available") AS "Booking Status";
    END IF;
END //
DELIMITER ;

-- 3. AddBooking()
DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN customer_id VARCHAR(20), IN booking_date DATE, IN table_no INT)
BEGIN
    INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber)
    VALUES (booking_id, customer_id, booking_date, table_no);
    SELECT "New booking added" AS Confirmation;
END //
DELIMITER ;

-- 4. UpdateBooking()
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN booking_date DATE)
BEGIN
    UPDATE Bookings
    SET BookingDate = booking_date
    WHERE BookingID = booking_id;
    SELECT CONCAT("Booking ", booking_id, " updated") AS Confirmation;
END //
DELIMITER ;

-- 5. CancelBooking()
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DELETE FROM Bookings
    WHERE BookingID = booking_id;
    SELECT CONCAT("Booking ", booking_id, " cancelled") AS Confirmation;
END //
DELIMITER ;