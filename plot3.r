# Question 3:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

library(plyr)
library(ggplot2)

# Read the data file
## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
    NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
    SCC <- readRDS("Source_Classification_Code.rds")
}

BaltimoreCityData <- subset(NEI, fips == "24510")

TotalByYear_Sum <- ddply(BaltimoreCityData, .(year, type), function(x) sum(x$Emissions))
colnames(TotalByYear_Sum)[3] <- "Emissions"

png("plot3.png")
qplot(year, Emissions, data=TotalByYear_Sum, color=type, geom="line") +
    ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Emissions by Source Type and Year")) +
    xlab("Year") +
    ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))

dev.off()