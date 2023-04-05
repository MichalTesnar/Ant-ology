path = "/Users/wojtek/Library/Mobile Documents/com~apple~CloudDocs/Documents/ATP/Final Project/Ant-ology"

solitary = read.csv(paste(path,"/Ants solitary foraging-table.csv", sep = ""), skip=6)
carrying = read.csv(paste(path,"/Ants tandem carrying-table.csv", sep = ""), skip=6)
bomb = read.csv(paste(path,"/Ants pheromone bomb-table.csv", sep = ""), skip=6)
trail = read.csv(paste(path,"/Ants pheromone trails-table.csv", sep = ""), skip=6)
chain = read.csv(paste(path,"/Ants prey chain transfer-table.csv", sep = ""), skip=6)

solitary <- with(solitary, aggregate(ticks, list(food_amount, blob_count), mean))
carrying <- with(carrying, aggregate(ticks, list(food_amount, blob_count), mean))
bomb <- with(bomb, aggregate(ticks, list(food_amount, blob_count), mean))
trail <- with(trail, aggregate(ticks, list(food_amount, blob_count), mean))
chain <- with(chain, aggregate(ticks, list(food_amount, blob_count), mean))

library('tidyverse')
# using add_column()
solitary <- solitary %>%
  add_column(type = "solitary")
carrying <- carrying %>%
  add_column(type = "tandem")
bomb <- bomb %>%
  add_column(type = "bomb")
trail <- trail %>%
  add_column(type = "trail")
chain <- chain %>%
  add_column(type = "chain")

library(dplyr)
together <- rbind(solitary, carrying, bomb, trail, chain)
best <- together %>% group_by(Group.1, Group.2) %>% slice_min(x)

library(ggplot2)
library(viridis)
ggplot(best, aes(x=Group.1, y=Group.2, fill = type)) + 
  geom_tile() + xlab("Amount of food") + ylab("Number of blobs") +
  scale_fill_viridis(discrete=TRUE)