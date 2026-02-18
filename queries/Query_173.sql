select closing, p_rate, (closing * p_rate) as "value" from batch order by value desc;

-- select closing, p_rate, (closing * p_rate) as "value" from batch ;