shinyUI(navbarPage(
        "Twitter Sentiment Analysis",
        theme = shinytheme("united"),
                 tabPanel("Model", icon = icon("bar-chart-o"),
                          sidebarLayout(
                                  sidebarPanel(
                                          helpText("For the text input sections, pick one or both of topic and hashtag"),
                                          textInput("sentStr", "Pick a topic", "science"),
                                          textInput("sentHash", "Pick a #hashtag"),
                                          sliderInput("tnum", "# of Tweets:", 
                                                      min = 50, 
                                                      max = 3200, 
                                                      step = 50,
                                                      value = 50),
                                          radioButtons("dict", "Sentiment Dictionary:",
                                                       c("AFINN" = "afinn",
                                                         "Bing et al." = "bing",
                                                         "NRC" = "nrc",
                                                         "syuzhet" = "syuzhet"
                                                       )),
                                          checkboxInput("wt", "Weighted by Favorites?", FALSE),
                                          submitButton(text = "Let's Get Sentimental", icon("cog", lib = "glyphicon")),
                                          helpText("More tweets mean better information, but longer loading time.",
                                                   "Larger values can take up to five minutes")
                                  ),
                                  mainPanel(
                                          plotlyOutput("sentPlot", height = "100%", width = "100%")
                                  ))
                 ),
                 tabPanel("Documentation", icon = icon("info-circle", lib = "font-awesome"),
                          fluidRow(
                                  column(8, offset = 2,
                                         includeMarkdown("about.md"))
                                     
                          )
                 )
        )
)
