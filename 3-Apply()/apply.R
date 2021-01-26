setwd("D:\\İnR\\R-Exercises\\3-Apply()\\P3-Weather-Data\\Weather Data")
getwd()
chicago <- read.csv("Chicago-F.csv", row.names = 1)
houston <- read.csv("Houston-F.csv", row.names = 1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names = 1)
NewYork <- read.csv("NewYork-F.csv", row.names = 1)
chicago
is.data.frame(chicago)
chicago <- as.matrix(chicago)
houston <- as.matrix(houston)
SanFrancisco <- as.matrix(SanFrancisco)
NewYork <- as.matrix(NewYork)

weather <- list(chicago,NewYork,SanFrancisco,houston)
names(weather) <- c("chicago", "New York", "San Francisco" , "Houston")
weather
