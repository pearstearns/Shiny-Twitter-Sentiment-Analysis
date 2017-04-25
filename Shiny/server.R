library(dplyr)
library(ggplot2)
library(plotly)
library(syuzhet)
library(tidyr)
library(twitteR)


shinyServer(function(input, output) {
        output$sentPlot <- renderPlotly({
                ckey = "#####"
                csec = "#####"
                atok = "#####"
                asec = "#####"
                
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
                        p <- ggplot(gather(tweets[,17:26]), aes(key, value)) + 
                                geom_bar(stat = "identity", fill = "#e920b5", color = "#e920b5") +
                                xlab("Emotions") +
                                ylab("Frequency")
                        ggplotly(p)
                } else {
                        tweets <- tweets %>% 
                                mutate(ms = mean(sent))
                        if(sum(sent) < 0){
                                tweets$ns <- log(abs(sum(tweets$sent))) * -1
                        } else {
                                tweets$ns <- log(sum(tweets$sent))
                        }
                        p <- ggplot(tweets, aes(created, sent)) + 
                                geom_jitter() + 
                                geom_smooth(color = "#e95420") + 
                                geom_hline(aes(yintercept = tweets$ms, linetype = "Mean Sentiment"), color = "#20b5e9", show.legend = T) +
                                geom_hline(aes(yintercept = tweets$ns, linetype = "Net Sentiment"), color = "#20e954", show.legend = T) +
                                xlab("Time") +
                                ylab("Sentiment Score")
                        ggplotly(p)
                }
        })

})
