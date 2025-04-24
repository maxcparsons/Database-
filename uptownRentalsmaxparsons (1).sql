-- Max Parsons, Project 1
-- SQL script for Uptown Rentals database project and questions 
-- March 26th, 2025 

use uptown; 
-- Qa. What is the list of all instrument rentals in inventory? 
-- (Show the list displayed in Figure 1, along with any other rentals in your database.) 
-- *should display what is in Figure 1* 
SELECT  
    rentals.Serial_Num,
	customers.Customer_Name,
	rentals.Rental_Date,
    instruments.Instrument_Type,
    instruments.Rental_Tier,
    rentals.Contact_Email,
	staff.Staff_FName, 
    staff.Staff_LName,
    rentals.Return_Date, 
    rentals.Due_Date, 
    rentals.Daily_Rental_Fee, 
    rentals.Daily_Overdue_Fee
FROM rentals, instruments, staff, customers
WHERE rentals.Instruments_Serial_Num = instruments.Serial_Num
AND rentals.Instruments_Instrument_Condition_Serial_Num = instruments.Instrument_Condition_Serial_Num
AND rentals.StaffID = staff.StaffID
AND rentals.Contact_Email = customers.Contact_Email;


-- Qb. What are the youngest and oldest customers of Uptown Rentals? 
-- Write one program to display both. 
-- *Min and Max*
SELECT MIN(Customer_Age), MAX(Customer_Age)
FROM customers;
-- Qc. List the aggregated (summed) rental amounts per customer. 
-- Sequence the customer with the highest rental amount first. 
-- *Descending Order*
SELECT customers.Customer_Name, SUM(rentals.Daily_Rental_Fee * (DATEDIFF(rentals.Return_Date, rentals.Rental_Date))) AS Total_Rental_Amount
FROM rentals, customers
WHERE rentals.Contact_Email = customers.Contact_Email
GROUP BY customers.Customer_Name
ORDER BY Total_Rental_Amount DESC;
-- Qd. Which customer has the most rentals (the highest count) across all time? 
-- *COUNT*
SELECT customers.Customer_Name, COUNT(rentals.Rental_ID) AS Total_Rentals
FROM rentals, customers
WHERE rentals.Contact_Email = customers.Contact_Email
GROUP BY customers.Customer_Name
ORDER BY Total_Rentals DESC;
-- Qe. Which customer had the most rentals in January 2025
-- and what was their average rental total per rental? 
-- *Filtering, REGEX or LIKE*
SELECT customers.Customer_Name, COUNT(rentals.Rental_ID) AS Total_Rentals, 
AVG(rentals.Daily_Rental_Fee * (DATEDIFF(rentals.Return_Date, rentals.Rental_Date))) AS Avg_Rental_Amount
FROM rentals, customers
WHERE rentals.Contact_Email = customers.Contact_Email
AND rentals.Rental_Date LIKE '2025-01-%'
GROUP BY customers.Customer_Name
ORDER BY Total_Rentals DESC
LIMIT 2; 

-- Qf. Which staff member (name) is associated with the most rentals in January 2025? 
SELECT staff.Staff_FName, staff.Staff_LName, COUNT(rentals.Rental_ID) AS Total_Rentals
FROM rentals, staff
WHERE rentals.StaffID = staff.StaffID
AND rentals.Rental_Date LIKE '2025-01-%'
GROUP BY staff.StaffID
ORDER BY Total_Rentals DESC
LIMIT 1;

-- Qg. For each customer that has an overdue rental, 
-- how many days have passed since the rental was due?
SELECT customers.Customer_Name, rentals.Contact_Email, 
rentals.Due_Date, rentals.Return_Date,
IF(rentals.Return_Date > rentals.Due_Date, DATEDIFF(rentals.Return_Date, rentals.Due_Date), 0) AS Days_Overdue
FROM rentals
JOIN customers ON rentals.Contact_Email = customers.Contact_Email
WHERE rentals.Return_Date < CURDATE() 
ORDER BY Days_Overdue DESC;

