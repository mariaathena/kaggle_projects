# -*- coding: utf-8 -*-
"""
Created on Sun May 15 15:51:45 2016

Get vocabulary of main events during Hillary R. Clinton's
tenure as Secretary of State using wikipedia api

(tokenise and clean using R for consistency with email data)

@author: mariaathena
"""

import pandas as pd
import wikipedia as wiki
import nltk

## Hillary dictionary
hillary = wiki.page("Hillary Clinton").content
hillary = nltk.word_tokenize(hillary)

## Benghazi dictionary
benghazi = wiki.page("2012 Benghazi attack").content
benghazi = nltk.word_tokenize(benghazi)

## United States House Select Committee on Benghazi
benghazi_committe = wiki.page("United States House Select Committee on Benghazi").content
benghazi_committe = nltk.word_tokenize(benghazi_committe)

## The Arab spring
arab_spring = wiki.page("Arab spring").content
arab_spring = nltk.word_tokenize(arab_spring)
 
## Iran deal dictionary
# Joint Comprehensive Plan of Action / agreement on Iran's nuclear program
iran_deal = wiki.page("Joint Comprehensive Plan of Action").content
iran_deal = nltk.word_tokenize(iran_deal)

## The Hillary Doctrine dictionary
# The agenda of making women's rights issues of national security.
doctrine = wiki.page("The Hillary Doctrine").content
doctrine = nltk.word_tokenize(doctrine)

# Create dict type for Events
event_dict = {
			  'hillary': hillary,
              'benghazi': benghazi,
              'benghazi_committe': benghazi_committe,
              'arab_spring': arab_spring,
              'iran_deal': iran_deal,
              'doctrine': doctrine
              }

# Create pandas dataframe for better handling where values of type list all 
# go into one cell in the dataframe
event_df = pd.DataFrame([[i] for i in event_dict.values()], index = event_dict)
event_df.columns = ['vocabulary']
event_df['event'] = event_df.index
#event_df = pd.DataFrame(event_dict)

# Helper function to change encoding
def change_encoding(vocab):
	str_vocab = [word.encode('utf-8') for word in vocab]
	return str_vocab

# Change from unicode after running nltk tokeniser to string
event_df.vocabulary = event_df.vocabulary.apply(lambda x: change_encoding(x))

# Output event dictionary to .csv
event_df.to_csv(open('../dictionary/event_vocab.csv', 'wb'), index=True)