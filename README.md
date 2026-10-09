# Marketing-Business-Analysis
## 1- Project Overview
## Business Context
A digital marketing agency manages advertising campaigns for clients across different industries, channels and devices. The agency needs a clear understanding of which campaigns deliver the strongest returns, how marketing efficiency changes over time and where advertising budgets could be allocated more effectively.

This project analyses campaign performance from 2024 to September 2026 to identify trends, compare marketing channels, evaluate client performance and develop data-driven recommendations.

This projects follows and end-to-end analytical workflow using **Excel** for data cleaning and initial exploration, **MySQL** for deeper analysis and business questions, and **Tableau** for interactive visualisations.

**This is a synthetic dataset and created for portfolio use. Finding from this projects are illustrative of the analytical process and do not represent actual performance of any marketing agency.**

## 2- Project Objectives
- Evaluate marketing performance through revenue, ad spend, conversions and ROAS.
- Identify marketing channels and campaign types that generate the strongest results.
- Compare campaign performance across clients and industries.
- Investigate high-spend campaigns with weak returns.
- Analyse monthly (MoM) and year-over-year (YoY) performance change.
- Identify opportunities to improve advertising efficiency and budget allocation.
- Build interactive Tableau dashboard to communicate findings to buisness stakeholders.

**Key Questions**
1. What are total spend, revenue profit, conversion and ROAS?
2. Which Channels generate the most revenue?
3. Which campaign types generate the most conversions?
4. Which campaigns have high spend but below average ROAS?
5. Which client generates the most revenue and profit?
6. Which industries have the strongest ROAS?
7. How has revenue changed month over month?
   How has revenue changed year over year?
8. How has ROAS change month over month?

## 3- Findings & Recommendations
**Findings**
1. The dataset reports a high overall ROAS.
   CPC is low relative to the revenue generated - AVG CPC is £0.55
   CTC rate is 6.52%
2. Email Marketing generates the most revenue and has the highest ROAS.
   Google Ads generates the most conversions.
   Meta Ads has the highest ad spend, but generates less revenue and fewer conversions.
3. Retargeting generates the most conversions and revenue.
   Lead Generation has the second-highest ROAS.
   Product Launch and Seasonal Promotion generates almost the same conversions rate, but Product Launch generates more revenue and ROAS.
4. Several campaigns have low ROAS.
5. TechNova is the largest client by revenue and profit generating £5.16 million in revenue
   Forge Consulting is the second largest in revenue.
6. SaaS is the strongest performing industry by ROAS.
   Real State is second strongest performing industry followed by Hospitality.
   E-commerce has the highest advertising spend but a lower ROAS than the leading industries.
7. Monthly revenue increased in January to August before dropping through November 2024.
   Annual revenue increased approximately 110% from 2024 to 2025.
8. Monthly ROAS fluctuated during 2024.

**Recommendations**
- Validate cost and attribution of **Email Marketing** returns. Further investigate how to scale **Google Ads** campaigns and review Meta Ads for high-spend underperformers.
- Investigate how to scale retargeting campaigns. Compare **Product Launch** and **Seasonal Promotion** performance to identify opportunities to improve revenue per conversions.
- Validate campaign objectives and attribution before redistributing investment and compare similar campaigns to identify how to optimise opportunities.
- Investigate the channels and campaigns types contributing to the strongest clients, compare advertising efficiency across accounts.
- Further investigate campaigns and channels contributing to SaaS and Hospitality performance and investigate E-commerce high-spend campaigns for better optimisations.
- Investigate the drivers of monthly and yearly revenue peaks and declines.

## 4- Tableau Dashboard
The final **Tableau** dashboard provides and interactive business overview.
https://public.tableau.com/app/profile/jarold.moreno/viz/MarketingBusinessDashboard/Dashboard1

## Project Structure

Marketing-Business-Analysis/

│

├── README.md

│

├── data/

│   └── marketing_agency_campaigns_2024_2026_raw.csv

|   └── marketing_agency_campaigns_2024_2026_clean.csv

│

├── sql/

│   ├── 01_data_cleaning.sql

│   ├── 02_exploratory_analysis.sql

│   └── 03_business_questions.sql

│

├── tableau/

│   └── Marketing_Business_dashboard.twbx
