
-- 1. Create the database
CREATE DATABASE TalabatDB;
GO

-- 2. Select the database
USE TalabatDB;
GO

-- 3. Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(200)
);
GO

-- 4. Restaurants Table
CREATE TABLE Restaurants (
    RestaurantID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    Area NVARCHAR(100)
);
GO

-- 5. MenuItems Table
CREATE TABLE MenuItems (
    MenuItemID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantID INT NOT NULL,
    ItemName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BIT DEFAULT 1,

    CONSTRAINT CK_MenuItems_Price
        CHECK (Price >= 0),

    FOREIGN KEY (RestaurantID)
        REFERENCES Restaurants(RestaurantID)
);
GO

-- 6. Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    OrderStatus NVARCHAR(30) DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT CK_Orders_TotalAmount
        CHECK (TotalAmount >= 0),

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (RestaurantID)
        REFERENCES Restaurants(RestaurantID)
);
GO

-- 7. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT CK_OrderItems_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrderItems_UnitPrice
        CHECK (UnitPrice >= 0),

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    FOREIGN KEY (MenuItemID)
        REFERENCES MenuItems(MenuItemID)
);
GO

-- 8. Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    PaymentMethod NVARCHAR(30),
    PaymentStatus NVARCHAR(30) DEFAULT 'Pending',
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT CK_Payments_Amount
        CHECK (Amount >= 0),

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);
GO

USE TalabatDB;
GO

INSERT INTO Customers (FullName, Phone, Email, Address)
VALUES
('Yasmine Hatem', '01012345678', 'yasmine@example.com', 'Nasr City, Cairo'),
('Ahmed Mohamed', '01123456789', 'ahmed@example.com', 'Dokki, Giza'),
('Mariam Ali', '01234567890', 'mariam@example.com', 'Heliopolis, Cairo'),
('Omar Hassan', '01098765432', 'omar@example.com', 'Maadi, Cairo'),
('Nour Khaled', '01512345678', 'nour@example.com', '6th October, Giza');
GO

INSERT INTO Restaurants (RestaurantName, Phone, City, Area)
VALUES
('Koshary El Tahrir', '0223456789', 'Cairo', 'Downtown'),
('Shawarma El Reem', '0234567890', 'Giza', 'Dokki'),
('Chicken House', '0245678901', 'Cairo', 'Nasr City'),
('Foul w Taameya', '0256789012', 'Giza', 'Mohandessin');
GO

INSERT INTO MenuItems
    (RestaurantID, ItemName, Category, Price, IsAvailable)
VALUES
-- Restaurant 1
(1, 'Koshari', 'Main Course', 75.00, 1),
(1, 'Hawawshi', 'Main Course', 90.00, 1),
(1, 'Water', 'Drink', 10.00, 1),

-- Restaurant 2
(2, 'Chicken Shawarma', 'Sandwich', 80.00, 1),
(2, 'French Fries', 'Side Dish', 35.00, 1),
(2, 'Falafel Sandwich', 'Sandwich', 25.00, 1),

-- Restaurant 3
(3, 'Grilled Chicken', 'Main Course', 220.00, 1),
(3, 'Rice', 'Side Dish', 45.00, 1),

-- Restaurant 4
(4, 'Foul Sandwich', 'Sandwich', 25.00, 1),
(4, 'Taameya Sandwich', 'Sandwich', 17.50, 1);
GO

INSERT INTO Orders
    (CustomerID, RestaurantID, TotalAmount)
VALUES
(1, 1, 240.00),
(2, 2, 195.00),
(3, 3, 265.00),
(1, 4, 67.50),
(4, 1, 95.00),
(5, 2, 115.00);
GO

INSERT INTO OrderItems
    (OrderID, MenuItemID, Quantity, UnitPrice)
VALUES
-- Order 1: Koshari + Hawawshi
(1, 1, 2, 75.00),
(1, 2, 1, 90.00),

-- Order 2: Shawarma + Fries
(2, 4, 2, 80.00),
(2, 5, 1, 35.00),

-- Order 3: Grilled Chicken + Rice
(3, 7, 1, 220.00),
(3, 8, 1, 45.00),

-- Order 4: Foul + Taameya
(4, 9, 2, 25.00),
(4, 10, 1, 17.50),

-- Order 5: Koshari + Water
(5, 1, 1, 75.00),
(5, 3, 2, 10.00),

-- Order 6: Shawarma + Fries
(6, 4, 1, 80.00),
(6, 5, 1, 35.00);
GO

INSERT INTO Payments
    (OrderID, PaymentMethod, PaymentStatus, Amount)
VALUES
(1, 'Cash', 'Paid', 240.00),
(2, 'Card', 'Paid', 195.00),
(3, 'Wallet', 'Paid', 265.00),
(4, 'Cash', 'Pending', 67.50),
(5, 'Card', 'Paid', 95.00),
(6, 'Cash', 'Pending', 115.00);
GO

SELECT * FROM Customers;
SELECT * FROM Restaurants;
SELECT * FROM MenuItems;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;