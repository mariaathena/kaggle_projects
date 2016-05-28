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
df_email1 = email_df[['DocNumber', 'date', 'email_raw']]
df_email1.set_index(['DocNumber'], inplace=True)

# Only keep nouns in email_raw
df_email1.email_raw = df_email1.email_raw.apply(lambda x: extract_nouns(x))


# Create new dataframe to take dates, DocNums and cosine similarity of emails
# to events. Events are column header
cosim_df = email_df[['DocNumber', 'date']]

benghazi = []
iran_deal = []
hillary = []
doctrine = []
arab_spring = []
benghazi_committe = []


for index1, emails in df_email1.iterrows():
    for index2, vocab in event_dict.iterrows():
        
        benghazi.append(cosine_sim(emails.email_raw, vocab.benghazi))
        iran_deal.append(cosine_sim(emails.email_raw, vocab.iran_deal))
        hillary.append(cosine_sim(emails.email_raw, vocab.hillary))
        doctrine.append(cosine_sim(emails.email_raw, vocab.doctrine))
        arab_spring.append(cosine_sim(emails.email_raw, vocab.arab_spring))
        benghazi_committe.append(cosine_sim(emails.email_raw, vocab.benghazi_committe))

        
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
