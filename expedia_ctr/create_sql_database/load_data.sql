-- Load data into SQL database


CREATE TABLE train
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

COPY train FROM '/Users/mariaathena/Dropbox (Personal)/00 Imperial College/1603 Digital Marketing/HomeWork 4/data/train.csv' WITH CSV HEADER;



CREATE TABLE test
(
id VARCHAR,
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
hotel_market VARCHAR
);

COPY test FROM '/Users/mariaathena/Dropbox (Personal)/00 Imperial College/1603 Digital Marketing/HomeWork 4/data/test.csv' WITH CSV HEADER;


