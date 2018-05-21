library(shiny)
library(dplyr)
library(rtweet)
library(lubridate)
twitter_token = create_token(app = "Daniel Truver", consumer_key = "EZBBlVghz6AgCqWxN3JSFW21m",
                             consumer_secret = "OJRRViKU6p57XRZGjH2hfrffIhptybiEGl1UQmNU32W7fIksOs")

accounts = list()
accounts[[1]] = "NateSilver538"
accounts[[2]] = "billmaher"
accounts[[3]] = "DukeForge"
accounts[[4]] = "VictoriHealth"
accounts[[5]] = "realDonaldTrump"
# accounts[[6]] = "califf001"

all_tweets = data_frame()
for(userID in accounts){
  user_tweets = get_timeline(user = userID, n = 20)
  all_tweets = rbind(all_tweets, user_tweets)
  Sys.sleep(runif(1,1,2))
}
recent_tweets = all_tweets %>%
  filter(created_at >= today()-1)%>%
  .[order(.$created_at, decreasing = TRUE),] %>%
  mutate(justDay = date(created_at)) %>%
  select(screen_name, justDay, text) 
colnames(recent_tweets) = c("User", "Date", "Tweet")

ui = fluidPage(
  titlePanel("Tweets of Interest to the Forge"),
  mainPanel(
    # each headline can be linked to a modal dialog
    # verbatimTextOutput("wordcount"),
    verbatimTextOutput("message"),
    dataTableOutput("tweets"),
    plotOutput("plot")
  )
)

server = function(input, output) {
  output$tweets = renderDataTable(recent_tweets)
}

shinyApp(ui = ui, server = server)
