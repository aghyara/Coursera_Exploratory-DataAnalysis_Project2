# Question 5:
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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

# Assumumption Consider only road for motor vehicles
BaltimoreCity_MVeh <- subset(NEI, fips == "24510" & type=="ON-ROAD")

BaltimoreCityMVeh_ByYear <- ddply(BaltimoreCity_MVeh, .(year), function(x) sum(x$Emissions))
colnames(BaltimoreCityMVeh_ByYear)[2] <- "Emissions"

png("plot5.png")
qplot(year, Emissions, data=BaltimoreCityMVeh_ByYear, geom="line") +
    ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) +
    xlab("Year") +
    ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()
