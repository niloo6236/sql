
create or replace view retail.table_joined as

SELECT 
s.date,
dayname(date) as day_of_week,
case when weekday(date) in (5,6) then "weekend" else "weekday" end as is_weekend,
s.shop_id,
s.shop_name,
s.customers,
s.sales_usd,
s.sales_usd/s.customers as sales_per_customer,
su.pct_male,
su.pct_female,
su.pct_family,
su.pct_single,
w.avg_temp_f,
w.precip_in,
w.is_rain,
w.humidity_pct
FROM retail.sales s
left join retail.survey su 
using(date)
left join retail.weather w
using(date)