use guviproj2;
#sales,customers=customerkey;done
#sales,stores=storekey;done
#sales,product=productkey;done
#customer,stores=country,state;not needed

SELECT c.CustomerKey1,c.Gender1,c.Name1,c.City1,c.StateCode1,c.State1,c.ZipCode1,c.Country1,c.Continent1,c.Birthday1,s.OrderNumber1,s.LineItem1,s.OrderDate1,s.DeliveryDate1,s.CustomerKey1,s.StoreKey1,s.ProductKey1,s.Quantity1,s.CurrencyCode1 FROM customersdf c JOIN salesdf s ON c.CustomerKey1 = s.CustomerKey1;
DROP TABLE salesandcustomers;

UPDATE salesdf SET OrderDate1 = STR_TO_DATE(OrderDate1, '%m/%d/%Y');
ALTER TABLE salesdf ADD OrderYear1 INT;
UPDATE salesdf SET OrderYear1 = LEFT(OrderDate1, 4);


#salesandcustomers
CREATE TABLE salesandcustomers AS SELECT c.CustomerKey1,c.Gender1,c.Name1,c.City1,c.State1,c.Country1,c.Continent1,c.Birthyear1,s.OrderDate1,s.OrderYear1,s.StoreKey1,s.ProductKey1,s.Quantity1,s.CurrencyCode1 FROM customersdf c JOIN salesdf s ON c.CustomerKey1 = s.CustomerKey1;
ALTER TABLE salesandcustomers ADD ageyear1 INT;
UPDATE salesandcustomers SET ageyear1 = OrderYear1-BirthYear1 ;
SELECT * FROM salesandcustomers;

#sales_stores
UPDATE storesdf SET OpenDate1 = STR_TO_DATE(OpenDate1, '%m/%d/%Y');
CREATE TABLE salesandstores AS SELECT st.StoreKey1,st.Country1,st.State1,st.OpenDate1,s.CustomerKey1,s.OrderDate1,s.OrderYear1,s.ProductKey1,s.Quantity1,s.CurrencyCode1 FROM salesdf s JOIN storesdf st ON s.StoreKey1 = st.StoreKey1;
select * from salesandstores;

#customersandsalesandstore: too long giving error also not needed
select*from customersdf;
CREATE TABLE css AS SELECT sc.CustomerKey1,sc.Gender1,sc.Name1,sc.City1,sc.State1,sc.Country1,sc.Continent1,sc.Birthyear1,sc.OrderDate1,sc.OrderYear1,sc.StoreKey1,sc.ProductKey1,sc.Quantity1,sc.CurrencyCode1,ss.OpenDate1 FROM salesandcustomers sc JOIN salesandstores ss ON sc.StoreKey1 = ss.StoreKey1;

#sales_products;

UPDATE prdf
SET UnitCostUSD1 = CAST(REPLACE(SUBSTRING(UnitCostUSD1, 2), ',', '') AS DECIMAL(10,2));
UPDATE prdf
SET UnitPriceUSD1 = CAST(REPLACE(SUBSTRING(UnitPriceUSD1, 2), ',', '') AS DECIMAL(10,2));

select * from prdf;
ALTER TABLE prdf ADD profit FLOAT;
UPDATE prdf SET profit = UnitPriceUSD1-UnitCostUSD1 ;
CREATE TABLE sales_products AS SELECT s.CustomerKey1,s.StoreKey1,s.OrderDate1,s.Productkey1,s.OrderYear1,p.ProductName1,p.Brand1,p.Color1,p.Subcategory1,p.Category1,p.profit,p.UnitPriceUSD1 FROM salesdf s JOIN prdf p on s.ProductKey1 = p.ProductKey1;
select * from sales_products;

#category_state
CREATE TABLE category_state as 
select sp.subcategory1,sc.state1 from sales_products sp join salesandcustomers sc on sp.ProductKey1 = sc.ProductKey1;
select sp.brand1,sc.state1 from sales_products sp join salesandcustomers sc on sp.ProductKey1 = sc.ProductKey1;