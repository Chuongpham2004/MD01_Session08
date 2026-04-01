CREATE OR REPLACE PROCEDURE calculate_bonus(
    IN p_emp_id INT,
    IN p_percent NUMERIC,
    OUT p_bonus NUMERIC
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_salary NUMERIC;
BEGIN
    -- 1. Lấy lương
    SELECT salary INTO v_salary FROM employees WHERE id = p_emp_id;

    -- 2. Kiểm tra xem có tìm thấy dòng nào không bằng biến FOUND
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found (ID: %)', p_emp_id;
    END IF;

    -- 3. Logic tính toán (Bạn làm đoạn này rất tốt)
    IF p_percent <= 0 THEN
        p_bonus := 0;
    ELSE
        p_bonus := v_salary * p_percent / 100;
    END IF;

    -- 4. Cập nhật bảng
    UPDATE employees SET bonus = p_bonus WHERE id = p_emp_id;

-- Khối EXCEPTION này giờ sẽ bắt các lỗi bất ngờ khác (nếu có)
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An unexpected error occurred: %', SQLERRM;
        p_bonus := NULL;
END;
$$;

DO $$
    declare emp_bonus numeric;
        begin
            call calculate_bonus(1, 10, emp_bonus);
            raise notice 'Bonus: %', emp_bonus;
        end;
    $$;