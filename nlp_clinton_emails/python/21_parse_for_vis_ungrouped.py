# -*- coding: utf-8 -*-
"""
Created on Sun May 29 21:34:10 2016

@author: mariaathena
"""

# Prepare environment and load data ------------------------------------------
import pandas as pd
import numpy as np
import feather


cosim_df = feather.read_dataframe('../parsed_data/event_cosine_sim.feather')


# Modify data for easy visualisation -----------------------------------------

# Set cos_sim below certain threshold equal to zero
# threshold for each topic == topic's 75th percentile cosine sim
cosim_df2 = cosim_df.copy()
# cosim_df2.ix[:,3:] = cosim_df2.ix[:,3:].applymap(lambda x: round(x, 2) if x > 0.01 else 0)
cosim_df2.benghazi = cosim_df2.benghazi.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.benghazi, 75) else 0)
cosim_df2.wiki_leak = cosim_df2.wiki_leak.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.wiki_leak, 75) else 0)
cosim_df2.doctrine = cosim_df2.doctrine.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.doctrine, 75) else 0)
cosim_df2.arab_spring = cosim_df2.arab_spring.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.arab_spring, 75) else 0)
cosim_df2.russian_reset = cosim_df2.russian_reset.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.russian_reset, 75) else 0)
cosim_df2.cancer = cosim_df2.cancer.apply(lambda x: round(x, 3) if x > np.percentile(cosim_df2.cancer, 75) else 0)


## Set emails topic == event with the highest cosine similarity to
topic_df = cosim_df2.copy()
topic_df.insert(3, 'NA', 0)
topic_df['email_topic'] = topic_df.ix[:,3:].idxmax(axis=1)

# Make dummies for email topics
topic_df = pd.concat([topic_df[['DocNumber', 'date', 'edited_x']],
                      pd.get_dummies(topic_df.email_topic, prefix='')], 
                      axis=1)


## Format date column
topic_df.index = pd.to_datetime(topic_df.date,
                                format='%m/%d/%Y')
topic_df.sort_index(axis=0, inplace=True)

topic_df['year_month'] = [(x.split('/')[0], x.split('/')[2]) for x in topic_df.date.tolist()]


topic_df.to_csv(open('../parsed_data/data_for_vis_ungrouped.csv', 'wb'), index=False)
