file_user <- file.choose()
data = read.csv(file_user, skip=6)
dataMax = aggregate(x = data$ticks, by = list(data$X.run.number., data$foraging_strategies, data$blob_count, data$food_amount, data$population), max)
names(dataMax)[1] ="X.run.number."
names(dataMax)[2] ="foraging_strategies"
names(dataMax)[3] ="blob_count"
names(dataMax)[4] ="food_amount"
names(dataMax)[5] ="population"
names(dataMax)[6] ="ticks"
data <- dataMax
write.csv(data, file.path(dirname(file_user), "ants tandem carrying.csv"))
