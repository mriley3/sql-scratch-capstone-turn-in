/*Distinct Campaigns*/
SELECT COUNT(DISTINCT(utm_campaign)) AS Campaigns
FROM page_visits;

/*Distinct Sources*/                      
SELECT COUNT(DISTINCT(utm_source)) AS Sources
FROM page_visits;
                     
/*Campaign and Source Combinations*/
SELECT DISTINCT utm_campaign AS Campaign,                         
                utm_source AS Source
FROM page_visits;

/*Distinct Page Names*/
SELECT DISTINCT page_name AS Pages      
FROM page_visits;

/*First Touches per Campaign*/
WITH first_touch AS (
    SELECT user_id,
           MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS(
SELECT ft.user_id,
       ft.first_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM first_touch AS ft
JOIN page_visits AS pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_campaign AS Campaign,
       ft_attr.utm_source AS Source, 
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
                      
/*Last Touches per Campaign*/
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS(
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_campaign AS Campaign,
       lt_attr.utm_source AS Source,         
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
                     
/*Number of Visitors who Purchased*/
SELECT COUNT(DISTINCT(user_id)) AS 'Customers who Purchased'
FROM page_visits
WHERE page_name = '4 - purchase';

/*Last Touches on Purchase Page per Campaign*/
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS(
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_campaign AS Campaign, 
       lt_attr.utm_source AS Source,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*Additional Queries*/

/*Uniques Users per Page Type*/
SELECT page_name,
       COUNT (DISTINCT(user_id)) AS 'Unique Users'
FROM page_visits
GROUP BY 1;

/*Unique Users per Page Type and Campaign*/
SELECT page_name,
       utm_campaign,                
       COUNT (DISTINCT(user_id)) AS 'Unique Users'
FROM page_visits
GROUP BY 1, 2;