CREATE TABLE Books(
	BookId Serial PRIMARY KEY,
	Title VARCHAR (100),
	Author VARCHAR (100),
	Genre Varchar (50),
	Published_year INT,
	Price Numeric (10,2),
	Stock INT
);

CREATE TABLE Customers(
	CustomerID Serial PRIMARY KEY,
	NAME VARCHAR (100),
	Email VARCHAR (100),
	Phone Varchar (15),
	City Varchar(50),
	Country Varchar (150)
);

CREATE TABLE Orders(
	OrderId Serial PRIMARY KEY,
	CustomerID INT REFERENCES Customers(CustomerID),
	Bookid INT REFERENCES Books(BookId),
	Order_Date Date,
	Quantity INT,
	Total_Amount Numeric (10, 2)
);

--Import data into BOOKS TABLE
COPY BOOKS (BookID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\Data_Analyst\SQL\SQL_Projects\Online_Book_Store_SQL/Books.CSV'
CSV HEADER
DELIMITER ',';

--Import data into CUSTOMERS TABLE
COPY CUSTOMERS (CustomerID,	Name, Email,	Phone,	City,	Country)
FROM 'D:\Data_Analyst\SQL\SQL_Projects\Online_Book_Store_SQL/Customers.CSV'
CSV HEADER
DELIMITER ',';

--Import data into Orders TABLE
COPY Orders (OrderID, CustomerID, BookID,	Order_Date,	Quantity, Total_Amount)
FROM 'D:\Data_Analyst\SQL\SQL_Projects\Online_Book_Store_SQL/Orders.CSV'
CSV HEADER
DELIMITER ',';

--1) Retrieve all books in the "Fiction" Genre.
SELECT * FROM Books WHERE Genre = 'Fiction';

--2) Find books published after the year 1950.
SELECT * FROM Books WHERE Published_Year > 1950;

--3) List all customers from the Canada.
SELECT * FROM Customers WHERE Country ='Canada';

--4) Show orders placed in Nov 2023.
SELECT * FROM Orders WHERE EXTRACT(Month FROM Order_Date) = 11 AND
EXTRACT(YEAR FROM Order_Date) = 2023 ORDER BY Order_Date;

SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stocks of books available.
SELECT SUM(Stock) AS Total_Stock FROM Books;

--6) Find the details of the most expesive book.
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of book.
SELECT c.customerid, c.name, b.bookid, b.title, SUM(o.quantity) AS Total_Quantity
FROM Customers c
JOIN Orders o ON o.customerid = c.customerid
JOIN Books b ON b.bookid = o.bookid
GROUP BY c.customerid, c.name, b.bookid, b.title
HAVING SUM(o.quantity) > 1
ORDER BY Total_Quantity DESC;

--8) Show all orders where the total amount exceeds $20.
SELECT * FROM Orders Where Total_Amount > 20;

--9) List all genres available in books table.
SELECT DISTINCT genre FROM Books;

--10) Find book with lowest stock.
SELECT * FROM Books ORDER BY Stock LIMIT 1;

--11) Calculate total revenue generated from all orders.
SELECT SUM(total_amount) AS Total_Revenue FROM Orders;

--12) Retrieve total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.bookid = b.bookid
GROUP BY b.genre
ORDER BY total_books_sold DESC;

--13) Find average price of books in the "Fantasy" Genre.
SELECT Genre, ROUND(AVG(Price), 2) AS Avg_Price FROM Books
Where Genre = 'Fantasy'
GROUP BY Genre;

--14) List customer who placed at least 2 orders.
SELECT c.customerid, c.name, COUNT(o.orderid) AS Total_Orders
FROM Customers c
JOIN Orders o ON o.customerid = c.customerid
GROUP BY 1,2
HAVING COUNT(o.orderid)>=2
ORDER BY 3 DESC;

--15) Find most frequently ordered book.
SELECT o.bookid, b.title, COUNT(o.orderid) AS frequently_ordered_book
FROM Orders o
JOIN Books b ON o.bookid = b.bookid
GROUP BY 1,2
ORDER BY frequently_ordered_book DESC
LIMIT 1;

--16) Show top 3 most expensive books of 'Fantasy' Genre.
SELECT bookid, title, MAX(price) Top_3_Fantasy_Books
FROM Books
WHERE genre = 'Fantasy'
GROUP BY 1, 2
ORDER BY Top_3_Fantasy_Books DESC
LIMIT 3;

--17) Show total quantity of books sold by each author.
SELECT b.title, b.author, SUM(o.quantity) AS Total_Quantity
FROM Books b
JOIN Orders o ON o.bookid = b.bookid
GROUP BY 1,2
Order BY Total_Quantity DESC;

--18) List the cities where customers who spent over $30 are located.
SELECT DISTINCT c.city
FROM Customers c
JOIN Orders o ON o.customerid = c.customerid
JOIN Books b ON o.bookid = b.bookid
GROUP BY c.customerid, c.city
HAVING SUM(o.quantity * b.price) > 30;


--19) List the customer who spent the most on orders.
Select c.customerid, c.name, SUM(o.quantity * b.price) AS Total_Spent
FROM Customers c
JOIN Orders o ON o.customerid = c.customerid
JOIN Books b ON o.bookid = b.bookid
GROUP BY c.customerid, c.name
ORDER BY total_spent DESC
LIMIT 1;

--20) Calculate the stock remaining after fullfilling all orders.
SELECT b.bookid,  b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS Order_Quantity, 
b.stock - COALESCE(SUM(o.quantity), 0) AS Stock_Remaining
FROM Books b
LEFT JOIN Orders o ON o.bookid = b.bookid
GROUP BY b.bookid
ORDER BY  b.bookid;

SELECT * FROM Books;
SELECT * FROM Orders;
SELECT * FROM Customers;























