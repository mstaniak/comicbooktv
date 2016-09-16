shinyServer(function(input, output, session) {
  
  filteredData <- reactive({
    filterToPlot(showNames = c(firstName(), secondName()),
		 typeRating = input$typeRating,
		 seasons = input$seasons,
		 minRating = input$rt[1],
		 maxRating = input$rt[2],
		 minDate = input$dates[1],
		 maxDate = input$dates[2])
  })

  firstName <- reactive({
    names(showsTitles)[showsTitles == input$firstShow]
  })

  secondName <- reactive({
    names(showsTitles)[showsTitles == input$secondShow]
  }) 

  firstEpCounter <- reactive({
    filteredData() %>%
      filter(showTitle == firstName()) %>%
      n_distinct()
  })
  secondEpCounter <- reactive({
    filteredData() %>%
      filter(showTitle == secondName()) %>%
      n_distinct()
  })

  output$oneShowPlot  <- renderPlot({
    plotRatings(filteredData) 
  })

  output$compareShowsPlot <- renderPlot({
    plotRatings(filteredData)
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

  output$compareBot <- renderText({
    "Episode details:"
  })
})
