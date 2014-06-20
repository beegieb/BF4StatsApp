BF4 Stat-Tools Webapp
---------------------

### Introduction
This simple web application uses battle report data collected from [Battlelog] [1]
to implement two data-driven tools:

- A 1v1 prediction algorithm for predicting the outcome of a hypothetical 1v1 encounter
between two players
- A 12v12 Conquest prediction algorithm that predicts the outcome of a game of 12v12
Conquest given a list of players and a map

### Requirements
- The R language with the packages
    - shiny v0.9.1
    - caret v6.0-30
    - rjson v0.2.13
    - ggplot2 v0.9.3.1

RStudio is also a very useful tool and highly recommended for working with R and shiny

### Running the application
```
library(shiny)
setwd(/path/to/directory)
runApp()
```

This will start the application and automatically open your browser to the application.
By default runApp selects a port at random and sets the host to the localhost 
"127.0.0.1", you can change this behaviour with the host= and port= parameters in runApp

### Using the 1v1 prediction tool
Simply enter the names of two Battlefield 4 players and their platforms and hit 'Duel'

As an example, try:
Beegie_B on PS4 vs Smoked_Baboon on PS3 

### Using the 12v12 Conquest prediction tool
Enter the names of at least 1 player per team and hit the "Predict" button. Both players
must be on the same platform. Selecting the map will also give different prediction 
outcomes. To avoid unecessarily hitting the [BF4stats.com API] [2] too frequently only
hit the predict button when you have entered the names of all players you want to
compare

[1]: http://battlelog.battlefield.com/bf4/
[2]: http://bf4stats.com/
