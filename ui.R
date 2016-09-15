shinyUI(fluidPage(navbarPage("Comicbook TV in data",
  tabPanel("About this app",
           includeMarkdown("www/about.md")), # tabPanel, includeMarkdown
  navbarMenu("One show",
             tabPanel("IMDb ratings",
                      fluidRow(
                        column(leftWidth,
                               selectInput("cShow",
                                           "Choose show to display",
                                           choices = showsTitles,
                                           selected = "aca"
                                           ), # selectInput
                               dateRangeInput("sldOne",
                                              "Choose dates range",
                                              start = "2012-01-01", end = "2016-09-01",
                                              min = "2012-01-01", max = "2016-09-01"), # dataRangeInput
                               sliderInput("sldOneRt",
                                           "Choose ratings range",
                                           1, 10,
                                           c(8,10))), # column, sliderInput, c()
                        column(rightWidth,
                               ggvisOutput("imdbPlotOne"), # ggvisOutput
                               htmlOutput("imdbTextOne")))), # tabPanel, #fluidRow, column, htmlOutput
             tabPanel("Nielsen ratings",
                      fluidRow(
                        column(leftWidth,
                               radioButtons("rtView",
                                            "",
                                            c("Nielsen ratings" = "niels",
                                              "Number of viewers" = "views"), # c()
                                            selected = "niels"), # radioButtons
                               selectInput("cShowNiels",
                                           "Select show to display",
                                           choices = showsTitles,
                                           selected = "aca"), # selectInput
                               conditionalPanel(condition = "input.rtView == 'niels",
                                                sliderInput("oneNielsCond",
                                                            "Choose ratings range",
                                                            0, 5, c(0,2))), #conditionalPanel, sliderInput, c()
                               conditionalPanel(condition = "input.rtView == 'views'",
                                                sliderInput("oneViewsCond",
                                                            "Choose range",
                                                            0, 5, c(0,2)))), #conditionalPanel, sliderInput, c(), column
                        column(rightWidth
                               ))), # tabPanel, fluidRow, column
             tabPanel("Misc",
                      fluidRow(
                        column(leftWidth), # column
                        column(rightWidth)))), # navbarMenu, tabPanel, fluidRow, column
  navbarMenu("Compare shows",
             tabPanel("IMDb ratings",
                      fluidRow(
                        column(leftWidth,
                               selectInput("selCompIMDb",
                                           "Select first show",
                                           choices = showsTitles,
                                           selected = "aca"), # selectInput
                               selectInput("selCompIMDb2",
                                           "Select second show",
                                           choices = showsTitles,
                                           selected = "aos")), # column, selectInput
                        column(rightWidth,
                               ggvisOutput("imdbComp")))), # navbarMenu, tabPanel, fluidRow, column
             tabPanel("Nielsen ratings",
                      fluidRow(
                        column(leftWidth,
                               selectInput("celCompNiels",
                                           "Select first show",
                                           choices = showsTitles,
                                           selected = "aca"),
                               selectInput("selCompNiels2",
                                           "Select show to compare",
                                           choices = showsTitles,
                                           selected = "aos")
                               ), # column
                        column(rightWidth
                               ))), # tabPanel, fluidRow, column
             tabPanel("Misc",
                      fluidRow(
                        column(leftWidth), # column
                        column(rightWidth)))), # navbarMenu, tabPanel, fluidRow, column
  navbarMenu("All shows",
             tabPanel("IMDb ratings",
                      fluidRow(
                        column(leftWidth
                               ),
                        column(rightWidth
                               ))), # tabPanel, fluidRow, column
             tabPanel("Nielsen ratings",
                      fluidRow(
                        column(leftWidth
                               ), # column
                        column(rightWidth
                               ))), # tabPanel, fluidRow, column
             tabPanel("Critics vs audience",
                      fluidRow(
                        column(leftWidth
                               ), # column
                        column(rightWidth
                               )))) # navbarMenu, tabPanel, fluidRow, column
))) # ShinyIU, fluidPage, navbarPage
