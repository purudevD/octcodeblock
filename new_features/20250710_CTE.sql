
SELECT CEIL(AVG(salary)) AS avg_sal, 'Avg sal high paid' AS describe_v
FROM
(
SELECT 
	emp_man_sal_comp.*,
	CASE
		WHEN emp_man_sal_comp.salary > emp_man_sal_comp.manager_salary THEN 'Over Paid'
		WHEN emp_man_sal_comp.manager_salary IS NULL THEN 'Not Applicable'
		--WHEN a.salary <= a.manager_salary THEN 'Right Paid'
		ELSE 'Right Paid'
	END AS emp_class
FROM
	(SELECT e.*,
			m.salary AS manager_salary
	FROM employee_information_tab AS e
	LEFT JOIN
		employee_information_tab AS m
	ON
		e.manager_id = m.employee_id) AS emp_man_sal_comp
	) AS temp_tab
	WHERE emp_class = 'Over Paid'

UNION



SELECT CEIL(AVG(salary)) AS avg_sal, 'Avg sal Low paid' AS describe_v
FROM
(
SELECT 
	emp_man_sal_comp.*,
	CASE
		WHEN emp_man_sal_comp.salary > emp_man_sal_comp.manager_salary THEN 'Over Paid'
		WHEN emp_man_sal_comp.manager_salary IS NULL THEN 'Not Applicable'
		--WHEN a.salary <= a.manager_salary THEN 'Right Paid'
		ELSE 'Right Paid'
	END AS emp_class
FROM
	(SELECT e.*,
			m.salary AS manager_salary
	FROM employee_information_tab AS e
	LEFT JOIN
		employee_information_tab AS m
	ON
		e.manager_id = m.employee_id) AS emp_man_sal_comp
	) AS temp_tab
	WHERE emp_class = 'Right Paid'
	
	
	
	--- CTE  -- SubQuery Factorization
WITH emp_manager_sal_class
AS
(
SELECT 
	emp_man_sal_comp.*,
	CASE
		WHEN emp_man_sal_comp.salary > emp_man_sal_comp.manager_salary THEN 'Over Paid'
		WHEN emp_man_sal_comp.manager_salary IS NULL THEN 'Not Applicable'
		--WHEN a.salary <= a.manager_salary THEN 'Right Paid'
		ELSE 'Right Paid'
	END AS emp_class
FROM
	(SELECT e.*,
			m.salary AS manager_salary
	FROM employee_information_tab AS e
	LEFT JOIN
		employee_information_tab AS m
	ON
		e.manager_id = m.employee_id) AS emp_man_sal_comp
) --- At this point of time the CTE is alive

SELECT * FROM emp_manager_sal_class -- as soon as you run a query on the CTE the CTE is used to execute the execute
-- and immediately the CTE is destroyed

-- This query will not be executed and will throw an error
SELECT AVG(salary), --- at this point of time the CTE does not exists any more
		'Average salary high paid' AS sal_desc
FROM emp_manager_sal_class
	WHERE emp_class = 'Over Paid'

UNION

SELECT AVG(salary),
		'Average salary right paid' AS sal_desc
FROM emp_manager_sal_class
	WHERE emp_class = 'Right Paid' ;



-- where I can see the people who earn max salary and people who earn min salary in their departments

SELECT employees.*
FROM
employees
INNER JOIN
(SELECT employee_dept, MAX(salary) AS max_sal
FROM
	employees
GROUP BY
	employee_dept) AS max_sal_de
ON
	employees.employee_dept = max_sal_de.employee_dept
AND
	employees.salary  = max_sal_de.max_sal
UNION
SELECT employees.*
FROM
employees
INNER JOIN
(SELECT employee_dept, MIN(salary) AS min_sal
FROM
	employees
GROUP BY
	employee_dept) AS min_sal_de
ON
	employees.employee_dept = min_sal_de.employee_dept
