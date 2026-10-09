-- MARKETING EDA --
-- EXPLORATORY ANALYSIS --

SELECT
	MIN(ad_spend) AS min_spend,
    MAX(ad_spend) AS max_spend,
    ROUND(AVG(ad_spend), 2) AS avg_spend,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue,
    ROUND(SUM(revenue), 2) AS total_revenue,
    
    SUM(conversions) AS total_conversion
FROM marketing_agency_campaigns_2024_2026;

-- Overall Funnel
SELECT
	SUM(Clicks) AS clicks,
    SUM(leads) AS leads,
    SUM(conversions) AS conversion,
    SUM(impressions) AS impression
FROM marketing_agency_campaigns_2024_2026;

SELECT
	ROUND(SUM(Clicks) / NULLIF(SUM(impressions), 0) * 100, 2) AS CTR,
    ROUND(SUM(leads) / NULLIF(SUM(clicks), 0) * 100, 2) AS lead_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0) * 100, 2) AS conversion_rate,
    ROUND(SUM(ad_spend) / NULLIF(SUM(clicks), 0), 2) AS CPC
FROM marketing_agency_campaigns_2024_2026;

-- Revenue by Channels
SELECT
	Channel,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(ad_spend), 2) AS Ad_spend,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    ROUND(SUM(Revenue) / COUNT(DISTINCT Campaign_ID), 2) AS Avg_campaign_value,
    SUM(Impressions) AS impressions,
    SUM(Clicks) AS clicks,
    SUM(conversions) AS conversion
FROM marketing_agency_campaigns_2024_2026
GROUP BY Channel
ORDER BY revenue DESC;

-- Channel Efficiency Metric
SELECT
	Channel,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(ad_spend), 2) AS Ad_spend,
    SUM(Clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(Clicks) / NULLIF(SUM(impressions), 0) * 100, 2) AS CTR,
	ROUND(SUM(ad_spend) / NULLIF(SUM(clicks), 0), 2) AS CPC,
	ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS CPA,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY Channel;

-- Industry EDA
SELECT
	Industry,
    COUNT(DISTINCT Client_id) AS clients,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY industry
ORDER BY revenue DESC;

-- Campaign Type
SELECT
	campaign_name,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    SUM(leads) AS leads,
    SUM(conversions) AS conversions,
	ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY Campaign_Name
ORDER BY ROAS DESC;

-- Client Analysis
SELECT
	Client_ID,
    Client_name,
    Industry,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue - ad_spend), 2) AS profit,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY Client_ID, Client_Name, Industry
ORDER BY Revenue DESC;

SELECT
	Client_name,
	ROUND(SUM(revenue), 2) AS revenue
FROM marketing_agency_campaigns_2024_2026
GROUP BY Client_Name
ORDER BY revenue DESC;

-- Monthly Performance
SELECT
	DATE_FORMAT(campaign_month, '%Y-%m') AS month,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY DATE_FORMAT(campaign_month, '%Y-%m')
ORDER BY month;

-- Year to Year Comparison
SELECT
	YEAR(campaign_month) AS year,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY YEAR(campaign_month)
ORDER BY year;

-- MoM growth
WITH monthly AS(
	SELECT
		DATE_FORMAT(campaign_month, '%Y-%m') AS month,
        ROUND(SUM(revenue), 2) AS revenue
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY DATE_FORMAT(campaign_month, '%Y-%m'))
SELECT
	month,
    revenue,
    LAG(revenue) OVER(ORDER BY month) AS previous_month_revenue,
    (revenue - LAG(revenue) OVER(ORDER BY month))/ 
    NULLIF(LAG(revenue) OVER(ORDER BY month), 0) * 100 AS mom_growth
FROM monthly
ORDER BY month;

-- YoY growth
WITH yearly AS(
	SELECT
		YEAR(campaign_month) AS year,
        ROUND(SUM(revenue), 2) AS revenue,
        ROUND(SUM(ad_spend), 2) AS spend,
        SUM(conversions) AS conversions
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY YEAR(campaign_month))
SELECT
	year,
    revenue,
    LAG(revenue) OVER(ORDER BY year) AS previous_year_revenue,
    (revenue - LAG(revenue) OVER(ORDER BY year))/
    NULLIF(LAG(revenue) OVER(ORDER BY year), 0) * 100 AS yoy_revenue
FROM yearly
ORDER BY year;

-- High-Spend / Low-Return Campaigns
WITH campaign_performance AS(
	SELECT
		Campaign_ID,
        Client_name,
        Channel,
        ROUND(SUM(ad_spend), 2) AS spend,
		ROUND(SUM(revenue), 2) AS revenue,
        ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY campaign_id, client_name, channel)
SELECT *
FROM campaign_performance
WHERE spend > 2000
AND ROAS < 2
ORDER BY spend DESC;

WITH campaign_performance AS(
	SELECT
		Campaign_ID,
        ROUND(SUM(ad_spend), 2) AS spend,
		ROUND(SUM(revenue), 2) AS revenue,
        ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY campaign_id)
SELECT *
FROM campaign_performance
WHERE ROAS < (
	SELECT AVG(ROAS)
    FROM campaign_performance)
ORDER BY spend DESC;

-- Spend VS Revenue
SELECT
	DATE_FORMAT(campaign_month, '%Y-%m') AS month,
    ROUND(SUM(ad_spend), 2) AS spend,
	ROUND(SUM(revenue), 2) AS revenue
FROM marketing_agency_campaigns_2024_2026
GROUP BY DATE_FORMAT(campaign_month, '%Y-%m')
ORDER BY month;

-- Channel & Industry
SELECT
	industry,
    channel,
    ROUND(SUM(ad_spend), 2) AS spend,
	ROUND(SUM(revenue), 2) AS revenue,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY industry, channel
ORDER BY industry, ROAS DESC;