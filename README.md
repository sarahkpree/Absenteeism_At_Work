# Employee Wellness & Work Absenteeism Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [SQL Query Examples](#sql-query-examples)
- [Data Visualization](#data-visualization)
- [Results](#results)
- [Recommendations](#recommendations)
- [Limitations](#limitations)

### Project Overview
The project focused on conducting Exploratory Data Analysis (EDA) on employee data to uncover insights into absenteeism patterns and employee well-being. By addressing specific questions, the analysis aimed to understand various factors influencing absenteeism and identify potential correlations within the dataset. In addition, a PowerBI dashboard was created to further understand absenteeism on work.

### Data Sources
The primary dataset used for this analysis is the "Absenteeism_at_work.csv" file, containing detailed information about the employees including absence details, lifestyle choices, and health indicators. In addition, there is a "Reasons.csv" file which lists the possible reasons for absenteeism and a "Compensation.csv" file which lists every employees' hourly wage. 

### Tools

- Excel - Data Inspection
- Microsoft SQL Server - Data Cleaning and Analysis
- PowerBI - Data Visualization

### Data Cleaning and Preparation

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

### SQL Query Examples

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

### Data Visualization

The PowerBI dashboard offers a comprehensive snapshot of absenteeism trends within the organization. The dashboard presents employee demographics, insights into absenteeism patterns over time, highlights common reasons for absenteeism and explores potential correlation.

<img width="631" alt="Screen Shot 2024-04-15 at 11 55 22 AM" src="https://github.com/sarahkpree/Absenteeism_At_Work/assets/61251211/5a1b92d9-af8c-4c77-8778-fc1350e02eb5">


### Results

The analysis results are summarized as follows:
1. **Identifying Healthiest Employees:** There are 111 employees meeting specific health criteria, including being non-smokers, non-drinkers, having a BMI less than 25, and exhibiting lower absenteeism than the average. These employees are entitled to a bonus from a $100,000 allocation, with each eligible employee set to receive approximately $900 as recognition for their healthy lifestyle choices and low absenteeism.

2.  **Non-Smoker Identification:** There are 686 non-smoking employees. With a budget allocation of $983,221 from the HR department, an hourly increase rate of $0.68 was determined for these employees, aiming to incentivize a smoke-free workplace environment.
   
3. **Reasons for Absenteeism:** The top 3 reasons for employee absenteeism are medical consultation, dental consultation, and physiotherapy.
   
4. **Temporal Analysis of Absenteeism:** Examination of absenteeism patterns throughout the week revealed Monday as the predominant day for employee absences, however with marginal differences observed across the remaining week days. Additionally, our analysis identified March as the month with the most absences.

5. **Education Level and Absenteeism:** The analysis revealed that employees with higher education levels tend to exhibit lower average absenteeism hours. However, the difference in absenteeism rates among the different education levels is minimal.

6. **Impact of Commute Distance:** There does not appear to be a relationship between commute distance and absenteeism.

7. **Tenure and Absenteeism:** The length of employment does not appear to impact absenteeism.

8. **Effect of Social Habits:** Absenteeism rates between social drinkers/smokers and non-drinkers/non-smokers do not appear to be significantl.

9. **Correlation between Age and Absenteeism:** Middle-aged employees, particularly those in their 50s, exhibit notably higher average absenteeism compared to their younger counterparts. However, it is probable that there are additional underlying factors influencing these absenteeism rates.
   
### Recommendations

Based on the analysis, the following steps are recommended:

1. **Promote Health and Wellness Programs:**
   Given the benefits associated with healthy lifestyle choices, such as lower absenteeism rates and improved employee well-being, consider implementing and promoting health and wellness programs within the organization. 

2. **Flexible Work Arrangements:**
   Recognizing Monday as the most common day for employee absences, consider implementing flexible work arrangements, such as telecommuting, to accommodate employees.

3. **Employee Engagement Initiatives:** Boost employee engagement by implementing recognition programs, offering career development opportunities, and promoting work-life balance initiatives. These efforts can uplift morale and decrease absenteeism among employees.

### Limitations
- Although correlations between variables have been noted, determining causal relationships necessitates additional investigation.
- The analysis findings may not be universally applicable across all organizations or contexts.
- The analysis is based on certain assumptions and interpretations of the data. For instance, the definition of "healthiest employees" may vary among organizations, and the interpretation of absenteeism patterns may be subjective.



