# -*- coding: utf-8 -*-
"""
Created on Fri May 27 19:56:18 2016

Create dataframe to run analysis on:
    - compute cosine similarity between each email and each event
    - if cosin sim < 0.05 == 0, eseif max == 1

@author: mariaathena
"""

# Prepare environment and load and prepare data  -----------------------------

import pandas as pd
import nltk
import feather
import re, math
from collections import Counter

#from sklearn.feature_extraction.text import TfidfVectorizer


# Feather formatted dataframes import directly into pandas dataframes
# New module/package collaboration for easy trasnfer R <--> python 
event_dict = feather.read_dataframe('../parsed_data/parsed_dict.feather')
email_df = feather.read_dataframe('../parsed_data/simplified_email.feather')

## Prepare event dictionary dataframe
event_dict.drop(['NA'], inplace=True, axis=1)
event_dict = event_dict.transpose()
event_dict.columns = event_dict.loc['event']
event_dict = event_dict.reindex(event_dict.index.drop(['event']))

# remove occurrences of "x...#" stemming from wikipedia using regular expression
event_dict = event_dict.applymap(lambda z: re.sub(r'(^|\s)x(\w+,)', r'', z))

## Prepare email dataframe
# Convert string in email_raw column to list of strings
#email_df.email_raw = email_df.email_raw.apply(lambda x: x.split(","))



# Helper functions for analysis ----------------------------------------------

# Helper function to extract nouns from a Python string object
def extract_nouns(txt):
    nouns = []

    # create list of words in a text, taking out punctuations, symbols etc.
    words = nltk.word_tokenize(txt)
    # categorise all words in text with tags
    tags = nltk.pos_tag(words)

    # select all words categorised as nouns
    for word, pos in tags:
        if (pos == 'NN' or pos == 'NNS' or pos == 'NNP' or pos == 'NNPS'):
            nouns.append(word.lower())

    return nouns


# Helper function to convert text to vector
WORD = re.compile(r'\w+')

def text_to_vector(text):
     words = WORD.findall(text)
     return Counter(words)


# Helper function to compute cosine similarity
def cosine_sim(vect1, vect2):
    a = set(vect1)
    b = set(vect2)
    top = len(a & b)
    bottom = len(a | b)
    if not bottom:
        sim = 0
    else:
        sim = top / float(bottom)

    return sim            


# Analysis: Create cosine similarity of nouns in emails/events --------------
# using python nltk package look at cosine similarity of nouns in text
# unweigthed by frequency.

# Only keep nouns in event_dict
df_dict1 = event_dict
df_dict1.applymap(extract_nouns)

# Create new dataframe with only email_raw and DocNum as index
email_df1 = email_df[['DocNumber', 'email_raw']]
email_df1.set_index(['DocNumber'], inplace=True)

# Only keep nouns in email_raw
email_df1.email_raw = email_df1.email_raw.apply(lambda x: extract_nouns(x))


# Create new dataframe to take dates, DocNums and cosine similarity of emails
# to events. Events are column header
# Create new dataframe to contain cosine similarities
# cosim_df = pd.DataFrame.from_dict(dict([for l in list_events ]))
cosim_df = email_df[['DocNumber', 'date']]

beng = text_to_vector(event_dict.benghazi[0])
iran = text_to_vector(event_dict.iran_deal[0])
hill = text_to_vector(event_dict.hillary[0])
doct = text_to_vector(event_dict.doctrine[0])
spring = text_to_vector(event_dict.arab_spring[0])
comm = text_to_vector(event_dict.benghazi_committe[0])


benghazi = []
iran_deal = []
hillary = []
doctrine = []
arab_spring = []
benghazi_committe = []

# email_df1 = email_df1.email_raw.apply(lambda x: text_to_vector(x))

for index, emails in email_df1.iterrows():
    for email in emails:
        benghazi.append(round(cosine_sim(beng, email), 3))
        iran_deal.append(round(cosine_sim(iran, email), 3))
        hillary.append(round(cosine_sim(hill, email), 3))
        doctrine.append(round(cosine_sim(doct, email), 3))
        arab_spring.append(round(cosine_sim(spring, email), 3))
        benghazi_committe.append(round(cosine_sim(comm, email), 3))
        
cosim_df['benghazi'] = benghazi
cosim_df['iran_deal'] = iran_deal
cosim_df['hillary'] = hillary
cosim_df['doctrine'] = doctrine
cosim_df['arab_spring'] = arab_spring
cosim_df['benghazi_committe'] = benghazi_committe


# Create data type dictionary with k/v pairs 'event': []
# events = event_dict.columns.values.tolist()
# cosim = dict().fromkeys(events, list())

# Concatenate cosim dict onto cosim dataframe
# cosim_df = pd.concat([cosim_df, pd.DataFrame.from_dict(cosim)])

feather.write_dataframe(cosim_df, '../parsed_data/event_cosine_sim.feather')
