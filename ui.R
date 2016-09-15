shinyUI(
  fluidPage(
    fluidRow(
      column(leftWidth,
	selectInput("firstShow",
		    "Select show to display",
		    choices = showsTitles,
		    selected = showsTitles[1]),
	conditionalPanel("input.tabPanels == 'compareShows'",
	  selectInput("secondShow",
		      "Select show to compare",
		      choices = showsTitles,
		      selected = showsTitles[2])),
        sliderInput("rt",
                    "Rating",
                    min = floor(defaultSliderLeft),
		    max = ceiling(defaultSliderRight),
                    value = c(defaultSliderLeft,
			      defaultSliderRight),
		    step = 0.1),
        dateRangeInput("dates",
                  "Display episode aired between",
		  min = defaultMinDate,
		  max = defaultMaxDate,
		  start = defaultMinDate,
		  end = defaultMaxDate
                 ),
	checkboxGroupInput("seasons",
		           "Choose seasons to display",
			   choices = defaultSeasonsChoices,
			   selected = defaultSeasonsChoices
		           )
            ),
      column(rightWidth,
        navbarPage("Comicbook TV",
          tabPanel("One show",
		   value = "oneShow",
            plotOutput("oneShowPlot")
		  ),           
          tabPanel("Compare shows",
		   value = "compareShows",
	    plotOutput("compareShowsPlot")
		  ),
          tabPanel("All shows",
		   value = "compareShows",
	    plotOutput("allShowsPlot")
		  ),
          tabPanel("About this app",
		   value = "aboutThisApp",
            includeMarkdown("www/about.md")),
          id = "tabPanels"
	))
)))
