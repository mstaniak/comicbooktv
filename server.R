shinyServer(function(input, output, session) {
  firstName <- reactive({
    names(showsTitles)[showsTitles == input$firstShow]
  })

  secondName <- reactive({
    if(input$tabPanels == "compareShows") {
      names(showsTitles)[showsTitles == input$secondShow]
    } else if(input$tabPanels == "oneShow") {
      firstName()
    }
  }) 
  
  filteredData <- reactive({
    seasonsList <- list(input$firstSeasons, input$secondSeasons)
    if(input$tabPanels == "oneShow") {
      seasonsList <- list(input$firstSeasons, input$firstSeasons)
    }
    filterToPlot(showNames = c(firstName(), secondName()),
		 typeRating = input$typeRating,
		 seasons = seasonsList)
		 minRating = input$rt[1],
		 maxRating = input$rt[2],
		 minDate = input$dates[1],
		 maxDate = input$dates[2])
  })

  firstEpCounter <- reactive({
    filteredData()[[2]] %>%
      filter(showTitle == firstName()) %>%
      n_distinct()
  })
  secondEpCounter <- reactive({
    filteredData()[[2]] %>%
      filter(showTitle == secondName()) %>%
      n_distinct()
  })

  firstMaxSeason <- reactive({
    shows %>%
      filter(showTitle == firstName()) %>%
      summarise(maxS = max(season, na.rm = TRUE)) %>%
      select(maxS) %>%
      unlist(use.names = FALSE) 
  })
  secondMaxSeason <- reactive({
    shows %>% 
      filter(showTitle == secondName()) %>%
      summarise(maxS = max(season, na.rm = TRUE)) %>%
      select(maxS) %>%
      unlist(use.names = FALSE)
  })

  observe({
    if(input$typeRating == "nielsenRating") {
      updateSliderInput(session, "rt",
			min = floor(defaultSliderNielsenLeft),
			max = ceiling(defaultSliderNielsenRight),
			value = c(defaultSliderNielsenLeft, defaultSliderNielsenRight))
    } else {
      updateSliderInput(session, "rt",       
			min = floor(defaultSliderLeft),
			max = ceiling(defaultSliderRight),
			value = c(defaultSliderLeft,
				  defaultSliderRight))
    }

    seasonsChoices <- as.character(1:firstMaxSeason())
    names(seasonsChoices) <- as.numeric(seasonsChoices)
    updateCheckboxGroupInput(session, "firstSeasons",
			     choices = seasonsChoices,
			     selected = seasonsChoices,
			     inline = TRUE)
    seasonsChoicesTwo <- as.character(1:secondMaxSeason())
    names(seasonsChoicesTwo) <- as.numeric(seasonsChoicesTwo)
    updateCheckboxGroupInput(session, "secondSeasons",
			     choices = seasonsChoicesTwo,
			     selected = seasonsChoicesTwo,
			     inline = TRUE)
  })

  output$oneShowPlot  <- renderPlot({
    plotRatings(filteredData(), trend = input$trend) 
  })

  output$compareShowsPlot <- renderPlot({
    plotRatings(filteredData(), trend = input$trend)
  })

  output$oneShowInfo <- renderText({
    if(is.null(input$plotOneClick)) {
      return("")
    } else {
        paste(input$plotOneClick$x, input$plotOneClick$y)	    
      }  
  })

  output$compareTop <- renderText({
    paste(firstName(), "has", firstEpCounter(),
	  "episodes in this range.")
  })

  output$compareMid <- renderText({
    paste(secondName(), "has", secondEpCounter(),
	  "episodes in this range.")
  })

  output$oneShowInfo <- renderText({
   giveTooltip(filteredData()[[2]], input$plotOneClick, input$typeRating)
  })

  output$compareBot <- renderText({
    giveTooltip(filteredData()[[2]], input$plotTwoClick, input$typeRating)
  })
})
