-- MARKETING EDA --
-- DATA CLEANING --

SELECT *
FROM marketing_agency_campaigns_2024_2026
LIMIT 100;

-- Number of Campaings
SELECT
	COUNT(*) AS number_of_campaigns
FROM marketing_agency_campaigns_2024_2026;

-- Unique Campaigns and Clients
SELECT
	COUNT(DISTINCT Campaign_ID) AS unique_campaign,
	COUNT(DISTINCT client_id) AS unique_clients
FROM marketing_agency_campaigns_2024_2026;

-- Campaign Date Range
SELECT
	MIN(campaign_month) AS earliest_date,
    MAX(campaign_month) AS latest_date
FROM marketing_agency_campaigns_2024_2026;

-- Number of Dates
SELECT
	COUNT(DISTINCT campaign_month) AS number_of_dates
FROM marketing_agency_campaigns_2024_2026;

-- Missing Values
SELECT
	SUM(Campaign_ID IS NULL) AS missing_order_id,
	SUM(campaign_month IS NULL) AS missing_date,
	SUM(client_id IS NULL) AS missing_client_id,
	SUM(client_name IS NULL) AS missing_name,
	SUM(industry IS NULL) AS missing_industry,
	SUM(campaign_name IS NULL) AS missing_campaign_name,
	SUM(channel IS NULL) AS missing_channel,
	SUM(region IS NULL) AS missing_region,
	SUM(audience_segment IS NULL) AS missing_au_segm,
    SUM(device IS NULL) AS missing_device,
    SUM(budget IS NULL) AS missing_budget,
    SUM(ad_spend IS NULL) AS missing_ad_spend,
    SUM(impressions IS NULL) AS missing_impressions,
    SUM(revenue IS NULL) AS missing_revenue
FROM marketing_agency_campaigns_2024_2026;

-- Duplicate Orders
SELECT 
	Campaign_ID,
    COUNT(*) AS row_counts
FROM marketing_agency_campaigns_2024_2026
GROUP BY Campaign_ID
HAVING COUNT(*) > 1
ORDER BY row_counts DESC
LIMIT 50;

-- Invalid Records
SELECT 
	COUNT(*) AS invalid_record
FROM marketing_agency_campaigns_2024_2026
WHERE clicks > impressions;

SELECT 
	COUNT(*) AS invalid_record
FROM marketing_agency_campaigns_2024_2026
WHERE conversions > clicks;

SELECT 
	COUNT(*) AS invalid_record
FROM marketing_agency_campaigns_2024_2026
WHERE leads < conversions;

-- Available sales Channels
SELECT DISTINCT channel
FROM marketing_agency_campaigns_2024_2026
GROUP BY channel;