 -- select statement to filter employees with last name "schueller" 
SELECT * FROM "public"."employees"
WHERE last_name = 'Schueller';

-- filter all the female employees and born after 1965-1-26 in the company
SELECT first_name, last_name, gender, birth_date FROM "public"."employees"
WHERE gender = 'F' AND birth_date > '1965-1-26';

-- IN keyword
SELECT * FROM "public"."employees"
WHERE emp_no IN (11111);

-- Find the age of all employees who's name starts with M.
SELECT emp_no, first_name, EXTRACT (YEAR FROM AGE(birth_date)) AS "age" FROM "public"."employees"
WHERE first_name ILIKE 'm%';

--How many people's name start with A and end with R?
SELECT count(emp_no) FROM "public"."employees"
WHERE first_name ILIKE 'a%r';

SHOW timezone;

--check employee's age
SELECT age(birth_date) FROM "public"."employees";

--how many employees are manager
SELECT count(b.emp_no)
FROM "public"."employees" AS a
LEFT JOIN "public"."dept_manager" AS b
ON a.emp_no = b.emp_no
WHERE b.emp_no IS NOT NULL;


--Show each employee which department they work in
SELECT a.first_name, a.last_name, c.dept_name
FROM "public"."employees" AS a
INNER JOIN "public"."dept_emp" AS B
ON a.emp_no = b.emp_no
INNER JOIN "public"."departments" AS C
ON b.dept_no = c.dept_no
ORDER BY a.last_name;


--How many people were hired on any given hire date?
SELECT hire_date, count(emp_no) AS num
FROM "public"."employees"
GROUP BY hire_date;


-- Show all the employees, hired after 1991, that have had more than 2 titles
SELECT  b.first_name, b.last_name, a.emp_no, a.count
FROM (SELECT emp_no, count(title)
        FROM "public"."titles"
        WHERE from_date > '1991-01-01'
        GROUP BY emp_no
        HAVING count(title) > 2
        ORDER BY emp_no) AS a
INNER JOIN "public"."employees" AS B 
ON a.emp_no = b.emp_no;
;


--Show all the employees that have had more than 15 salary changes that work in the department development
SELECT e.emp_no, e.first_name, e.last_name, dep.dept_name, salary.times FROM "public"."employees" AS e
INNER JOIN "public"."dept_emp" AS de
ON e.emp_no = de.emp_no
INNER JOIN "public"."departments" AS dep
ON dep.dept_no = de.dept_no

INNER JOIN (SELECT emp_no, count(salary) AS times FROM "public"."salaries"
            GROUP BY emp_no
            HAVING count(salary) > 15
            ORDER BY emp_no) AS salary
ON e.emp_no = salary.emp_no
WHERE dep.dept_name = 'Development';
;

--Show all the employees that have worked for multiple departments
SELECT e.emp_no, e.first_name, e.last_name, count(de.dept_no)
FROM "public"."employees" AS e
INNER JOIN "public"."dept_emp" AS de
ON e.emp_no = de.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
HAVING count(de.dept_no) > 1
ORDER BY emp_no;


-- add a column for max salary
SELECT  *, max(salary) OVER(PARTITION BY emp_no)
FROM "public"."salaries";


-- show salary change times of each employee
SELECT emp_no, salary, 
       count( salary ) OVER( PARTITION BY emp_no ORDER BY salary )
FROM "public"."salaries";


-- Create a view "90-95" that hows all the employees, hired between 1990 and 1995
CREATE OR REPLACE VIEW "90-95" AS 
SELECT emp_no, first_name, last_name, hire_date
FROM "public"."employees"
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 1990 AND 1995;

SELECT * FROM "90-95";



-- Create a view "bigbucks" that show all employees that have ever had a salary over 80000
EXPLAIN  ANALYZE -- show the query excute process
CREATE VIEW "bigbucks" AS 
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM "public"."employees" AS e
INNER JOIN "public"."salaries" AS s
ON e.emp_no = s.emp_no
WHERE s.salary > 80000;

SELECT * FROM "bigbucks";


--Filter employees who have emp_no 110183 as a manager
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (
    SELECT emp_no
    FROM dept_emp
    WHERE dept_no = (
        SELECT dept_no 
        FROM dept_manager
        WHERE emp_no = 110183;
    )
);

-- Written with JOIN
SELECT e.emp_no, first_name, last_name
FROM employees AS e
JOIN dept_emp AS de USING (emp_no)
JOIN dept_manager AS dm USING (dept_no)
WHERE dm.emp_no = 110183




