-- Alter data types to reflect accurate meaning of data

ALTER TABLE AbsenteeismAtWork
ALTER COLUMN Disciplinary_failure BIT;

ALTER TABLE AbsenteeismAtWork
ALTER COLUMN Social_drinker BIT;

ALTER TABLE AbsenteeismAtWork
ALTER COLUMN Social_smoker BIT;

ALTER TABLE AbsenteeismAtWork
ALTER COLUMN Absenteeism_time_in_hours FLOAT;

ALTER TABLE AbsenteeismAtWork
ALTER COLUMN Pet BIT;


-- QUESTION ONE: 
-- Find the healthiest employees [defined as non-smoker, non drinker, BMI < 25, and absent less than the total employee average absent hours].

-- Budget = $100,000 [given by HR] for healthy individuals with low absenteeism
-- These employees get a bonus. 

SELECT ID AS EmployeeID
FROM AbsenteeismAtWork
WHERE Social_drinker = 0 AND Social_smoker = 0 AND Body_mass_index < 25 AND 
Absenteeism_time_in_hours < (SELECT AVG(Absenteeism_time_in_hours)
FROM AbsenteeismAtWork);

-- 111 employees fit this criteria. 
-- $100,000 / 111 = about $900 bonus for each of these employees listed. 


-- QUESTION TWO: 
-- Find the employees who do not smoke.

-- Budget = $983,221 [given from HR] for non-smokers
-- These employees get an hourly increase rate determined by the budget and total non-smokers in the company. 

SELECT COUNT(*) AS NonSmokerEmployees
FROM AbsenteeismAtWork
WHERE Social_smoker = 0;

-- 686 employees fit this criteria.
-- 8 hours per day x 5 days per week x 52 weeks per year x 686 non-smoker employees = 1,426,880
-- $983,221 (budget) / 1,426,880 = $0.68 / hour increase for non-smoker employees.

-- QUESTION THREE:
-- What is the most common reason for absenteeism?

SELECT Reasons.Reason, COUNT(ID) AS Total_Count
FROM AbsenteeismAtWork
LEFT JOIN Reasons ON AbsenteeismAtWork.Reason_for_absence = Reasons.Number
GROUP BY Reasons.Reason
ORDER BY Total_Count DESC;

-- QUESTION FOUR:
-- Is there a particular month or day of the week with higher absenteeism rates?

SELECT Day_of_the_week,
CASE
    WHEN Day_of_the_week = 2 THEN 'Monday'
    WHEN Day_of_the_week = 3 THEN 'Tuesday'
    WHEN Day_of_the_week = 4 THEN 'Wednesday'
    WHEN Day_of_the_week = 5 THEN 'Thursday'
    WHEN Day_of_the_week = 6 THEN 'Friday'
    ELSE 'Unknown'
END AS DayofTheWeek, COUNT(ID) AS Total_Count
FROM AbsenteeismAtWork
GROUP BY Day_of_the_week
ORDER BY Total_Count DESC;

SELECT Month_of_absence,
CASE
    WHEN Month_of_absence = 1 THEN 'January'
    WHEN Month_of_absence = 2 THEN 'February'
    WHEN Month_of_absence = 3 THEN 'March'
    WHEN Month_of_absence = 4 THEN 'April'
    WHEN Month_of_absence = 5 THEN 'May'
    WHEN Month_of_absence = 6 THEN 'June'
    WHEN Month_of_absence = 7 THEN 'July'
    WHEN Month_of_absence = 8 THEN 'August'
    WHEN Month_of_absence = 9 THEN 'September'
    WHEN Month_of_absence = 10 THEN 'October'
    WHEN Month_of_absence = 11 THEN 'November'
    WHEN Month_of_absence = 12 THEN 'December'
    ELSE 'Unknown'
END AS MonthOfAbsence, COUNT(ID) AS Total_Count
FROM AbsenteeismAtWork
GROUP BY Month_of_absence
ORDER BY Total_Count DESC;

-- QUESTION FIVE:
-- Do employees with higher education levels tend to have lower absenteeism rates?

SELECT Education, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM AbsenteeismAtWork
GROUP BY Education
ORDER BY Average_Hours_Absent;

-- QUESTION SIX:
-- Are employees with longer commutes more likely to be absent?

WITH Distance 
AS 
(
SELECT Distance_from_Residence_to_Work,
CASE
    WHEN Distance_from_Residence_to_Work < 10 THEN 'Less than 10 miles'
    WHEN Distance_from_Residence_to_Work >= 10 AND Distance_from_Residence_to_Work < 20 THEN 'Between 10 and 19 miles'
    WHEN Distance_from_Residence_to_Work >= 20 AND Distance_from_Residence_to_Work < 30 THEN 'Between 20 and 29 miles'
    WHEN Distance_from_Residence_to_Work >= 30 AND Distance_from_Residence_to_Work < 40 THEN 'Between 30 and 39 miles'
    WHEN Distance_from_Residence_to_Work >= 40 AND Distance_from_Residence_to_Work < 50 THEN 'Between 40 and 49 miles'
    WHEN Distance_from_Residence_to_Work >= 50 THEN 'Greater than 50 miles'
    ELSE 'Unknown'
END AS DistanceToWork, Absenteeism_time_in_hours
FROM AbsenteeismAtWork
GROUP BY Distance_from_Residence_to_Work, Absenteeism_time_in_hours
)

