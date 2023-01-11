select distinct json_array_elements((event_value::JSON->>'product_payments')::json)::JSON->>'product_name' as product_name
from public.outbox