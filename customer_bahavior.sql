select * from customer 


select gender, sum(purchase_amount) as revenue
from customer
group by gender

select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG (purchase_amount) from customer)

select item_purchased, round(AVG(review_rating),2) as 'Avarage Product Rating'
from customer
group by item_purchased
order by AVG(review_rating) desc

select shipping_type,
round(AVG(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc

select item_purchased,
ROUND(100 * SUM(case when discount_applied= 'Yes' then 1 else 0 end) / COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc


with customer_type as (
select customer_id, previous_purchases,
case
    when previous_purchases = 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer
)
select customer_segment, COUNT(*) as 'Number of Customers'
from customer_type
group by customer_segment



with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3


select subscription_status,
COUNT(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status


select age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue DESC