SELECT DistanceToWork, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM Distance
GROUP BY DistanceToWork
ORDER BY Average_Hours_Absent DESC;

-- QUESTION SEVEN
-- How does the length of employment tenure impact absenteeism?

WITH Tenure 
AS 
(
SELECT Service_time,
CASE
    WHEN Service_time < 2 THEN 'Less than 2 years at company'
    WHEN Service_time >= 2 AND Service_time <= 5 THEN '2-5 years at company'
    WHEN Service_time >= 6 AND Service_time <= 10 THEN '6-10 years at company'
    WHEN Service_time >= 11 AND Service_time <= 15 THEN '11-15 years at company'
    WHEN Service_time >= 16 AND Service_time <= 20 THEN '16-20 years at company'
    WHEN Service_time >= 21 THEN 'More than 20 years at company'
    ELSE 'Unknown'
END AS TimeAtCompany, Absenteeism_time_in_hours
FROM AbsenteeismAtWork
GROUP BY Service_time, Absenteeism_time_in_hours
)

SELECT TimeAtCompany, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM Tenure
GROUP BY TimeAtCompany
ORDER BY Average_Hours_Absent DESC;

-- QUESTION EIGHT:
-- Do social drinkers or smokers have higher absenteeism rates compared to non-drinkers and non-smokers?

SELECT Social_drinker, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM AbsenteeismAtWork
GROUP BY Social_drinker;

SELECT Social_smoker, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM AbsenteeismAtWork
GROUP BY Social_smoker;

-- QUESTION NINE:
-- How does age correlate with absenteeism levels?

WITH AgeOfEmployee 
AS 
(
SELECT Age,
CASE
    WHEN Age < 30 THEN '20s'
    WHEN Age > 29 AND Age <= 39 THEN '30s'
    WHEN Age > 39 AND Age <= 49 THEN '40s'
    WHEN Age > 49 AND Age <= 59 THEN '50s'
    ELSE 'Unknown'
END AS EmployeeAge, Absenteeism_time_in_hours
FROM AbsenteeismAtWork
GROUP BY Age, Absenteeism_time_in_hours
)

SELECT EmployeeAge, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM AgeOfEmployee
GROUP BY EmployeeAge
ORDER BY Average_Hours_Absent DESC;

-- LASTLY:
-- Create a Dashboard for HR to understand absenteeism at work with PowerBI

-- Optimize Query for Visualizations [add Season, BMI categories]

SELECT AbsenteeismAtWork.ID, Reasons.Reason, Day_of_the_week,
CASE
    WHEN Day_of_the_week = 2 THEN 'Monday'
    WHEN Day_of_the_week = 3 THEN 'Tuesday'
    WHEN Day_of_the_week = 4 THEN 'Wednesday'
    WHEN Day_of_the_week = 5 THEN 'Thursday'
    WHEN Day_of_the_week = 6 THEN 'Friday'
    ELSE 'Unknown'
END AS DayofTheWeek, Month_of_absence,
CASE
    WHEN Month_of_absence = 1 THEN 'January'
    WHEN Month_of_absence = 2 THEN 'February'
    WHEN Month_of_absence = 3 THEN 'March'
    WHEN Month_of_absence = 4 THEN 'April'
    WHEN Month_of_absence = 5 THEN 'May'
    WHEN Month_of_absence = 6 THEN 'June'
    WHEN Month_of_absence = 7 THEN 'July'
    WHEN Month_of_absence = 8 THEN 'August'
    WHEN Month_of_absence = 9 THEN 'September'
    WHEN Month_of_absence = 10 THEN 'October'
    WHEN Month_of_absence = 11 THEN 'November'
    WHEN Month_of_absence = 12 THEN 'December'
    ELSE 'Unknown'
END AS MonthOfAbsence,
CASE 
    WHEN Month_of_absence IN (12, 1, 2) THEN 'Winter'
    WHEN Month_of_absence IN (3, 4, 5) THEN 'Spring'
    WHEN Month_of_absence IN (6, 7, 8) THEN 'Summer'
    WHEN Month_of_absence IN (9, 10, 11) THEN 'Fall'
    ELSE 'Unknown'
END AS Season,
Body_mass_index,
CASE
    WHEN Body_mass_index <= 18.5 THEN 'Underweight'
    WHEN Body_mass_index BETWEEN 18.5 AND 24.0 THEN 'Healthy Weight'
    WHEN Body_mass_index BETWEEN 25 AND 29.9 THEN 'Overweight'
    WHEN Body_mass_index >= 30 THEN 'Obese'
    ELSE 'Unknown'
END AS BMI_Category, Social_drinker, Social_smoker, Pet, Son, Education, Age, Distance_from_Residence_to_Work, Transportation_expense, Service_time, Work_load_Average_day, Absenteeism_time_in_hours
FROM AbsenteeismAtWork
INNER JOIN Compensation ON AbsenteeismAtWork.ID = Compensation.ID
INNER JOIN Reasons ON AbsenteeismATWork.Reason_for_absence = Reasons.Number;
