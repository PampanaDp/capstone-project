with customerorderrevenue as (
select c.CustomerID,c.CompanyName,o.OrderID,
	sum(od.UnitPrice * od.Quantity * (1-od.Discount)) as OrderRevenue
    from customers c
    join Orders o On c.CustomerID = o.CustomerID
    join order_details od On o.OrderID = od.OrderID
    group by c.CustomerID,c.CompanyName,o.OrderID
    ),
    CustomerSummary as (
    select CustomerID,CompanyName,Count(OrderID) as TotalOrders,
    Sum(OrderRevenue) as TotalRevenue from customerorderrevenue 
    Group by CustomerID,CompanyName
    )
    select CustomerID,CompanyName,TotalOrders,round(TotalRevenue,2) from CustomerSummary
    where TotalOrders > 1
    order by TotalRevenue Desc;  

select * from employees;


/* 5th Quection */
SELECT c.Country, COUNT(DISTINCT o.OrderID) AS TotalOrders,
COUNT(DISTINCT c.CustomerID) AS NumCustomers, 
ROUND(COUNT(DISTINCT o.OrderID) * 1.0/ COUNT(DISTINCT C.CustomerID), 2) AS
AvgOrdersPerCustomer
FROM Customers c
JOIN Orders o ON c.CustomerID = o.customerID
GROUP BY C.Country
ORDER BY AvgOrdersPerCustomer DESC
/* Frequency by value based */;
with customerspend as (
select c.customerID, sum(od.Quantity * (1-od.discount)) as totalspend,
count(distinct o.orderID) as ordercount
from Customers c 
join orders o on c.customerID =o.customerID
join order_details od on o.orderID = od.orderID
group by c.customerID
),
segmented as (
select *, case
	when totalspend >= 10000 then 'High-value'
    when totalspend between 5000 and 9999 then 'Mid-value'
    else 'Low-Value' 
end as spendsegment from customerspend
)
Select spendsegment, count(*) as Numcustomers,
sum(ordercount) as totalorders,
round(avg(ordercount),2) as Avgorderspercs
from segmented
group by spendsegment
order by Avgorderspercs desc;



/* 4rth Quection */
select p.ProductID,p.ProductName,
Sum(od.UnitPrice * od.Quantity * (1-od.Discount)) as TotalRevenue
from order_details od
join Products p on od.ProductID = p.ProductID
group by p.ProductID,p.ProductName
order by TotalRevenue DESC
limit 10;

Select Country,Title,Count(*) as NumEmployees from employees
group by Country,Title
order by Country,Title;


Select TitleOfCourtesy,Title,count(*) as NumEmployees 
from Employees 
Group by TitleOfCourtesy,Title
order by TitleOfCourtesy,Title;


/* 9th Quection */
WITH ProductSales AS (
SELECT od.ProductID,
SUM(od.Quantity) AS TotalUnitsSold,
SUM(od.UnitPrice * od.Quantity * (1- od.Discount)) AS TotalRevenue
FROM order_details od
GROUP BY od.ProductID
)
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsinStock, p.UnitsOnOrder,
ps.TotalUnitsSold, ps.TotalRevenue
FROM Products p
left join ProductSales ps ON p.ProductID = ps.ProductID;
 


/* 10th Quection */

WITH MonthlySales AS(
SELECT
p.ProductID,
p.ProductName,
DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth, 
SUM(od.Quantity) AS UnitsSold, 
SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as revenue
FROM order_details od
JOIN orders o ON od.OrderID = o.OrderID
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, DATE_FORMAT(o.OrderDate, '%Y-%m')
)
SELECT *
FROM MonthlySales
ORDER BY ProductID, OrderMonth;

/* 12th Quection */
with suppliercounts as (
select country, Count(*) as numofsupplier
from suppliers 
group by country
),
pricingbycountry as (
select s.country, round(Avg(p.UnitPrice),2) as avgproductprice
from products p 
 join Suppliers s on p.SupplierID = s.SupplierID
 group by s.country
 )
 select sc.country, sc.numofsupplier,pc.avgproductprice 
 from suppliercounts sc
 join pricingbycountry pc on sc.country = pc.country
 order by pc.avgproductprice desc;



/* 13th quection */

SELECT s.CompanyName AS SupplierName, c.CategoryName,
COUNT(p.ProductID) AS NumProductsSupplied
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY s.CompanyName, c.CategoryName
ORDER BY SupplierName,c.CategoryName;


/* 14th Quection */ 

Select s.country,c.categoryName,
Round(Avg(p.UnitPrice),2) as AvgUnitprice,
count(p.ProductID) as Numproducts
from Products p
JOin Suppliers s ON p.SupplierID = s.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
Group by 1,2
Order by s.country,AvgUnitprice;


