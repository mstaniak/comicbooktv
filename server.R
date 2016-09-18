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
  
  isNetflix <- reactive({
    any(c(firstName(), secondName()) %in% netflixShows)
  })
  
  filteredData <- reactive({
    seasonsList <- list(input$firstSeasons, input$secondSeasons)
    if(input$tabPanels == "oneShow") {
      seasonsList <- list(input$firstSeasons, input$firstSeasons)
    }
    filterToPlot(showNames = c(firstName(), secondName()),
		 chosenRating = input$typeRating,
		 seasons = seasonsList,
		 minRating = input$rt[1],
		 maxRating = input$rt[2],
		 minDate = input$dates[1],
		 maxDate = input$dates[2])
  })
  filterForNetflix <- reactive({
    if(!isNetflix()) {
      NULL
    } else {
	filterNetflix(showNames = c(firstName(), secondName()),
		      seasons = list(input$firstSeasons[1], input$secondSeasons[1]),
		      minRating = input$rt[1],
		      maxRating = input$rt[2])
    }
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

    if(isNetflix()) {
      updateRadioButtons(session, "typeRating",
			 selected = "imdbRating")
      shinyjs::disable(id = "typeRating")
      updateCheckboxGroupInput(session, "firstSeasons",
			       selected = "1")
      updateCheckboxGroupInput(session, "secondSeasons",
			       selected = "1")
    } else {
      shinyjs::enable(id = "typeRating")
    }

    if(input$typeRating == "vs") {
      shinyjs::disable(id = "rt")
      updateSliderInput(session, "rt",
			value = c(defaultSliderLeft, defaultSliderRight))
    } else {
      shinyjs::enable(id = "rt")
    }
  })

  output$oneShowPlot  <- renderPlot({
    if(isNetflix()) {
      plotNetflix(filterForNetflix())
    } else {
      if(input$typeRating == "vs") {
	plotRatingsCompareVS(filteredData(), trend = input$trend)
      } else {
	plotRatings(filteredData(),background = input$background, trend = input$trend) 
      }
    }
  })

  output$compareShowsPlot <- renderPlot({
    if(isNetflix()) {
      plotNetflix(filterForNetflix())
    } else {
      if(input$typeRating == "vs") {
        plotRatingsCompareVS(filteredData(), trend = input$trend)	
      } else {
	plotRatings(filteredData(), background = input$background, trend = input$trend)
      }
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
    if(isNetflix()) {
      giveDetails(filterForNetflix(), input$plotOneClick, "imdbRating", TRUE)
    } else {
      giveDetails(filteredData()[[2]], input$plotOneClick, input$typeRating)
    }
  })

  output$compareBot <- renderText({
    if(isNetflix()) {
      giveDetails(filterForNetflix(), input$plotTwoClick, "imdbRating", TRUE)
    } else {
      giveDetails(filteredData()[[2]], input$plotTwoClick, input$typeRating)
    }
  })
})
