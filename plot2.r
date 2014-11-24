
# Question 2:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == 24510) from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.


# Read the data file
## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
    NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
    SCC <- readRDS("Source_Classification_Code.rds")
}

BaltimoreCityData <- subset(NEI, fips == "24510")

TotalByYear_Sum <- tapply(BaltimoreCityData$Emissions, BaltimoreCityData$year, sum)

png("plot2.png")
plot(names(TotalByYear_Sum), TotalByYear_Sum, type="l",
     xlab="Year", ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
     main=expression("Total Baltimore City" ~ PM[2.5] ~ "Emissions by Year"))
dev.off()
