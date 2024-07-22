create database quanlybanhang;
use quanlybanhang;

create table customers(
customer_id varchar(4) primary key not null,
customer_name varchar(100) not null,
email varchar(100) not null unique,
phone varchar(25) not null unique,
address varchar(225) not null 
);
insert into customers  values('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '0984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '0984875926', 'Ba Vì,Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '0904725784', 'Mộc Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh','anhpn@gmail.com', '0984635365', 'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '0989735624', 'Hai Bà Trưng, Hà Nội');
create table orders(
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
order_date date not null,
total_amount double not null,
foreign key (customer_id) references customers(customer_id)
);

insert into orders values ('H001', 'C001', str_to_date('22/02/2023','%d/%m/%Y'), 52999997),
       ('H002', 'C001', str_to_date('11/03/2023','%d/%m/%Y'), 80999997),
       ('H003', 'C002', str_to_date('22/01/2023','%d/%m/%Y'), 54359998),
       ('H004', 'C003', str_to_date('14/03/2023','%d/%m/%Y'), 102999995),
       ('H005', 'C003', str_to_date('12/03/2022','%d/%m/%Y'), 80999997),
       ('H006', 'C004', str_to_date('01/02/2023','%d/%m/%Y'), 110449994),
       ('H007', 'C004', str_to_date('29/03/2023','%d/%m/%Y'), 79999996),
       ('H008', 'C004', str_to_date('14/02/2023','%d/%m/%Y'), 29999998),
       ('H009', 'C005', str_to_date('10/01/2023','%d/%m/%Y'), 28999999),
       ('H010', 'C005', str_to_date('01/04/2023','%d/%m/%Y'), 149999994);
create table products(
product_id varchar(4) primary key not null,
product_name varchar(255) not null,
description text,
price double not null,
status bit(1) not null
);
insert into products values ('P001', 'iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8CPU 10CPU 8GB 256GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000, 1);
create table order_details(
order_id varchar(4)  not null,
product_id varchar(4)  not null,
price double not null,
quantity int(11) not null,
primary key (order_id, product_id),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id)
);
insert into order_details(order_id,product_id,price,quantity) values ('H001', 'P002', 14999999, 1),
       ('H001', 'P004', 18999999, 2),
       ('H002', 'P001', 22999999, 1),
       ('H002', 'P003', 28999999, 2),
       ('H003', 'P004', 18999999, 2),
       ('H003', 'P005', 4090000, 4),
       ('H004', 'P002', 14999999, 3),
       ('H004', 'P003', 28999999, 2),
       ('H005', 'P001', 22999999, 1),
       ('H005', 'P003', 28999999, 2),
       ('H006', 'P005',  4090000, 5),
       ('H006', 'P002', 14999999, 6),
       ('H007', 'P004', 18999999, 3),
       ('H007', 'P001', 22999999, 1),
       ('H008', 'P002', 14999999, 2),
       ('H009', 'P003', 28999999, 1),
       ('H010', 'P003', 28999999, 2),
       ('H010', 'P001', 22999999, 4);
       
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers . 
select customer_name as 'Tên' , email , 
phone as 'Số điện thoại' , address as 'Địa chỉ' 
from customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). 
select c.customer_name, c.phone, c.address from customers c
inner join orders o on c.customer_id = o.customer_id
where month(o.order_date) = 3 and year(o.order_date) = 2023;

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).
select month(order_date) as 'tháng',  format(round(sum(total_amount)),1,'vi_VN') as 'Tổng doanh thu'
from orders where year(order_date) = 2023 
group by month(order_date) 
order by month(order_date) asc;

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
select c.customer_name as 'Tên khách hàng', c.address as 'Địa chỉ',
c.email , c.phone as 'Số điện thoại'
from customers c where c.customer_id  
not in (
    select distinct customer_id 
    from orders o
    where month(o.order_date) = 2 and year(o.order_date) = 2023
);


-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
select p.product_id as 'Mã sản phẩm', p.product_name as 'Tên sản phẩm' , sum(od.quantity) as 'Số lượng bán ra'
from products p inner join order_details od on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
where month(o.order_date) = 3 and year(o.order_date) = 2023
group by p.product_id , p.product_name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu
-- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select c.customer_id as 'Mã khách hàng', c.customer_name as 'Tên khách hàng', format(round(sum(total_amount)),1,'vi_VN') as 'Mức chi tiêu' 
from customers c inner join orders o on c.customer_id = o.customer_id
where year(o.order_date) = 2023
group by c.customer_id, c.customer_name
order by sum(o.total_amount) desc;


-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên 
-- (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . 
select c.customer_name as 'Người mua', o.total_amount as 'Tổng tiền',
 o.order_date as 'Ngày tạo', 
sum(od.quantity) as 'Tổng số lượng' 
from order_details od 
inner join orders o on od.order_id = o.order_id
inner join customers c on o.customer_id = c.customer_id
group by o.order_id, c.customer_name, o.total_amount, o.order_date
having sum(od.quantity) >= 5;

# Bài 4: Tạo View, Procedure :
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn .
create view get_info_order as
select c.customer_name, c.phone, c.address, o.total_amount, o.order_date
from orders o inner join customers c on o.customer_id = c.customer_id;


-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. 
create view get_info_customers as
select c.customer_name, c.address, c.phone, count(o.order_id) AS total_order
FROM customers c
         left join orders o ON c.customer_id = o.customer_id
group by c.customer_id;


-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
create view show_info_product as
select p.product_name as 'Tên sản phẩm', p.description as 'Mô tả' , format(round(p.price),1,'vi_VN') as 'Giá tiền' , sum(od.quantity) as 'Tổng số lượng đã bán ra'
from products p inner join order_details od on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
group by p.product_id;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. 
create index index_phone on customers(phone);
create index index_email on customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
delimiter //
create procedure getAllCustomers(
	in customer_id_index varchar(4)
)
begin 
	select * from customers where customer_id = customer_id_in;
end; //
delimiter ;



-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. 
delimiter //
create procedure getAllProducts ()
begin
	select * from products;
end; //
	
delimiter ;


-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. 
delimiter //
create procedure getListOrdersByCustomer(
	in customer_id_in varchar(4)
)
begin
	select * from orders where customer_id = customer_id_in;
end;//

delimiter ;







