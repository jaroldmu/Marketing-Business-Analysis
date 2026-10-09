-- MARKETING EDA --
-- BUSINESS ANALYSIS --

-- 1. What are total spend, revenue profit, conversion and ROAS?

SELECT
	ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue - ad_spend), 2) AS total_profit,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS overall_roas
FROM marketing_agency_campaigns_2024_2026;

SELECT
	ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue - ad_spend), 2) AS total_profit,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(leads) AS leads,
    SUM(conversions) AS total_conversions,
    
    ROUND(SUM(Clicks) / NULLIF(SUM(impressions), 0) * 100, 2) AS CTR_pct,
    ROUND(SUM(ad_spend) / NULLIF(SUM(clicks), 0), 2) AS CPC,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS CPA,
    ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0) * 100, 2) AS conversion_rate_pct,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026;

-- 2. Which Channels generate the most revenue?

SELECT
	Channel,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(ad_spend), 2) AS Ad_spend,
    SUM(conversions) AS conversions,
	ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS CPA,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY Channel
ORDER BY revenue DESC;

-- 3. Which campaign types generate the most conversions?

SELECT
	SUBSTRING_INDEX(campaign_name, ' - ', 1) AS campaign_type,
    SUM(conversions) AS conversions,
    SUM(leads) AS leads,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY campaign_type
ORDER BY conversions DESC;

-- 4. Which campaigns have high spend but below average ROAS?

WITH campaign_performance AS (
	SELECT
		campaign_id,
        client_name,
        channel,
        ROUND(SUM(ad_spend), 2) AS spend,
		ROUND(SUM(revenue), 2) AS revenue,
		ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY
		campaign_id,
        client_name,
        channel), averages AS (
			SELECT
				AVG(spend) AS avg_spend,
                AVG(roas) AS avg_roas
			FROM campaign_performance)
SELECT
	c.campaign_id,
    c.client_name,
    c.channel,
    ROUND(c.spend, 2) AS spend,
    ROUND(c.revenue, 2) AS revenue,
    ROUND(c.roas, 2) AS roas
FROM campaign_performance c
CROSS JOIN averages a
WHERE c.spend > a.avg_spend
AND c.roas < a.avg_roas
ORDER BY c.spend DESC;

-- 5. Which client generates the most revenue and profit?

SELECT
	client_id,
    client_name,
    industry,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue - ad_spend), 2) AS profit,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY 	
	client_id,
    client_name,
    industry
ORDER BY revenue DESC;

-- 6. Which industries have the strongest ROAS?

SELECT
	industry,
    COUNT(DISTINCT client_id) AS clients,
    ROUND(SUM(ad_spend), 2) AS spend,
    ROUND(SUM(revenue), 2) AS revenue,
    SUM(conversions) AS conversions,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
FROM marketing_agency_campaigns_2024_2026
GROUP BY industry
ORDER BY ROAS DESC;

-- 7. How has revenue changed month over month?
	-- How has revenue changed year over year?

WITH monthly AS (
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
    ROUND(NULLIF(LAG(revenue) OVER(ORDER BY month), 0) * 100, 2) AS mom_growth
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
    ROUND(NULLIF(LAG(revenue) OVER(ORDER BY year), 0) * 100, 2) AS yoy_revenue
FROM yearly
ORDER BY year;

-- 8. How has ROAS change month over month?

WITH monthly AS (
	SELECT
		DATE_FORMAT(campaign_month, '%Y-%m') AS month,
		ROUND(SUM(revenue), 2) AS revenue,
        ROUND(SUM(ad_spend), 2) AS spend,
		ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS ROAS
	FROM marketing_agency_campaigns_2024_2026
    GROUP BY DATE_FORMAT(campaign_month, '%Y-%m'))
SELECT
	month,
    ROUND(ROAS, 2) AS ROAS,
    ROUND(LAG(ROAS) OVER (ORDER BY month), 2) AS previous_month_ROAS,
    ROUND(ROAS - LAG(ROAS) OVER (ORDER BY month)) /
    ROUND(NULLIF(LAG(ROAS) OVER(ORDER BY month), 0) * 100, 2) AS mom_ROAS_change
FROM monthly
ORDER BY month;