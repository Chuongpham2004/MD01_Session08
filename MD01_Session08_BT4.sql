create table products
(
    id               serial primary key,
    name             varchar(100),
    price            numeric,
    discount_percent int
);

INSERT INTO products (name, price, discount_percent)
VALUES ('Laptop Gaming ASUS ROG', 35000000, 10),
       ('Bàn phím cơ Akko 3098B', 1850000, 5),
       ('Chuột không dây Logitech MX Master 3', 2500000, 0),
       ('Màn hình Dell UltraSharp 27 inch', 8900000, 15),
       ('Mạch ESP32-WROOM-32', 125000, 20),
       ('Cảm biến nhịp mãnh MAX30102', 85000, 0),
       ('Tai nghe Sony WH-1000XM5', 6500000, 12),
       ('Sạc dự phòng Anker 20000mAh', 1200000, 8),
       ('Module GPS Neo-6M', 210000, 5),
       ('Ổ cứng SSD Samsung 980 Pro 1TB', 3200000, 25);

-- Cập nhật thống kê cho bảng
ANALYZE products;

--1
create procedure calculate_discount(in p_id int, out p_final_price numeric)
language plpgsql
as $$
    declare v_price numeric;
            v_discount_percent int;
    begin
        select price, discount_percent into v_price, v_discount_percent
        from products
        where id = p_id;

        if not found then
            raise exception 'Product not found (ID: %)', p_id;
        end if;

        p_final_price := v_price * (1 - v_discount_percent / 100.0);

        if v_discount_percent > 50 then v_discount_percent := 50; end if;
        update products set price = p_final_price, discount_percent = v_discount_percent where id = p_id;
    end;
    $$;

do $$
    declare final_price numeric;
        begin
           call calculate_discount(1, final_price);
            raise notice 'Final price: %', final_price;
        end;
    $$;