-- Qh. What is the total rental amount by Rental tier?
SELECT instruments.Rental_Tier, SUM(rentals.Daily_Rental_Fee * DATEDIFF(rentals.Return_Date, rentals.Rental_Date)) AS Total_Rental_Amount
FROM rentals, instruments
WHERE rentals.Instruments_Serial_Num = instruments.Serial_Num
GROUP BY instruments.Rental_Tier
ORDER BY Total_Rental_Amount DESC;

-- Qi. Who are the top three store staff members in terms of total rental amounts?
SELECT staff.Staff_FName, staff.Staff_LName, SUM(rentals.Daily_Rental_Fee * DATEDIFF(rentals.Return_Date, rentals.Rental_Date)) AS Total_Rental_Amount
FROM rentals, staff
WHERE rentals.StaffID = staff.StaffID
GROUP BY staff.Staff_FName, staff.Staff_LName
ORDER BY Total_Rental_Amount DESC;

-- Qj. What is the total rental amount by instrument type,
-- where the instrument type is Flute or Bass Guitar?
SELECT instruments.Instrument_Type, SUM(rentals.Daily_Rental_Fee * DATEDIFF(rentals.Return_Date, rentals.Rental_Date)) AS Total_Rental_Amount
FROM rentals
INNER JOIN instruments ON rentals.Instruments_Serial_Num = instruments.Serial_Num
WHERE instruments.Instrument_Type IN ('Flute', 'Bass Guitar')
GROUP BY instruments.Instrument_Type;

-- Qk. What is the name of any customer who has two or more overdue rentals?
SELECT customers.Customer_Name
FROM rentals
INNER JOIN customers ON rentals.Contact_Email = customers.Contact_Email
WHERE rentals.Due_Date < CURDATE() AND rentals.Return_Date > rentals.Due_Date
GROUP BY customers.Customer_Name
HAVING COUNT(rentals.Rental_ID) >= 2;

-- Ql.	List all of the instruments in inventory in 2025 that were damaged upon 
-- return or needed maintenance. Include the employee that handled the rental, 
-- the repair cost, and the maintenance date.
SELECT instruments.Serial_Num AS Instruments_Serial_Num, instruments.Instrument_Type, 
instrument_condition.Condition_Status, instrument_condition.Maintenance_Date, 
repair.Repair_Cost, staff.Staff_FName, staff.Staff_LName
FROM rentals
JOIN instruments ON rentals.Instruments_Serial_Num = instruments.Serial_Num
JOIN instrument_condition ON rentals.Instruments_Instrument_Condition_Serial_Num = instrument_condition.Serial_Num  
JOIN staff ON rentals.StaffID = staff.StaffID
JOIN repair ON rentals.Instruments_Serial_Num = repair.Instruments_Serial_Num  
WHERE instrument_condition.Condition_Status IN ('Needs Maintenance')  
AND YEAR(instrument_condition.Maintenance_Date) = 2025  
AND YEAR(rentals.Rental_Date) = 2025;

-- Qm. Which rentals have a rental amount greater than the average rental amount?
SELECT rentals.Rental_ID, rentals.Serial_Num, rentals.Contact_Email,
rentals.Daily_Rental_Fee * (DATEDIFF(rentals.Return_Date, rentals.Rental_Date)) AS Rental_Amount
FROM rentals
WHERE (rentals.Daily_Rental_Fee * (DATEDIFF(rentals.Return_Date, rentals.Rental_Date))) 
> (SELECT AVG(Daily_Rental_Fee * (DATEDIFF(Return_Date, Rental_Date))) FROM rentals);

-- Qn. What is the name of any customer who has rented 2 or more woodwind Instruments?
SELECT customers.Customer_Name
FROM rentals
JOIN instruments ON rentals.Instruments_Serial_Num = instruments.Serial_Num
JOIN customers ON rentals.Contact_Email = customers.Contact_Email
WHERE instruments.Category = 'Woodwind'
GROUP BY customers.Customer_Name
HAVING COUNT(rentals.Rental_ID) >= 2;