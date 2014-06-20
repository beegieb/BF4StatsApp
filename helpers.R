library(caret)
library(shiny)
library(rjson)

platforms <- c("PS3", "Xbox 360")
ovoPlatforms <- c("PC", "PS4", "Xbox One", "PS3", "Xbox 360")
mapNames <- read.csv("data/mapNames.csv")$name

platMap <- function(plat){
  if (plat == "PS3") { "ps3" }
  else if (plat == "PS4") { "ps4" }
  else if (plat == "Xbox 360") { "xbox" }
  else if (plat == "Xbox One") { "xone" }
  else if (plat == "PC") { "pc" }
}

getPlayerStats <- function(name, plat) {
  bf4statsurl <- "http://api.bf4stats.com/api/playerInfo"
  opt <- "stats,extra,vehicleCategory,weaponCategory"
  name <- gsub(" ", "+", name)
  query <- paste0("?plat=", plat, "&name=", name, "&opt=", opt)
  player.json <- tryCatch(
    readLines(paste0(bf4statsurl, query)),
    error=function(e) "failed")
  player.json
}

genPlayerStatus <- function(formInput, plat, playerData){
  if (formInput == "") {
    NULL
  } else if (is.null(playerData)) {
    p(paste("Failed to find", formInput), style="color:red")
  } else if (is.null(playerData$stats)) {
    name <- gsub(" ", "%20", formInput)
    url <- paste("http://bf4stats.com", plat, name, sep="/")
    p("Player stats are stale, please browse to ", 
      a(href=url, url), " to refresh the players stats", style="color:orange")
  } else {
    p("Found!", style="color:green")
  }
}

genPlayerInput <- function(playerName, platform){
  if (playerName == "") { NULL }
  else {
    pj <- getPlayerStats(playerName, platform)
    if (pj == "failed") {
      NULL
    } else {
      fromJSON(pj)
    }
  }
}

nullPlayer <- data.frame(rank=0, skill=0, kdr=0, wlr=0, spm=0, gspm=0, kpm=0,
                         sfpm=0, hkp=0, khp=0, accuracy=0, timePlayed=0, kills=0, deaths=0, headshots=0,
                         shotsFired=0, shotsHit=0, suppressionAssists=0, avengerKills=0, saviorKills=0,
                         nemesisKills=0, numRounds=0, roundsFinished=0, numWins=0, numLosses=0, 
                         killStreakBonus=0, nemesisStreak=0, resupplies=0, repairs=0, heals=0, revives=0,
                         longestHeadshot=0, flagDefend=0, flagCaptures=0, killAssists=0, vehicleDestroyed=0, 
                         vehicleDamage=0, dogtagsTaken=0, score.total=0, score.conquest=0, score.award=0,
                         score.bonus=0, score.unlock=0, score.vehicle=0, score.team=0, score.squad=0,
                         score.general=0, score.rank=0, score.combat=0, score.assault=0, score.engineer=0,
                         score.support=0, score.recon=0, score.commander=0, time.assault=0, time.engineer=0,
                         time.support=0, time.recon=0, time.commander=0, time.vehicle=0,
                         time.vehicle.precent=0, time.weapon=0, time.weapon.percent=0, stars.assault=0,
                         stars.engineer=0, stars.support=0, stars.recon=0, stars.commander=0, spm.assault=0,
                         spm.engineer=0, spm.support=0, spm.recon=0, spm.commander=0, kills.weapon=0,
                         kills.weapon.percent=0, kills.vehicle=0, kills.vehicle.percent=0, kpm.weapon=0,
                         kpm.vehicle=0, ribbons=0, medals=0
)

playerDataToDF <- function(pj) {
  player <- pj$player
  stats <- pj$stats
  scores <- stats$scores
  kits <- stats$kits
  extra <- stats$extra
  weap <- pj$weaponCategory
  vehi <- pj$vehicleCategory
  data.frame(
    rank = stats$rank,
    skill = stats$skill,
    kdr = extra$kdr,
    wlr = extra$wlr,
    spm = extra$spm,
    gspm = extra$gspm,
    kpm = extra$kpm,
    sfpm = extra$sfpm,
    hkp = extra$hkp,
    khp = extra$khp,
    accuracy = extra$accuracy,
    timePlayed = stats$timePlayed,
    kills = stats$kills,
    deaths = stats$deaths,
    headshots = stats$headshots,
    shotsFired = stats$shotsFired,
    shotsHit = stats$shotsHit,
    suppressionAssists = stats$suppressionAssists,
    avengerKills = stats$avengerKills,
    saviorKills = stats$saviorKills,
    nemesisKills = stats$nemesisKills,
    numRounds = stats$numRounds,
    roundsFinished = extra$roundsFinished,
    numWins = stats$numWins,
    numLosses = stats$numLosses,
    killStreakBonus = stats$killStreakBonus,
    nemesisStreak = stats$nemesisStreak,
    resupplies = stats$resupplies,
    repairs = stats$repairs,
    heals = stats$heals,
    revives = stats$revives,
    longestHeadshot = stats$longestHeadshot,
    flagDefend = stats$flagDefend,
    flagCaptures = stats$flagCaptures,
    killAssists = stats$killAssists,
    vehicleDestroyed = stats$vehiclesDestroyed,
    vehicleDamage = stats$vehicleDamage,
    dogtagsTaken = stats$dogtagsTaken,
    score.total = scores$score,
    score.conquest = stats$mode[[1]]$score,
    score.award = scores$award,
    score.bonus = scores$bonus,
    score.unlock = scores$unlock,
    score.vehicle = scores$vehicle,
    score.team = scores$team,
    score.squad = scores$squad,
    score.general = scores$general,
    score.rank = scores$rankScore,
    score.combat = scores$combatScore,
    score.assault = kits$assault$score,
    score.engineer = kits$engineer$score,
    score.support = kits$support$score,
    score.recon = kits$recon$score,
    score.commander = kits$commander$score,
    time.assault = kits$assault$time,
    time.engineer = kits$engineer$time,
    time.support = kits$support$time,
    time.recon = kits$recon$time,
    time.commander = kits$commander$time,
    time.vehicle = extra$vehicleTime,
    time.vehicle.precent = extra$vehTimeP,
    time.weapon = extra$weaponTime,
    time.weapon.percent = extra$weaTimeP,
    stars.assault = kits$assault$stars,
    stars.engineer = kits$engineer$stars,
    stars.support = kits$support$stars,
    stars.recon = kits$recon$stars,
    stars.commander = kits$commander$stars,
    spm.assault = kits$assault$spm,
    spm.engineer = kits$engineer$spm,
    spm.support = kits$support$spm,
    spm.recon = kits$recon$spm,
    spm.commander = kits$commander$spm,
    kills.weapon = extra$weaKills,
    kills.weapon.percent = extra$weaKillsP,
    kills.vehicle = extra$vehKills,
    kills.vehicle.percent = extra$vehKillsP,
    kpm.weapon = extra$weaKpm,
    kpm.vehicle = extra$vehKpm,
    ribbons = extra$ribbons,
    medals = extra$medals
  )  
}

