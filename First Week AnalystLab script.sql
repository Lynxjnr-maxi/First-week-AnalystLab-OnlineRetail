--- DATABASE UNDERSTANDING
--------------------------------------
select * from dbo.OnlineRetailAnalyst  
select distinct InvoiceNo,stockcode,CustomerID,InvoiceDate,UnitPrice,Country 
from dbo.OnlineRetailAnalyst

--- DATA CLEANING
---------------------------------------
select 
sum(case when InvoiceNO is null then 1 else 0 end) as null_InvoiceNo,
sum(case when StockCode is null then 1 else 0 end) as null_StockCode,
sum(case when Description is null then 1 else 0 end) as null_Description,
sum(case when Quantity is null then 1 else 0 end) as null_Quantity,
sum(case when InvoiceDate is null then 1 else 0 end) as null_InvoiceDate,
sum(case when UnitPrice is null then 1 else 0 end) as null_UnitPrice,
sum(case when CustomerID is null then 1 else 0 end) as null_CustomerId,
sum(case when Country is null then 1 else 0 end) as null_Country
from dbo.OnlineRetailAnalyst

--- Looking for duplicates 
with delete_cte as(
select *,
row_number () over (partition by InvoiceNo,StockCode,Description,Quantity,InvoiceDate,
UnitPrice,CustomerID,Country order by InvoiceNo) as row_num
from dbo.OnlineRetailAnalyst  
)
delete from delete_cte
where row_num > 1

--- DATA STANDARDIZATION.
select * from dbo.OnlineRetailAnalyst
--- set description column into lower case with onl the fisrt letter as upper case
update dbo.OnlineRetailAnalyst
set Description = upper(left(Description,1)) 
                 + lower(substring(Description,2,len(Description)-1))

--- set the negative values in quantity column into positives 
update dbo.OnlineRetailAnalyst
set Quantity = ABS(quantity) 

--- Remove th timestamp from the InvoiceDate column 
alter table dbo.OnlineRetailAnalyst
alter column InvoiceDate date 

--- Set the UnitPrice to 2 decimal places
update dbo.OnlineRetailAnalyst
set UnitPrice = round(UnitPrice,2)

--- MEASURES EXPLORATION
----------------------------
--- Mean 
select avg(Quantity) as mean_Quantity,round(avg(UnitPrice),2) as mean_UnitPrice
from dbo.OnlineRetailAnalyst

--- Median
select percentile_cont(0.5)within group(order by Quantity)over () as median_quantity,
       percentile_cont(0.5)within group(order by UnitPrice)over () as meadian_UnitPrice
from dbo.OnlineRetailAnalyst

--- Minimum and Maximum
select max(Quantity) as max_quantity,min(Quantity) as min_quantity,
       max(UnitPrice) as max_UnitPrice, min(UnitPrice) as min_UnitPrice,
       max(InvoiceDate) as max_date, min(InvoiceDate) as min_date
from dbo.OnlineRetailAnalyst

--- Standard Deviation
select round(stdev(Quantity),2) as std_Quantity,
       round(stdev(UnitPrice),2) as std_UnitPrice
from dbo.OnlineRetailAnalyst

--- Total Invoices , Products(Stockcodes), Quantity sold, Revenue, Total countries
select 'Total_invoices' as measures_name ,count(InvoiceNo) as measures_value
from dbo.OnlineRetailAnalyst
union all
select 'Total_Distinct_invoices' as measures_name, count( distinct InvoiceNo) as measures_value
from dbo.OnlineRetailAnalyst
union all
select 'Total_Products_Sold' as measures_name, count(StockCode) as measures_value
from dbo.OnlineRetailAnalyst
union all
select 'Types_of_Products_Inventory' as meaures_name ,count(distinct StockCode) as measures_value
from dbo.OnlineRetailAnalyst
union all
select 'Quantity_Sold' as measures_name, sum(quantity) as measures_value
from dbo.OnlineRetailAnalyst
union all
select 'Revenue' as measures_name, round(sum(UnitPrice * Quantity),2) as measures_value
from dbo.OnlineRetailAnalyst
union all 
select 'Total_Customers' as measures_name, count(DISTINCT CustomerID) as measures_value
from dbo.OnlineRetailAnalyst

