shinyServer(function(input, output, session) {
  firstName <- reactive({
    names(showsTitles)[showsTitles == input$firstShow]
  })

  secondName <- reactive({
    if(input$tabPanels == "compareShows") {
      names(showsTitles)[showsTitles == input$secondShow]
    } else {
      firstName()
    }
  }) 
  
  isNetflix <- reactive({
    any(c(firstName(), secondName()) %in% netflixShows)
  })
  
  seasonsList <- reactive({
    seasonsList <- vector("list", 2)
    if(input$typeRating == "vs" | input$tabPanels == "compareShows") {
      seasonsList[[1]] <- input$firstSeasonsRadio
      seasonsList[[2]] <- input$secondSeasonsRadio
    } else {
      seasonsList[[1]] <- input$firstSeasons
      seasonsList[[2]] <- input$secondSeasons
    }
    if(input$tabPanels == "oneShow") {
      seasonsList[[2]] <- seasonsList[[1]]
    }
    return(seasonsList)
  })
  
  filteredData <- reactive({
    filterToPlot(showNames = c(firstName(), secondName()),
		 chosenRating = input$typeRating,
		 seasons = seasonsList(),
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
		      seasons = seasonsList(), 
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
    names(seasonsChoices) <- seasonsChoices
    updateCheckboxGroupInput(session, "firstSeasons",
			     choices = seasonsChoices,
			     selected = seasonsChoices,
			     inline = TRUE)
    seasonsChoicesTwo <- as.character(1:secondMaxSeason())
    names(seasonsChoicesTwo) <- seasonsChoicesTwo
    updateCheckboxGroupInput(session, "secondSeasons",
			     choices = seasonsChoicesTwo,
			     selected = seasonsChoicesTwo,
			     inline = TRUE)

    seasonsChoicesRadio <- as.character(1:firstMaxSeason())
    names(seasonsChoicesRadio) <- seasonsChoicesRadio
    updateRadioButtons(session, "firstSeasonsRadio",
		       choices = seasonsChoicesRadio,
		       inline = TRUE)
    seasonsChoicesRadioTwo <- as.character(1:secondMaxSeason())
    names(seasonsChoicesRadioTwo) <- seasonsChoicesRadioTwo
    updateRadioButtons(session, "secondSeasonsRadio",
		       choices = seasonsChoicesRadioTwo,
		       inline = TRUE)

    if(isNetflix()) {
      updateRadioButtons(session, "typeRating",
			 selected = "imdbRating")
      shinyjs::disable(id = "typeRating")
      shinyjs::disable(id = "background")
      shinyjs::disable(id = "separate")
      updateCheckboxGroupInput(session, "firstSeasons",
			       selected = "1")
      updateCheckboxGroupInput(session, "secondSeasons",
			       selected = "1")
    } else {
      shinyjs::enable(id = "typeRating")
      shinyjs::enable(id = "background")
      shinyjs::enable(id = "separate")
    }

    if(input$typeRating == "vs") {
      shinyjs::disable(id = "rt")
      updateSliderInput(session, "rt",
			value = c(defaultSliderLeft, defaultSliderRight))
    } else {
      shinyjs::enable(id = "rt")
    }
    if(input$separate | input$tabPanels == "compareShows") {
      shinyjs::disable(id = "dates") 
    } else {
      shinyjs::enable(id = "dates")
    }
  })

  output$oneShowPlot  <- renderPlot({
    if(isNetflix()) {
      if(!input$separate) {
	plotNetflix(filterForNetflix(), trend = input$trend) 
      } else {
	plotNetflix(filterForNetflix(), trend = input$trend) + facet_wrap(~season, scales = "free")
      }
    } else {
      if(input$typeRating == "vs") {
	plotRatingsCompareVS(filteredData(), trend = input$trend)    
      } else {
	if(!input$separate) {
	  plotRatings(filteredData(),background = input$background, trend = input$trend)
	} else {
	  plotRatings(filteredData(),background = input$background, trend = input$trend) + facet_wrap(~season, scales = "free", ncol = 1)
	}
      }
    }

  })
  
  output$oneShowInfo <- renderText({
    if(isNetflix()) {
      giveDetails(filterForNetflix(), input$plotOneClick, "imdbRating", TRUE)
    } else {
      giveDetails(filteredData(), input$plotOneClick, input$typeRating)
    }
  })

  output$compareShowsPlot <- renderPlot({
    if(isNetflix()) {
      plotNetflix(filterForNetflix(), trend = input$trend)
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
})

