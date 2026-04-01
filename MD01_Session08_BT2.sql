create table inventory
(
    product_id   serial primary key,
    product_name varchar(100),
    quantity     int
);

INSERT INTO inventory (product_name, quantity)
VALUES ('Mạch ESP32-DevKitC', 50),
       ('Cảm biến siêu âm HC-SR04', 120),
       ('Mô-đun Relay 4 kênh', 35),
       ('Màn hình LCD 16x2 I2C', 60),
       ('Động cơ Servo SG90', 85),
       ('Cảm biến nhiệt độ DHT22', 100),
       ('Pin Lithium 18650 3.7V', 200),
       ('Mạch nạp CP2102', 40),
       ('Bộ dây Jump đực-cái (40 sợi)', 300),
       ('Nguồn Adapter 12V-2A', 25);

-- Cập nhật thống kê
ANALYZE inventory;

create or replace procedure check_stock(in p_product_id int, in p_quantity int)
    language plpgsql
as
$$
declare
    v_quantity int;
begin
    select quantity into v_quantity from inventory where product_id = p_product_id;
    if v_quantity < p_quantity then
        raise exception 'Không đủ hàng trong kho (Product ID: %). Số lượng hiện có: %', p_product_id, v_quantity;
    else raise notice 'Product ID: % có đủ hàng trong kho. Số lượng hiện có: %', p_product_id, v_quantity;
    end if;
end;
$$;

drop procedure if exists check_stock(int, int);
call check_stock(1, 40);
call check_stock(2, 130);

