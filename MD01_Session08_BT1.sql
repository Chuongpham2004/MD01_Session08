create table product.order_detail
(
    id           serial primary key,
    order_id     int,
    product_name varchar(100),
    quantity     int,
    unit_price   numeric
);

INSERT INTO product.order_detail (order_id, product_name, quantity, unit_price)
VALUES (101, 'Mạch ESP32 DevKit V1', 5, 120000),
       (101, 'Cảm biến DHT11', 10, 35000),
       (102, 'Laptop Dell G15', 1, 24500000),
       (103, 'Bàn phím cơ Akko 3068', 2, 1350000),
       (104, 'Chuột Logitech G102', 3, 450000),
       (105, 'Màn hình Dell Ultrasharp', 1, 6200000),
       (105, 'Cáp HDMI 2.1', 2, 150000),
       (106, 'Thẻ nhớ MicroSD 64GB', 5, 180000),
       (107, 'Nguồn 5V 2A', 4, 45000),
       (108, 'Module Sim800L', 2, 125000);


create procedure calculate_order_total(order_id_input int, out total numeric)
language plpgsql
as $$
    begin
        select sum(quantity * unit_price) into total
        from product.order_detail
        where order_id = order_id_input;
    end
$$;

do $$
    declare total_price numeric;
    begin
        call calculate_order_total(101, total_price);
        raise notice 'Tổng tien: %', total_price::text || ' VND';
    end;
    $$;


