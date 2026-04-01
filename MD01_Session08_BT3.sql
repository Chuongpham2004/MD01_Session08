create table employees
(
    emp_id    serial primary key,
    emp_name  varchar(100),
    job_level int,
    salary    numeric
);

INSERT INTO employees (emp_name, job_level, salary)
VALUES ('Nguyen Van A', 1, 5000000),
       ('Tran Thi B', 2, 12000000),
       ('Le Van C', 3, 25000000),
       ('Pham Thi D', 1, 5500000),
       ('Do Van E', 2, 13500000),
       ('Hoang Van F', 3, 30000000),
       ('Vu Thi G', 1, 4800000),
       ('Dang Van H', 2, 11000000),
       ('Bui Thi I', 3, 28000000),
       ('Ly Van J', 1, 5200000);

-- Cập nhật thống kê
ANALYZE employees;

CREATE PROCEDURE adjust_salary(in p_emp_id int, out p_new_salary numeric)
    language plpgsql
as
$$
declare
    v_job_level int;
    v_salary    numeric;
begin
    select job_level, salary into v_job_level, v_salary from employees where emp_id = p_emp_id;
    if v_job_level = 1 then
        p_new_salary := v_salary * 1.05;
    elsif v_job_level = 2 then
        p_new_salary := v_salary * 1.1;
    else
        p_new_salary := v_salary * 1.15;
    end if;
    update employees set salary = p_new_salary where emp_id = p_emp_id;
end;
$$;

DO
$$
    declare
        new_salary numeric;
    begin
        call adjust_salary(1, new_salary);
        raise notice 'New salary: %', new_salary;
        end;
$$;