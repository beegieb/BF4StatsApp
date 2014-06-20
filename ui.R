library(shiny)

source("helpers.R")

shinyUI(
  navbarPage("Battlefield 4 Stat Tools",
    tabPanel("One v One Predictions",
      fluidRow(
        h2("Enter the name of two players to predict who will win in a 1v1...GIT REKT SCRUBS")
        ),
      fluidRow(
        column(3,
          radioButtons("ovoP1plat", label = "Platform", choices = ovoPlatforms),
          textInput("ovoP1", label="Player Name"),
          uiOutput("ovoP1status")),
          column(3,
          radioButtons("ovoP2plat", label = "Platform", choices = ovoPlatforms),
          textInput("ovoP2", label="Player Name"),
          uiOutput("ovoP2status"))
          ),
      fluidRow(actionButton("ovoGoButton", "Duel!")),
      fluidRow(h2(textOutput("ovoOutcome")))
      ),
    tabPanel("Predict Conquest Outcome",
      fluidRow(h3(textOutput("prediction"))),
      fluidRow(
        column(4,
          selectInput("map",
            label = "Map",
            choices = mapNames[order(mapNames)]
            )
          ),
        column(4,
          selectInput("platform", label = "Platform", choices = platforms)
          )
        ),
      fluidRow(actionButton("goButton", "Predict!")),
      fluidRow(
        column(4,
          h3("Team 1"),
          textInput("t1p1", label = "Player 1 Name"),
          uiOutput("t1p1Status"),
          textInput("t1p2", label = "Player 2 Name"),
          uiOutput("t1p2Status"),
          textInput("t1p3", label = "Player 3 Name"),
          uiOutput("t1p3Status"),
          textInput("t1p4", label = "Player 4 Name"),
          uiOutput("t1p4Status"),
          textInput("t1p5", label = "Player 5 Name"),
          uiOutput("t1p5Status"),
          textInput("t1p6", label = "Player 6 Name"),
          uiOutput("t1p6Status"),
          textInput("t1p7", label = "Player 7 Name"),
          uiOutput("t1p7Status"),
          textInput("t1p8", label = "Player 8 Name"),
          uiOutput("t1p8Status"),
          textInput("t1p9", label = "Player 9 Name"),
          uiOutput("t1p9Status"),
          textInput("t1p10", label = "Player 10 Name"),
          uiOutput("t1p10Status"),
          textInput("t1p11", label = "Player 11 Name"),
          uiOutput("t1p11Status"),
          textInput("t1p12", label = "Player 12 Name"),
          uiOutput("t1p12Status")
          ),
        column(4,
          h3("Team 2"),
          textInput("t2p1", label = "Player 1 Name"),
          uiOutput("t2p1Status"),
          textInput("t2p2", label = "Player 2 Name"),
          uiOutput("t2p2Status"),
          textInput("t2p3", label = "Player 3 Name"),
          uiOutput("t2p3Status"),
          textInput("t2p4", label = "Player 4 Name"),
          uiOutput("t2p4Status"),
          textInput("t2p5", label = "Player 5 Name"),
          uiOutput("t2p5Status"),
          textInput("t2p6", label = "Player 6 Name"),
          uiOutput("t2p6Status"),
          textInput("t2p7", label = "Player 7 Name"),
          uiOutput("t2p7Status"),
          textInput("t2p8", label = "Player 8 Name"),
          uiOutput("t2p8Status"),
          textInput("t2p9", label = "Player 9 Name"),
          uiOutput("t2p9Status"),
          textInput("t2p10", label = "Player 10 Name"),
          uiOutput("t2p10Status"),
          textInput("t2p11", label = "Player 11 Name"),
          uiOutput("t2p11Status"),
          textInput("t2p12", label = "Player 12 Name"),
          uiOutput("t2p12Status")
          )
        )
      )
    )
  )