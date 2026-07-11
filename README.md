# Risk Analytics in Insurance

## Project Overview

This project analyzes insurance customer and claims data to understand claim patterns, customer segments, and policy performance.

The analysis focuses on identifying customer and vehicle segments associated with higher claim amounts and understanding the difference between high claim severity and overall claim impact.

SQL was used for data cleaning, validation, exploratory analysis, and customer segmentation. Power BI was used to build an interactive dashboard for presenting key metrics and business insights.

## Dataset

The dataset contains 9,134 insurance customer records with information related to:

- Customer demographics
- Income and employment status
- Insurance coverage
- Policy type
- Monthly premium
- Customer lifetime value
- Vehicle class
- Total claim amount
- Number of policies
- Customer complaints

## Tools Used

- MySQL
- SQL
- Power BI
- Power Query
- DAX
- GitHub

## Project Workflow

1. Imported the insurance dataset into MySQL.
2. Checked the data for duplicate records and missing values.
3. Validated categorical values and numerical ranges.
4. Converted the date column into the appropriate SQL DATE format.
5. Performed exploratory data analysis using SQL.
6. Created income-based customer segments.
7. Analyzed claims across coverage types, policy types, vehicle classes, and customer segments.
8. Identified high-claim customer segments based on average and total claim amounts.
9. Built an interactive Power BI dashboard to present the findings.

## Key Analysis Performed

- Overall customer and claims analysis
- Claim amount analysis by coverage type
- Policy type performance analysis
- Vehicle class claim analysis
- Employment status analysis
- Income-based customer segmentation
- Income and vehicle class cross-analysis
- Identification of high-claim customer segments
- Comparison of claim severity and overall claim impact

## Key Insights

- Premium coverage customers had the highest average claim amount compared with Basic and Extended coverage customers.
- Luxury vehicles showed substantially higher average claim amounts than standard vehicle classes.
- Policy type showed relatively small differences in average claim amounts.
- Lower-income and no-income customer segments were associated with higher average claim amounts.
- The relationship between income segments and claim amounts remained visible across comparable vehicle classes.
- High average claim severity did not always result in the highest overall claim impact because customer volume also influenced total claims.

## Power BI Dashboard

The interactive Power BI dashboard includes:

- Total Customers
- Total Claim Amount
- Average Claim Amount
- Average Monthly Premium
- Total Policies
- Average Claim Amount by Vehicle Class
- Average Claim Amount by Income Segment
- Average Claim Amount by Coverage
- Total Claim Amount by Vehicle Class
- Income Segment and Vehicle Class Matrix
- Interactive filters for Coverage, Vehicle Class, Employment Status, and Policy Type

## Conclusion

The project demonstrates an end-to-end data analysis workflow using SQL and Power BI. The analysis highlights how customer characteristics, vehicle classes, and coverage levels are associated with different claim patterns and shows the importance of considering both average claim severity and total claim impact when evaluating insurance segments.
