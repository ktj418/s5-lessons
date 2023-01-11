-- ETL
INSERT INTO cdm.dm_settlement_report
(restaurant_id,
restaurant_name,
settlement_date,
orders_count,
orders_total_sum,
orders_bonus_payment_sum,
orders_bonus_granted_sum,
order_processing_fee,
restaurant_reward_sum
)
--
SELECT
ord.restaurant_id,
dr.restaurant_name,
dt.date as settlement_date,
sum(fps.count) as orders_count,
sum(fps.total_sum) as orders_total_sum,
sum(fps.bonus_payment) as orders_bonus_payment_sum,
sum(fps.bonus_grant) as orders_bonus_granted_sum,
sum(fps.total_sum) * 0.25 as order_processing_fee,
sum(fps.total_sum * 0.75) - sum(fps.bonus_payment) as restaurant_reward_sum
--
FROM dds.fct_product_sales fps
LEFT JOIN dds.dm_orders ord
ON fps.order_id = ord.id
LEFT JOIN dds.dm_restaurants dr
ON dr.id = ord.restaurant_id
LEFT JOIN dds.dm_timestamps dt
ON ord.timestamp_id = dt.id
WHERE ord.order_status = 'CLOSED'
group by ord.restaurant_id, dr.restaurant_name, dt.date
--
ON CONFLICT (restaurant_id,settlement_date)
DO UPDATE SET
id = EXCLUDED.id,
restaurant_name = EXCLUDED.restaurant_name,
orders_count = EXCLUDED.orders_count,
orders_total_sum = EXCLUDED.orders_total_sum,
orders_bonus_payment_sum = EXCLUDED.orders_bonus_payment_sum,
orders_bonus_granted_sum = EXCLUDED.orders_bonus_granted_sum,
order_processing_fee = EXCLUDED.order_processing_fee,
restaurant_reward_sum = EXCLUDED.restaurant_reward_sum