library(shiny)
library(ggplot2)

source("helpers.R")

reportData <- read.csv("data/reportData.csv")
load("models/finalModel")
load("models/ovoModel")

shinyServer(function(input, output) {
  plat <- reactive({
    input$goButton
    platMap(input$platform)
  })
  
  ### Conquest Outcome Server Settings
  t1 <- reactive({
    input$goButton
    lapply(1:12, function(i){
      n <- paste0("t1p", i)
      genPlayerInput(isolate(input[[n]]), plat())
    })
  })
  
  t2 <- reactive({
    input$goButton
    lapply(1:12, function(i){
      n <- paste0("t2p", i)
      genPlayerInput(isolate(input[[n]]), plat())
    })
  })
  
  # TODO: The next two blocks can be done with validation after Shiny >= v0.9.1.9008
  # Generate reactive status for team 1 players
  output$t1p1Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p1), plat(), t1()[[1]])
                                 })
  output$t1p2Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p2), plat(), t1()[[2]])
                                 })
  output$t1p3Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p3), plat(), t1()[[3]])
                                 })
  output$t1p4Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p4), plat(), t1()[[4]])
                                 })
  output$t1p5Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p5), plat(), t1()[[5]])
                                 })
  output$t1p6Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p6), plat(), t1()[[6]])
                                 })
  output$t1p7Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p7), plat(), t1()[[7]])
                                 })
  output$t1p8Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p8), plat(), t1()[[8]])
                                 })
  output$t1p9Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t1p9), plat(), t1()[[9]])
                                 })
  output$t1p10Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t1p10), plat(), t1()[[10]])
                                  })
  output$t1p11Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t1p11), plat(), t1()[[11]])
                                  })
  output$t1p12Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t1p12), plat(), t1()[[12]])
                                  })
  
  # Generate reactive status for team 2 players
  output$t2p1Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p1), plat(), t2()[[1]])
                                 })
  output$t2p2Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p2), plat(), t2()[[2]])
                                 })
  output$t2p3Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p3), plat(), t2()[[3]])
                                 })
  output$t2p4Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p4), plat(), t2()[[4]])
                                 })
  output$t2p5Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p5), plat(), t2()[[5]])
                                 })
  output$t2p6Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p6), plat(), t2()[[6]])
                                 })
  output$t2p7Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p7), plat(), t2()[[7]])
                                 })
  output$t2p8Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p8), plat(), t2()[[8]])
                                 })
  output$t2p9Status <- renderUI({input$goButton
                                 genPlayerStatus(isolate(input$t2p9), plat(), t2()[[9]])
                                 })
  output$t2p10Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t2p10), plat(), t2()[[10]])
                                  })
  output$t2p11Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t2p11), plat(), t2()[[11]])
                                  })
  output$t2p12Status <- renderUI({input$goButton
                                  genPlayerStatus(isolate(input$t2p12), plat(), t2()[[12]])
                                  })
  
  # Generate team data frames for each team and generate prediction
  team1df <- reactive(lapply(t1(), getPlayerDF))
  team2df <- reactive(lapply(t2(), getPlayerDF))

  prediction <- reactive(predictResult(team1df(), team2df(), input$map, model))
  
  result <- reactive({
    if (all(sapply(t1(), is.null)) || all(sapply(t2(), is.null))) { return() }
    rp <- round(prediction()*100, 2)
    if (prediction() < 0.5) {
      paste0("Team 1 is predicted to win with ", 100-rp, "% confidence")
    } else {
      paste0("Team 2 is predicted to win with ", rp, "% confidence")
    }
  })
  
  output$prediction <- renderText(result())
  
  ### One v One Server Settings
  ovoP1plat <- reactive({
    input$ovoGoButton
    platMap(isolate(input$ovoP1plat))
  })
  ovoP2plat <- reactive({
    input$ovoGoButton
    platMap(isolate(input$ovoP2plat))
  })
  
  ovoP1 <- reactive({
    input$ovoGoButton
    genPlayerInput(isolate(input$ovoP1), ovoP1plat())
  })
  ovoP2 <- reactive({
    input$ovoGoButton
    genPlayerInput(isolate(input$ovoP2), ovoP2plat())
  })
  
  output$ovoP1status <- renderUI({
    input$ovoGoButton
    genPlayerStatus(isolate(input$ovoP1), ovoP1plat(), ovoP1())
  })
  
  output$ovoP2status <- renderUI({
    input$ovoGoButton
    genPlayerStatus(isolate(input$ovoP2), ovoP2plat(), ovoP2())
  })
  
  ovoPred <- reactive(predictResult(list(getPlayerDF(ovoP1())), 
                                    list(getPlayerDF(ovoP2())), 
                                    NULL, ovoModel))
  
  ovoResult <- reactive(getOVOResult(ovoP1(), ovoP2(), ovoPred(), 
                                     input$ovoP1, input$ovoP2))
  
  output$ovoOutcome <- renderText(ovoResult())
})
