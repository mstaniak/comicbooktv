library(shiny)
library(devtools)
library(ggvis)
library(ToolsForTVShowsApp)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(markdown)

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

leftWidth <- 3
rightWidth <- 12 - leftWidth
