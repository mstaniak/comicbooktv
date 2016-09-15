library(shiny)
library(devtools)
library(ggvis)
# install_github("mstaniak/comicbookshows", dependencies = F)
# if(!require(ToolsForTVShowsApp)) {
# 	install_github("mstaniak/comicbookshows")
# }
library(ToolsForTVShowsApp)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

showsTitles <- c("aca", "aos", "arr", "con", "dde", "fla", "got", "izo", "jjo", "lot", "luc", "pre", "sgi")
episodes %>%
  select(showTitle) %>%
  distinct() %>%
  unlist(use.names = FALSE) -> names(showsTitles)

defaultMinDate <- min(episodes$airDate) 
defaultMaxDate <- max(episodes$airDate)
defaultSeasons <- max(episodes$season)

leftWidth <- 3
rightWidth <- 12 - leftWidth
