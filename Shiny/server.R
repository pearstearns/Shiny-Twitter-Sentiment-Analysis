#server.R

library(dplyr)
library(ggplot2)
library(tidyr)
library(twitteR)

shinyServer(function(input, output) {
        output$sentPlot <- renderPlot({
                ckey = "######"
                csec = "######"
                atok = "######"
                asec = "######"
                
                setup_twitter_oauth(consumer_key = ckey,
                                    consumer_secret = csec,
                                    access_token = atok,
                                    access_secret = asec
                )
                
                dict <- switch(input$dict,
                               "afinn" = function(x){get_sentiment(char_v = x, method = "afinn")},
                               "bing" = function(x){get_sentiment(char_v = x, method = "bing")},
                               "nrc" = get_nrc_sentiment,
                               "syuzhet" = function(x){get_sentiment(char_v = x, method = "syuzhet")}
                )
                
                if(input$sentStr != "" & input$sentHash != ""){
                        tweets <- searchTwitter(paste(input$sentStr, "OR", input$sentHash, sep = " "),
                                                n = input$tnum, 
                                                lang = "en") %>% 
                                  twListToDF()
                } else if(input$sentHash == ""){
                        tweets <- searchTwitter(input$sentStr, n = input$tnum, lang = "en") %>% twListToDF()
                } else {
                        tweets <- searchTwitter(input$sentHash, n = input$tnum, lang = "en") %>% twListToDF()
                }
                
                tweets$text <- sapply(tweets$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
                sent <- dict(tweets$text)
                tweets <- bind_cols(tweets, as.data.frame(sent))
                
                if(input$wt == T){
                        if(input$dict != "nrc"){
                                mutate(tweets, sent = favoriteCount * sent)
                        } else {
                                for(i in 17:26){
                                        tweets[,i] <- tweets[,i] * tweets[,3]
                                }
                        }
                }
                
                if(input$dict == "nrc"){
                        ggplot(gather(tweets[,17:26]), aes(key, value), fill = key) + 
                                geom_bar(stat = "identity") +
                                xlab("Emotions") +
                                ylab("Frequency")
                } else {
                        ggplot(tweets, aes(created, sent)) + 
                                geom_jitter() + 
                                geom_smooth() + 
                                geom_hline(yintercept = mean(tweets$sent), 
                                           color = "red") +
                                geom_hline(yintercept = log(sum(tweets$sent)),
                                           color = "green") +
                                xlab("Time") +
                                ylab("Sentiment Score") +
                                scale_fill_manual(values = c("red", "green", "blue"),
                                                  name = "Measures",
                                                  breaks = c("Mean Sentiment", "Net Sentiment", "Trend"),
                                                  labels = c("Mean Sentiment", "Net Sentiment", "Trend"))
                }
        })
})
