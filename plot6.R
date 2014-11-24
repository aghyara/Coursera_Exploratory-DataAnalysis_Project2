# Question 6:
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?

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
MVehicle <- subset(NEI, (fips == "24510" | fips == "06037") & type=="ON-ROAD")

MVehicle <- transform(MVehicle,
                region = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

MVeh_PM25ByYearAndRegion <- ddply(MVehicle, .(year, region), function(x) sum(x$Emissions))

colnames(MVeh_PM25ByYearAndRegion)[3] <- "Emissions"

# Generate plot normalized to 1999 levels showing changes over time
Balt1999_Emissions <- subset(MVeh_PM25ByYearAndRegion,
                            year == 1999 & region == "Baltimore City")$Emissions
LAC_1999Emissions <- subset(MVeh_PM25ByYearAndRegion,
                           year == 1999 & region == "Los Angeles County")$Emissions
MVeh_PM25ByYearAndRegionT <- transform(MVeh_PM25ByYearAndRegion,
                                       EmissionsNorm = ifelse(region == "Baltimore City",
                                                              Emissions / Balt1999_Emissions,
                                                              Emissions / LAC_1999Emissions))

png("plot6.png", width=600)
qplot(year, EmissionsNorm, data=MVeh_PM25ByYearAndRegionT, geom="line", color=region) +
    ggtitle(expression("Total" ~ PM[2.5] ~
                           "Motor Vehicle Emissions Normalized to 1999 Levels")) +
    xlab("Year") +
    ylab(expression("Normalized" ~ PM[2.5] ~ "Emissions"))
dev.off()
