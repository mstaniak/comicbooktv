library(shiny)
library(devtools)
# if(!require(ToolsForTVShowsApp)) {
#   devtools:: install_github("mstaniak/comicbookshows", dependencies = FALSE)
# }
devtools::install_github("mstaniak/comicbookshows", dependencies = FALSE)
library(dplyr)
library(lubridate)
library(ggplot2)
library(markdown)
library(lazyeval)

showsTitles <- c("aca", "aos", "arr", "con", "dde", "fla", "got", "izo", "jjo", "lot", "luc", "pre", "sgi")
episodes %>%
  select(showTitle) %>%
  distinct() %>%
  unlist(use.names = FALSE) -> names(showsTitles)

defaultMinDate <- min(episodes$airDate) 
defaultMaxDate <- max(episodes$airDate)
defaultSeasons <- max(episodes$season)
defaultSliderLeft <- min(episodes$imdbRating)
defaultSliderRight <- max(episodes$imdbRating)
defaultSeasonsNumber <- max(episodes$season[episodes$showTitle == names(showsTitles)[1]])
defaultSeasonsChoices <- as.character(1:defaultSeasonsNumber)
names(defaultSeasonsChoices) <- as.numeric(defaultSeasonsChoices)

leftWidth <- 2
rightWidth <- 12 - leftWidth