AND
	employees.salary  = min_sal_de.min_sal
	
	
-- USE of multiple CTE
-- use CTE to solve the same problem
WITH max_sal_d
AS
(
SELECT employee_dept, MAX(salary) AS max_sal
FROM
	employees
GROUP BY
	employee_dept
) ,

-- second CTE min sal by department
min_sal_d
AS
(
	SELECT employee_dept, MIN(salary) AS min_sal
	FROM
		employees
	GROUP BY
		employee_dept
)

SELECT e.*
FROM employees AS e
INNER JOIN
	max_sal_d AS ma
ON
	e.employee_dept = ma.employee_dept
AND
	e.salary = ma.max_sal

UNION

SELECT e.*
FROM employees AS e
INNER JOIN
	min_sal_d AS ma
ON
	e.employee_dept = ma.employee_dept
AND
	e.salary = ma.min_sal
ORDER BY employee_dept, salary DESC


-- If an employee earns less than 85% of the average salary of their respective department
-- that employee is classified as low paid

-- if an employee earns between 85% and 150% of the Average sala of their department then that emp is average paid

-- if an employee earns above 150% of the average salary of their department then that empl is high paid


-- CTE
WITH
	avg_sal_dept
	AS
	(
			SELECT 		employee_dept, 
						AVG(salary) AS avg_sal 
			FROM employees GROUP BY employee_dept
	)

SELECT * ,
		CASE

			WHEN salary < 0.85 * avg_sal THEN 'Low Paid'
			WHEN salary BETWEEN 85/100 * avg_sal AND 150/100 * avg_sal THEN 'Average Paid'
			ELSE 'High Paid'
			
		END AS salary_class
		FROM
employees AS e
INNER JOIN
avg_sal_dept AS a
ON
	e.employee_dept = a.employee_dept;


--- get a count of people who are classified as low paid, high paid and average paid


WITH
	avg_sal_dept
	AS
	(
			SELECT 		employee_dept, 
						AVG(salary) AS avg_sal 
			FROM employees GROUP BY employee_dept
	)
	,

emp_sal_class
AS
(
SELECT e.* ,
		a.avg_sal,
		CASE

			WHEN salary < 0.85 * avg_sal THEN 'Low Paid'
			WHEN salary BETWEEN 85/100 * avg_sal AND 150/100 * avg_sal THEN 'Average Paid'
			ELSE 'High Paid'
			
		END AS salary_class
		FROM
employees AS e
INNER JOIN
avg_sal_dept AS a
ON
	e.employee_dept = a.employee_dept
)


SELECT salary_class, COUNT(*) AS emp_count FROM emp_sal_class
GROUP BY salary





SELECT * FROM sales_info FETCH FIRST 10 ROWS ONLY;


-- FIND the transactions that have a total bill value 
-- greater than average of total bill for the entire table 

SELECT *,
		quantity* price_per_unit AS total_bill,
		(SELECT 	CAST(AVG(quantity * price_per_unit) AS INT)
		FROM sales_info) AS avg_total_bill
FROM sales_info
WHERE
(quantity * price_per_unit) > (
SELECT 	CAST(AVG(quantity * price_per_unit) AS INT)
		FROM sales_info)

SELECT 	CAST(AVG(quantity * price_per_unit) AS INT) AS avg_total_bill
		FROM sales_info



-- Solve the above problem using a CTE
WITH avg_total_bill_cte
AS
(

SELECT 	CAST(AVG(quantity * price_per_unit) AS INT) AS avg_total_bill
		FROM sales_info

)

SELECT sales_info.*,
		avg_total_bill_cte.avg_total_bill
FROM 
sales_info
INNER JOIN
avg_total_bill_cte
ON
(sales_info.quantity * sales_info.price_per_unit) > avg_total_bill_cte.avg_total_bill

-- Homework - 1
-- find all the months that have lower than AVERAGE sales by Month?