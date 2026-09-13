create database Churn_Project;

use Churn_Project;

select * from Customers
limit 10;

# How many total customers do we have?
select count(*) as Total_Customers 
from Customers;

# How many of those customers churned?
select count(*) as Churned_Customers 
from Customers
where Churn = "Yes";


# Which payment method has the highest churn?
select PaymentMethod, count(PaymentMethod) as Churned_Customers
from Customers
where Churn = "Yes"
group by PaymentMethod
order by Churned_Customers desc;


# How much monthly revenue are we losing from churn by contract type?

select Contract, count(Contract) as Churned_Customers, sum(MonthlyCharges) as Lost_Monthly_Revenue
from Customers 
where Churn ="Yes"
group by Contract
order by Lost_Monthly_Revenue;
# BUSINESS INSIGHT: Month-to-month churn is bleeding over $120,847 monthly. 
# RECOMMENDATION: Incentivize these customers to upgrade to 1-year contracts to drastically reduce financial loss.

# What are the top 3 high-risk customer segments losing the most revenue? (Using a CTE)

with SegmentRevenue as (
select Contract, InternetService, count(Churn) as Total_Churned, sum(MonthlyCharges) as Total_Lost_Revenue
from Customers
where Churn="Yes"
group by Contract, InternetService 
)
select Contract, InternetService, Total_Churned, round(Total_Lost_Revenue, 2) as Formatted_Lost_Revenue
from SegmentRevenue 
order by Total_Lost_Revenue desc 
limit 3;

# BUSINESS INSIGHT: Month-to-month Fiber Optic users are our highest-risk segment, accounting for $100,482 in lost monthly revenue.
# RECOMMENDATION: Investigate the Fiber Optic service quality and target this specific group with 1-year contract incentives.


# How does churn volume drop off based on customer loyalty? (Using a CASE statement)

select case 
when tenure <= 12 then 'New (0-1 Year)'
when tenure <= 24 then 'Moderate (1-2 Years)'
when tenure <= 48 then 'Loyal (2-3 Years)'
else 'Vip (4+ Years'
end as Loyality_Tier, count(Churn) as Churned_Customers
from Customers
where Churn = "Yes"
group by Loyality_Tier
order by Churned_Customers asc;

# BUSINESS INSIGHT: Over 55% of all churn (1,037 customers) happens in the very first year. 
# RECOMMENDATION: Implement an aggressive onboarding and check-in program during a customer's first 12 months to build early loyalty and prevent early drop-off.