--- Top Selling Product
select StockCode, round(sum(UnitPrice * Quantity),2) as Revenue
from dbo.OnlineRetailAnalyst
group by StockCode
order by Revenue desc

--- Customer Purchasing Behavior
select CustomerID, count(distinct InvoiceNo) as total_Invoices,count(StockCode) as total_products,
round(sum(UnitPrice),2) as Revenue
from dbo.OnlineRetailAnalyst
group by CustomerID
having count(distinct InvoiceNo) > 1

--- lifespan (how long customers have been with us) - retention rate of 62%
select distinct CustomerID,datediff(month,min(InvoiceDate),max(InvoiceDate)) as lifespan_months
from dbo.OnlineRetailAnalyst
group by CustomerID
order by CustomerID asc

--- Highest Revenue generating countries
select distinct Country,round(sum(UnitPrice * Quantity),2) as Revenue,count(StockCode) as total_products_sold,
count( distinct CustomerID) as total_customers_served
from dbo.OnlineRetailAnalyst
group by Country
order by Revenue desc

--- Monthly Revenue Trend 
select  distinct month(InvoiceDate) as month,round(sum(UnitPrice * Quantity),2) as Revenue  
from dbo.OnlineRetailAnalyst
group by month(InvoiceDate)
order by Revenue desc

--- Product Revenue contribution
select distinct StockCode,round(sum(UnitPrice * Quantity),2) as Revenue,
round(sum(UnitPrice * Quantity) * 100.0 /sum(sum(UnitPrice * Quantity)) over (),2) as pct_contribution,
sum(quantity) as total_quantity_sold,round(avg(UnitPrice),2) as avg_price,
count(distinct Country) as countries_where_is_sold
from dbo.OnlineRetailAnalyst
group by StockCode 
order by revenue desc

--- Average Order Value (AOV) per customer
select distinct CustomerID,round(sum(UnitPrice * Quantity) * 1.0/count(distinct InvoiceNo),2) as AOV,
sum(UnitPrice * Quantity) as revenue
from dbo.OnlineRetailAnalyst
group by CustomerID
order by AOV asc

--- Customer report
GO
create or alter view customer_report as
with base_query as (
select distinct CustomerID,InvoiceNo,StockCode,Quantity,UnitPrice,Country,InvoiceDate
from dbo.OnlineRetailAnalyst
),
calculation_cte as (
select CustomerID,count(distinct InvoiceNo) as total_transactions,
    case when count(distinct InvoiceNo) > 1 then 'repeating customer' else 'one time customer'
    end as Customer_behavior,
datediff(month,min(InvoiceDate),max(InvoiceDate)) as lifespan_months,
count(StockCode) as total_variety_products_purchased,sum(quantity) as total_products_purchased,
round(sum(UnitPrice * Quantity),2) as Revenue,round(sum(UnitPrice * Quantity) * 1.0/count(distinct InvoiceNo),2) as AOV,
Country
from base_query
group by CustomerID,country
)
select * from Calculation_cte 
GO

--- PRODUCT REPORT
GO
create or alter view product_view as 
with base_query as (
select distinct StockCode,Description,Quantity,UnitPrice,CustomerID,InvoiceNo,country
from dbo.OnlineRetailAnalyst
),
calculation_cte as (
select StockCode,Description,sum(quantity) as total_products_sold,count(distinct InvoiceNo) as total_transactions,
round(sum(UnitPrice * Quantity),2) as Revenue,count(distinct CustomerID) as total_customers_bought,
count(distinct Country) as Number_Countries_sold
from base_query
group by StockCode,Description
)
select * from calculation_cte
GO 

select customerid  from dbo.customer_report
select * from dbo.OnlineRetailAnalyst
select * from dbo.product_view 
select count(distinct CustomerID) from dbo.OnlineRetailAnalyst


select distinct StockCode ,sum(quantity) as sum from dbo.OnlineRetailAnalyst
group by StockCode
order by sum desc