getPlayerDF <- function(pj) {
  if (is.null(pj)) { nullPlayer }
  else if (is.null(pj$stats)) { nullPlayer }
  else { playerDataToDF(pj) }
}

getTeamAvg <- function(team) {
  tot <- nullPlayer
  for (p in team) {
    tot <- tot + p
  }
  tot / 12
}

predictResult <- function(team1, team2, map, model) {
  d <- getTeamAvg(team1) - getTeamAvg(team2)
  d$map <- map
  predict(model, d, type="response")
}

getOVOResult <- function(p1, p2, pred, p1Name, p2Name) {
  if (is.null(p1) | is.null(p2)) { return() }
  rp <- round(pred*100, 2)
  if (pred < 0.5) {
    winner <- p1Name
    scrub <- p2Name
    rp <- 100 - rp
  } else if (pred > 0.5) {
    winner <- p2Name
    scrub <- p1Name
  } else { return("WTF ... netcode!? You kill trade!") }
  getWinMSG(winner, scrub, rp)
}

getWinMSG <- function(winner, loser, confidence) {
  msgs <- c(
    paste0(loser, " was boned by ", winner, ".... no lube and ", confidence, "% hard"),
    paste0(loser, " is such a scrub... ", winner, " is MLG PRO! I'm ", 
           confidence, "% certain"),
    paste0(loser, " is ", confidence, "% lady and ", winner, " is taking dat ass"),
    paste0(round(confidence), " out of 100 DICE employees agree, ", loser, 
           " gets rekt by ", winner),
    paste0(winner, " quenched the thirst of ", round(confidence), " African children",
           " with the tears of ", loser),
    paste0(loser, " calls the whaaambulance ", confidence, "% percent of the time while ",
           winner, " eats a carrot."),
    paste0("Maybe if ", loser, " spent ", confidence, "% less time playing, ",
           "'just for fun' they could avoid getting wrecked by ", winner),
    paste0(round(confidence), " alzheimers patients remembered how bad ", loser, 
           " is after that crushing defeat from ", winner),
    paste0("Getting dragged through ", round(confidence), "m of fire is less painful",
           " than the beatdown ", winner, " gave ", loser),
    paste0(round(confidence), " atheists turned to religion after ", winner, "'s ",
           "godly performance when beating ", loser),
    paste0(loser, " is like Leonardo DiCrapio in Titanic, while ", winner, 
           " swims away and marries a $", round(confidence), "million richman"),
    paste0("According to Wikipedia ", loser, " died at the majestic hands of ", winner,
           "... a total of ", round(confidence), " sources agree"),
    paste0(loser, " is hearing ", round(confidence), 
           " fat ladies sing because he got owned by ", winner),
    paste0(loser, " changed sexes after being worked over by ", winner),
    paste0("Mommy told ", loser, " there is a ", confidence, "% chance ",
           winner, " is his daddy"),
    paste0("There is a ", confidence, "% chance ", loser, " is pregnant after ", 
           winner, " was done with them"),
    paste0("The results are in: God favours ", winner, " ", confidence, "% more than ",
           loser),
    paste0(loser, "'s tight end got loosened by ", confidence, "% after ", winner, 
           " got done with them"),
    paste0(confidence, "% of lesbians said they would gladly chow down on ",
           loser, "'s box after that extremely feminine display against ", winner),
    paste0("There's a ", confidence, "% chance ", loser, "'s girlfriend will cheat ",
           "after witnessing ", winner, "'s glorious performance"),
    paste0("There is a ", confidence, "% chance ", loser, " is the taker and ", 
           winner, " is the giver"),
    paste0(loser, "'s life insurance fee just increased by ", confidence, "% after ", 
           winner, " exposed how much ", loser, " is prone to disaster"),
    paste0("Someone call an ambulance because ", winner, " just put ", 
           round(confidence), " bullets into ", loser, "'s chest")
  )
  sample(msgs, 1)
}
