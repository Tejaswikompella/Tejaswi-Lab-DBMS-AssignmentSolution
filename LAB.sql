CREATE DATABASE E_Warehouse;
use E_Warehouse;

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE supplier(
SUPP_ID INT,
SUPP_NAME VARCHAR(50) NOT NULL,
SUPP_CITY VARCHAR(50) NOT NULL,
SUPP_PHONE VARCHAR(50) NOT NULL,
PRIMARY KEY(SUPP_ID)
);

CREATE TABLE customer(
CUS_ID INT,
CUS_NAME VARCHAR(20) NOT NULL,
CUS_PHONE VARCHAR(10) NOT NULL,
CUS_CITY VARCHAR(30) NOT NULL,
CUS_GENDER CHAR,
PRIMARY KEY(CUS_ID)
);

CREATE TABLE category(
CAT_ID INT,
CAT_NAME VARCHAR(20) NOT NULL,
PRIMARY KEY (CAT_ID)
);

CREATE TABLE product(
PRO_ID INT,
PRO_NAME VARCHAR(20) NOT NULL DEFAULT 'Dummy',
PRO_DESC VARCHAR(60),
CAT_ID INT,
PRIMARY KEY (PRO_ID),
FOREIGN KEY (CAT_ID) REFERENCES 
category (CAT_ID)
);

CREATE TABLE supplier_pricing(
PRICING_ID INT,
PRO_ID INT,
SUPP_ID INT,
SUPP_PRICE INT DEFAULT '0',
PRIMARY KEY (PRICING_ID),
FOREIGN KEY (PRO_ID) REFERENCES product (PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES supplier (SUPP_ID)
);

CREATE TABLE orders(
ORD_ID INT,
ORD_AMOUNT INT NOT NULL,
ORD_DATE DATE NOT NULL,
CUS_ID INT,
PRICING_ID INT,
PRIMARY KEY (ORD_ID),
FOREIGN KEY (CUS_ID) REFERENCES customer (CUS_ID),
FOREIGN KEY (PRICING_ID) REFERENCES supplier_pricing (PRICING_ID)
);

CREATE TABLE rating (
RAT_ID INT,
ORD_ID INT,
RAT_RATSTARS INT NOT NULL,
PRIMARY KEY (RAT_ID),
FOREIGN KEY (ORD_ID) REFERENCES orders (ORD_ID)
);

INSERT INTO supplier
values(1,'Rajesh Retails','Delhi','1234567890'),
(2,'Appario Ltd.','Mumbai','2589631470'),
(3,'Knome products','Banglore','9785462315'),
(4,'Bansal Retails','Kochi','8975463285'),
(5,'Mittal Ltd.','Lucknow','7898456532');

INSERT INTO customer
VALUES (1,'AAKASH','9999999999','DELHI','M'),
(2,'AMAN','9785463215','NOIDA','M'),
(3,'NEHA','9999999999','MUMBAI','F'),
(4,'MEGHA','9994562399','KOLKATA','F'),
(5,'PULKIT','7895999999','LUCKNOW','M');

INSERT INTO category
values (1,'BOOKS'),
(2,'GAMES'),
(3,'GROCERIES'),
(4,'ELECTRONICS'),
(5,'CLOTHES');

INSERT INTO product
VALUES(1,'GTA V','Windows 7 and above with i5 processor and 8GB RAM',2),
(2,'TSHIRT','SIZE-L with Black, Blue and White variations',5),
(3,'ROG LAPTOP','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
(4,'OATS','Highly Nutritious from Nestle',3),
(5,'HARRY POTTER','Best Collection of all time by J.K Rowling',1),
(6,'MILK','1L Toned MIlk',3),
(7,'Boat Earphones','1.5Meter long Dolby Atmos',4),
(8,'Jeans','Stretchable Denim Jeans with various sizes and color',5),
(9,'Project IGI','compatible with windows 7 and above',2),
(10,'Hoodie','Black GUCCI for 13 yrs and above',5),
(11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
(12,'Train Your Brain','By Shireen Stephen',1);

INSERT INTO supplier_pricing
VALUES(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

INSERT INTO orders
VALUES (101,1500,'2021-10-06',2,1),
(102,1000,'2021-10-12',3,5),
(103,30000,'2021-09-16',5,2),
(104,1500,'2021-10-05',1,1),
(105,3000,'2021-08-16',4,3),
(106,1450,'2021-08-18',1,9),
(107,789,'2021-09-01',3,7),
(108,780,'2021-09-07',5,6),
(109,3000,'2021-00-10',5,3),
(110,2500,'2021-09-10',2,4),
(111,1000,'2021-09-15',4,5),
(112,789,'2021-09-16',4,7),
(113,31000,'2021-09-16',1,8),
(114,1000,'2021-09-16',3,5),
(115,3000,'2021-09-16',5,3),
(116,99,'2021-09-17',2,14);


INSERT INTO rating
VALUES (1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);

#3.Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
select cus_gender,count(*) from customer
left join orders on orders.Cus_ID = customer.cus_id
where orders.ord_amount >= 3000 group by cus_gender;

#4.Display all the orders along with product name ordered by a customer having Customer_Id=2
select o.* ,p.pro_name from orders o
left join supplier_pricing sp on sp.pricing_id = o.pricing_id
left join product p on p.pro_id = sp.pro_id
left join customer c on c.cus_id = o.cus_id
where c.cus_id = 2;

#5.Display the Supplier details who can supply more than one product
select s.* from supplier s
left join supplier_pricing sp on sp.supp_id = s.supp_id
group by sp.supp_id
having count(sp.supp_id) > 1;

#6.Find the least expensive product from each category and 
#print the table with category id, name, product name and price of the product
select c.*, p.pro_name, min(sp.supp_price) from category c
left join product p on p.cat_id = c.cat_id
left join supplier_pricing sp on sp.pro_id = p.pro_id
group by cat_name;

#7.Display the Id and Name of the Product ordered after “2021-10-05”.
select p.pro_id, p.pro_name from product p 
left join supplier_pricing sp on sp.pro_id = p.pro_id
left join orders o on o.pricing_id = sp.pricing_id
where ord_date > '2021-10-05';

#8.Display customer name and gender whose names start or end with character 'A'.
select cus_name,cus_gender from customer
where cus_name like 'a%' or
cus_name like '%a';

#9.Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
DROP  procedure if exists rating_proc
DELIMITER $$
CREATE PROCEDURE rating_proc()
BEGIN
	select s.supp_id,s.supp_name,r.rat_ratstars,
    CASE WHEN r.rat_ratstars > 4 then "Good service"
    WHEN r.rat_ratstars > 2 then "Average service"
    ELSE "Poor service"
    END Type_of_service
    from supplier s
    left join supplier_pricing sp on sp.supp_id = s.supp_id
    left join orders o on o.pricing_id = sp.pricing_id
    left join rating r on r.ord_id = o.ord_id
    ;
END$$
CALL rating_proc()
