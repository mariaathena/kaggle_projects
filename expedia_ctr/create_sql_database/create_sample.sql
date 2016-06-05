-- Create table with random sample of the large data

CREATE TABLE train_sample
(
date_time VARCHAR,
site_name VARCHAR,
posa_continent VARCHAR,
user_location_country VARCHAR,
user_location_region VARCHAR,
user_location_city VARCHAR,
orig_destination_distance VARCHAR,
user_id VARCHAR,
is_mobile VARCHAR,
is_package VARCHAR,
channel	VARCHAR,
srch_ci	VARCHAR,
srch_co	VARCHAR,
srch_adults_cnt	VARCHAR,
srch_children_cnt VARCHAR,
srch_rm_cnt	VARCHAR,
srch_destination_id	VARCHAR,
srch_destination_type_id VARCHAR,
hotel_continent VARCHAR,
hotel_country VARCHAR,
hotel_market VARCHAR,
is_booking VARCHAR,
cnt	VARCHAR,
hotel_cluster VARCHAR
);

INSERT INTO train_sample

(SELECT * from train
WHERE user_id IN (
  SELECT round(random() * 21e6)::varchar as user_id
  FROM generate_series(1, 1250000)
  GROUP BY user_id -- Discard duplicates
)
LIMIT 1150000
);



--AS (
--	SELECT * FROM test 
--	TABLESAMPLE(3 PERCENT)
--	);
