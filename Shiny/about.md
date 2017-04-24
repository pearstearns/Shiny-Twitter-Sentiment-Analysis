---
output: md_document
---
###Twitter is So Sentimental

####Overview

This tool allows you to interactively perform and visualize sentiment analysis of twitter search terms.

####Hopefully Not Dense or Condescending
For those not aware, sentiment analysis is a form of natural language processing where the feelings expressed in text data are estimated. 

The most common way to do this is to use a *sentiment dictionary* where a collection of words are matched up with an emotional score (usually positive or negative), and the words in the dictionary are matched against the words in the text.

####A Look Behind the Curtain

In this tool, the `twitteR` package is used to interact with twitter and collect the tweets, emoticons are stripped, and the data is passed to the `syuzhet` (the Russian word for 'the way the story is organized') package for the analysis. Finally, `ggplot2` is used to visualize the results.

The weights were rather simple, multiplying the **favoriteCount** column in the twitter data by the sentiment score.

