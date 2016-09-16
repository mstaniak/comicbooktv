shinyServer(function(input, output, session) {
  firstName <- reactive({
    names(showsTitles)[showsTitles == input$firstShow]
  })
  secondName <- reactive({
    names(showsTitles)[showsTitles == input$secondShow]
  }) 

#   firstEpCounter <- reactive({
#     episodes %>%
#       filter(showTitle == firstName(),
# 	     )
#   })

  output$oneShowPlot  <- renderPlot({
    plotRatings(showName = firstName(),
		typeRating = input$typeRating) 
  })
  output$compareShowsPlot <- renderPlot({
    plotRatings(showName = c(firstName(), secondName()),
		typeRating = input$typeRating )
  })
  output$oneShowInfo <- renderText({
    if(is.null(input$plotOneClick)) {
      return("")
    } else {
        paste(input$plotOneClick$x, input$plotOneClick$y)	    
      }  
  })
  output$compareInfo1 <- renderText({
    paste(firstName(), "has", "lol",
	  "episodes in this time and ratings  range.")
  })
  output$compareInfo2 <- renderText({
    paste0("lalala", "twoja stara")
  })
})
