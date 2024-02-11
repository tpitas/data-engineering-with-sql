-- Connect to the database emptdb 
psql -U postgres -h localhost -p 5432  -d emptdb 

-- Create table named employees_sub
select table employees_sub as
    select employee_id, first_name, last_name, salary 
    from employees
    where salary < 
    (
    select salary from employees
    where employee_id = 120 ) ;

-- Truncate the table
truncate table employees_sub;