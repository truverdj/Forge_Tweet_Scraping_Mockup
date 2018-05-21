library(rvest)
library(dplyr)
page_mc = read_html("https://machinelearning.duke.edu/")

events = page_mc %>% 
  html_nodes(".events-row") %>%
  html_text()