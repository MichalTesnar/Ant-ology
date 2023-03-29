library(ggplot2)
library(viridis)
data = read.csv(file.choose(), skip=6)
meanData = aggregate(data$ticks, list(data$food_amount, data$blob_count), mean)
names(meanData)[3] <- "Ticks"
ggplot(meanData, aes(x=Group.1, y=Group.2, fill = Ticks)) + 
  geom_tile() + xlab("Amount of food") + ylab("Number of blobs") +
  scale_fill_viridis_c()
