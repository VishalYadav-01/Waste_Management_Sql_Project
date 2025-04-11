-- Material Flow Summary (Tracking material movement through each stage)

select material_type,'Inward' as stage, concat(round(sum(quantity)*0.001,2),' MT') AS Total_Qty from inward
group by material_type Union
select material_type,'Segregation' as stage, concat(round(sum(processed_qty)*0.001,2),' MT') from segregation 
group by material_type Union 
select material_type,'Baling' as stage, concat(round(sum(baled_qty)*0.001,2),' MT') from baling
group by material_type Union
select material_type,'Dispatch' as stage,concat(round(sum(dispatched_qty)*0.001,2),' MT') from dispatch
group by material_type;


-- Wastage Rate in Segregation (Wastage = Remaining Qty / Processed Qty)

select material_type,concat(ROUND(SUM(remaining_qty) / SUM(processed_qty) * 100, 2),' %') AS wastage_rate
from segregation
group by material_type;


--  Dispatch Efficiency (How much of the baled material is successfully dispatched?)

select b.material_type,ROUND(SUM(d.dispatched_qty) / SUM(b.baled_qty) * 100, 2) AS dispatch_efficiency_percent
from baling b
join dispatch d on b.material_type = d.material_type
group by b.material_type;


-- User Productivity (How much material is processed by each user in segregation?)

select u.name,round(SUM(s.processed_qty)*0.001,2) as total_processed_in_MT
from segregation s
join users u on s.user_id = u.user_id
group by u.name
order by total_processed_in_MT desc;


-- Compliance Score by Department

select u.department,ROUND(avg(c.compliance_score), 2) as avg_score
from compliance c
join users u on c.user_id = u.user_id
group by u.department;


-- Material Conversion Rate (How much of inward material gets processed through segregation?)

select i.material_type,ROUND(SUM(s.processed_qty) / SUM(i.quantity) * 100, 2) AS conversion_rate_pct
from inward i
join segregation s on i.material_type = s.material_type
group by i.material_type;



-- Average time between baling and dispatch for each material.

select b.material_type,ROUND(avg(DATEDIFF(d.date, b.date)), 2) as avg_storage_days
from baling b
join dispatch d on b.material_type = d.material_type
group by b.material_type;

-- Operator Efficiency (How much each user segregates on average)

select u.name,COUNT(s.segregation_id) as total_sessions,
ROUND(SUM(s.processed_qty), 2) as total_qty,
ROUND(avg(s.processed_qty), 2) as avg_per_session from segregation s
join users u on s.user_id = u.user_id
group by u.name;


-- Reject Rate (What % of segregated material is rejected (remaining_qty)
select material_type,round(sum(remaining_qty) / sum(processed_qty) * 100, 2) as reject_rate_pct
from segregation
group by material_type;





