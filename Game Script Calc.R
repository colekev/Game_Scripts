library(ggplot2)
library(dplyr)
library(readr)
library(data.table)

# Read in Armchair Analysis PLAY and GAME data
play <- read_csv(file = "~/Desktop/AA/aa_2000_2015/csv/PLAY.csv")
game <- read_csv(file = "~/Desktop/AA/aa_2000_2015/csv/GAME.csv")

# Calculate 2015 game scripts

gs15 <- play %>%
    #join PBP data with game data and filter for 2015
    left_join(game, by="gid") %>%
    filter(seas == 2015) %>%
    # calculate weighting of score diff based on length of drives for off & def
    mutate(gs_off = (len * (ptso - ptsd)), gs_def = (len * (ptsd - ptso))) %>%
    group_by(gid, off, def) %>%
    # drive lengths in seconds, scale the score differentials by 60 minute game and 60 seconds
    summarise(gs_off = sum(gs_off)/(60*60), gs_def = sum(gs_def)/(60*60)) %>%
    ungroup()

# Separate defense away and rename defense to generic name "team"
gs15_def <- gs15 %>%
    select(gid, def, gs_def) %>%
    setnames(c("def", "gs_def"), c("team", "gs")) %>%
    mutate(o_d = "def")

# Rename offense to generic "team", then rbind defense to offense and sum game scripts
gs15 <- gs15 %>%
    select(gid, off, gs_off) %>%
    setnames(c("off", "gs_off"), c("team", "gs")) %>%
    mutate(o_d = "off") %>%
    rbind(gs15_def) %>%
    group_by(gid, team) %>%
    summarise(gs = round(sum(gs), 1))

# Add game info for week number
gs15 <- game %>%
    select(gid, seas, wk) %>%
    left_join(gs15, by = "gid")

# Calculate pass ratios
pRatio <- play %>%
    filter(type %in% c("PASS", "RUSH")) %>%
    mutate(pRatio = ifelse(type == "PASS", 1, 0)) %>%
    group_by(gid, off) %>%
    summarise(pRatio = round(mean(pRatio), 2)) %>%
    setnames("off", "team")

#Merge pass ratio into game scripts
gs15 <- gs15 %>%
    merge(pRatio, by = c("gid", "team")) %>%
    select(gid, seas, wk, team, gs, pRatio)

# Calculate regression estimates and differences

gs_loess <- loess(pRatio ~ gs, data = gs15)

gs15$est <-round(predict(gs_loess, newdata=gs15), 2)

gs15 <- mutate(gs15, diff = pRatio - est)

# Calculate team per-gm gamescript and pass ratio if you want to do seasonal analysis
gs15_team <- gs15 %>%
    group_by(team) %>%
    summarise(gs = round(mean(gs), 1), pRatio = round(mean(pRatio), 2), 
              est = round(mean(est), 2), diff = round(mean(diff), 2)) 

# Highlight particular team, in this case NE
NE <- filter(gs15, team == "NE")

# Plot team, patriots in this case
gs_teamPlot <- ggplot(gs15, aes(gs, pRatio, label = team))

gs_teamPlot + fte_theme() +
    geom_text(data = NE, size = 3) + 
    geom_smooth(data = gs15) + 
    geom_point(data = gs15, alpha = 0.1, color = "blue") +
    labs(title = "Patriots Game Script (2015)", x = "Game Script", 
         y = "Pass Ratio")

# Save plot    
ggsave("gs_2015_NE.png", dpi=1000, width=6, height=3)


    
