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

showsTitles <- c("aca", "aos", "arr", "con", "fla", "got", "izo", "lot", "luc", "pre", "sgi")
episodesPlus  %>%
  filter(channel != "Netflix") %>%
  select(showTitle) %>%
  distinct() %>%
  unlist(use.names = FALSE) %>%
  sort() -> names(showsTitles)

defaultMinDate <- min(episodes$airDate) 
defaultMaxDate <- max(episodes$airDate)
defaultSeasons <- max(episodes$season)
defaultSliderLeft <- min(episodes$imdbRating)
defaultSliderRight <- max(episodes$imdbRating)
defaultSliderNielsenLeft <- min(episodes$nielsenRating, na.rm = T)
defaultSliderNielsenRight <- max(episodes$nielsenRating, na.rm = T)
defaultSeasonsNumber <- max(episodes$season[episodes$showTitle == names(showsTitles)[1]])
defaultSeasonsNumberTwo <- max(episodes$season[episodes$showTitle == names(showsTitles[2])])
defaultSeasonsChoices <- as.character(1:defaultSeasonsNumber)
names(defaultSeasonsChoices) <- defaultSeasonsChoices
defaultSeasonsChoicesTwo <- as.character(1:defaultSeasonsNumberTwo)
names(defaultSeasonsChoicesTwo) <- defaultSeasonsChoicesTwo

leftWidth <- 2
rightWidth <- 12 - leftWidth
