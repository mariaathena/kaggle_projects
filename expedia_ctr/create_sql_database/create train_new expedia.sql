-- Table: capabilitiestaxonomy

-- DROP TABLE capabilitiestaxonomy;

CREATE TABLE train_new
(
srch_id	bigint	,
date_time	date	,
site_id	bigint	,
visitor_location_country_id	integer	,
visitor_hist_starrating	numeric	,
visitor_hist_adr_usd	numeric	,
prop_country_id	bigint	,
prop_id	bigint	,
prop_starrating	integer	,
prop_review_score	numeric	,
prop_brand_bool	integer	,
prop_location_score1	numeric	,
prop_location_score2	numeric	,
prop_log_historical_price	numeric	,
position	integer	,
price_usd	numeric	,
promotion_flag	integer	,
srch_destination_id	bigint	,
srch_length_of_stay	integer	,
srch_booking_window	integer	,
srch_adults_count	integer	,
srch_children_count	integer	,
srch_room_count	integer	,
srch_saturday_night_bool	boolean	,
srch_query_affinity_score	numeric	,
orig_destination_distance	numeric	,
random_bool	boolean	,
comp1_rate	integer	,
comp1_inv	integer	,
comp1_rate_percent_diff	numeric	,
comp2_rate	numeric	,
comp2_inv	numeric	,
comp2_rate_percent_diff	numeric	,
comp3_rate	numeric	,
comp3_inv	numeric	,
comp3_rate_percent_diff	numeric	,
comp4_rate	numeric	,
comp4_inv	numeric	,
comp4_rate_percent_diff	numeric	,
comp5_rate	numeric	,
comp5_inv	numeric	,
comp5_rate_percent_diff	numeric	,
comp6_rate	numeric	,
comp6_inv	numeric	,
comp6_rate_percent_diff	numeric	,
comp7_rate	numeric	,
comp7_inv	numeric	,
comp7_rate_percent_diff	numeric	,
comp8_rate	numeric	,
comp8_inv	numeric	,
comp8_rate_percent_diff	numeric	,
click_bool	boolean	,
gross_bookings_usd	numeric	,
booking_bool	boolean	
)
WITH (
  OIDS=FALSE
);


