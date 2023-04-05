library(ggplot2)
library(viridis)
path = "/Users/wojtek/Library/Mobile Documents/com~apple~CloudDocs/Documents/ATP/Final Project/Ant-ology/final data"

solitary = read.csv(paste(path,"/Ants solitary foraging-table.csv", sep = ""), skip=6)
data = read.csv(file.choose(), skip=6)
meanData = aggregate(data$ticks, list(data$food_amount, data$blob_count), mean)
meanSol = aggregate(solitary$ticks, list(solitary$food_amount, solitary$blob_count), mean)

newData <- meanData
newData[3] <- meanData[3] - meanSol[3]
names(newData)[3] <- "Ticks"
ggplot(newData, aes(x=Group.1, y=Group.2, fill = Ticks)) + 
  geom_tile() + xlab("Amount of food") + ylab("Number of blobs") +
  scale_fill_viridis_c()