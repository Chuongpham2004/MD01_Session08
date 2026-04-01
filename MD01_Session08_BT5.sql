CREATE TABLE employees
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary     NUMERIC(10, 2),
    bonus      NUMERIC(10, 2) DEFAULT 0
);

INSERT INTO employees (name, department, salary)
VALUES ('Nguyen Van A', 'HR', 4000),
       ('Tran Thi B', 'IT', 6000),
       ('Le Van C', 'Finance', 10500),
       ('Pham Thi D', 'IT', 8000),
       ('Do Van E', 'HR', 12000);

-- Cập nhật thống kê để tối ưu hóa truy vấn
ANALYZE employees;

ALTER TABLE employees
    ADD COLUMN status TEXT;

--1
create or replace procedure update_employees_status(in p_emp_id int, out p_status text)
    language plpgsql
as
$$
declare
    v_salary numeric;
begin
    select salary into v_salary from employees where id = p_emp_id;
    if v_salary < 5000 then
        p_status := 'Junior';
    elseif v_salary between 5000 and 10000 then
        p_status := 'Mid-level';
    else
        p_status := 'Senior';
    end if;
    update employees set status = p_status where id = p_emp_id;

exception
    when others then
        p_status := 'Employee not found';
end;
$$;

do
$$
    declare
        emp_status text;
    begin
        call update_employees_status(1, emp_status);
        raise notice '%', emp_status;
    end;
$$;





