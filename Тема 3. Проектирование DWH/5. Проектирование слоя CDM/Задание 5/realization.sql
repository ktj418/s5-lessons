ALTER TABLE cdm.dm_settlement_report  
ADD CONSTRAINT dm_settlement_report_rows_count_check 
UNIQUE (restaurant_id, settlement_date);