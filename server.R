shinyServer(function(input, output, session) {
  
  filteredData <- reactive({
    if(input$tabPanels == "oneShow") {
      chosenNames <- firstName()
    } else {
      chosenNames <- c(firstName(), secondName())
    } 
    filterToPlot(showNames = chosenNames,
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
    filteredData()[[2]] %>%
      filter(showTitle == firstName()) %>%
      n_distinct()
  })
  secondEpCounter <- reactive({
    filteredData()[[2]] %>%
      filter(showTitle == secondName()) %>%
      n_distinct()
  })

  output$oneShowPlot  <- renderPlot({
    plotRatings(filteredData()) 
  })

  output$compareShowsPlot <- renderPlot({
    plotRatings(filteredData())
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

  output$oneShowInfo <- renderUI({
    if(is.null(input$plotOneClick)) {
      return("Click a point to display details about the episode. ")
    } else {
        point <- unlist(nearPoints(filteredData()[[2]], input$plotOneClick, xvar = "airDate", yvar = "rating"))
        HTML(paste(paste("Episode details:", paste(point["episode"], point["season"], sep = "x")), 
		   paste("Title:", point["title"]),
		   paste("Rating:", round(as.numeric(point["rating"]), 2)),
		   paste("Number of votes:", point["numOfVotes"]),
		   sep = "<br />"))
    }
  })

  output$compareBot <- renderText({
#     filteredData()[[2]] %>%
#       filter(all.equal(airDate, ))
    "Episode details:"
  })
})
