---
output: md_document
---
### Twitter is So Sentimental

#### Overview

This tool allows you to interactively perform and visualize sentiment analysis of twitter search terms.

#### Hopefully Not Dense or Condescending
For those not aware, sentiment analysis is a form of natural language processing where the feelings expressed in text data are estimated. 

The most common way to do this is to use a *sentiment dictionary* where a collection of words are matched up with an emotional score (usually positive or negative), and the words in the dictionary are matched against the words in the text.

#### A Look Behind the Curtain

In this tool, the `twitteR` package is used to interact with twitter and collect the tweets, emoticons are stripped, and the data is passed to the `syuzhet` (the Russian word for 'the way the story is organized') package for the analysis. Finally, `ggplot2` is used to visualize the results.

The weights were rather simple, multiplying the **favoriteCount** column in the twitter data by the sentiment score.

#### Not so Urban Dictionary
To lend some context to the diferent sentiment dictionaries:

* **AFINN**: developed  by Finn Arup Nielsen in 2011 for microblogging sites. 2744 words.
* **Bing et al.**: developed by Minqing Hu and Bing Liu in 2006. 6800 words.
* **NRC**: developed by Mohammad, Saif M. and Turney, Peter D in 2010. a bit different than the others, gives different emotions as well as positive and negative. 14182 words.
* **syuzhet**: developed by the author of the package, Matthew Jockers. 10748 words.  

#### Source Code
Source code for this project can be found [here](https://github.com/pearstearns/Shiny-Twitter-Sentiment-Analysis)
