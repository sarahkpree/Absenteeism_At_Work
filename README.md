# Employee Wellness & Work Absenteeism Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Recommendations](#recommendations)

### Project Overview
The project focused on conducting Exploratory Data Analysis (EDA) on employee data to uncover insights into absenteeism patterns and employee well-being. By addressing specific questions, the analysis aimed to understand various factors influencing absenteeism and identify potential correlations within the dataset.

### Data Sources
The primary dataset used for this analysis is the "Absenteeism_at_work.csv" file, containing detailed information about the employees including absence details, lifestyle choices, and health indicators. In addition, there is a "Reasons.csv" file which lists the possible reasons for absenteeism and a "Compensation.csv" file which lists every employees' hourly wage. 

### Tools

- Excel - Data Inspection
- Microsoft SQL Server - Data Cleaning and Analysis
- PowerBI - Data Visualization

### Data Cleaning/Preparation

In the initial data preparation phase, we performed the following tasks:
- Data loading and inspection
- Identification of null values. There are no missing values.
- Data formatting (alter data type)

### Exploratory Data Analysis

EDA involved exploring the employee data to answer key questions, such as:
1. Who are the healthiest employees? "Healthy" is defined as a non-smoker, non drinker, a BMI less than 25, and absent less than the employee average absent hours.
2. Who are the employees that do not smoke?
3. What is the most common reason for absenteeism?
4. Is there a particular month or day of the week with higher absenteeism rates?
5. Do employees with higher education levels tend to have lower absenteeism rates?
6. Are employees with longer commutes more likely to be absent?
7. How does the length of employment tenure impact absenteeism?
8. Do social drinkers or smokers have higher absenteeism rates compared to non-drinkers and non-smokers?
9. How does age correlate with absenteeism levels?

### SQL Queries Examples

Below are a few SQL queries executed during exploratory data analysis.

**What is the most common reason for absenteeism?**

```sql
SELECT Reasons.Reason, COUNT(ID) AS Total_Count
FROM AbsenteeismAtWork
LEFT JOIN Reasons ON AbsenteeismAtWork.Reason_for_absence = Reasons.Number
GROUP BY Reasons.Reason
ORDER BY Total_Count DESC;
```

**How does the length of employment tenure impact absenteeism?**

```sql
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
```

**Do employees with higher education levels tend to have lower absenteeism rates?**

```sql
SELECT Education, CAST(AVG(Absenteeism_time_in_hours) AS DECIMAL(5, 2)) AS Average_Hours_Absent
FROM AbsenteeismAtWork
GROUP BY Education
ORDER BY Average_Hours_Absent;
```

### Results/Findings

The analysis results are summarized as follows:
1. Result 1
2. Result 2
3. Result 3

### Recommendations

Based on the analysis, the following steps are recommended:
1. Recommendation 1
2. Recommendation 2
3. Recommendation 3

### Limitations
What has affected the quality of your analysis?

### References

Links to any pages used for help. 


