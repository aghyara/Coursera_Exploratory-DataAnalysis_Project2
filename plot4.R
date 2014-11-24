# Question 4:
# Across the United States, how have emissions from 
# coal combustion-related sources changed from 1999-2008?

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

# source codes corresponding to coal combustion

CoalCombustion_SCC <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Institutional - Coal",
                                                  "Fuel Comb - Electric Generation - Coal",
                                                  "Fuel Comb - Industrial Boilers, ICEs - Coal"))
# Compare to Short.Name matching both Comb and Coal
CoalCombustion_SCCSubset <- subset(SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))

# Diffset1 <- setdiff(CoalCombustion_SCC$SCC, CoalCombustion_SCCSubset$SCC)
# Diffset2 <- setdiff(CoalCombustion_SCCSubset$SCC, CoalCombustion_SCC$SCC)
# length(Diffset1)
# length(Diffset2)

# union the two sets
CoalCombustion_SCCCodes <- union(CoalCombustion_SCC$SCC, CoalCombustion_SCCSubset$SCC)
#length(CoalCombustion_SCCCodes)

CoalCombustion_Subset <- subset(NEI, SCC %in% CoalCombustion_SCCCodes)

CoalCombustion_ByYear <- ddply(CoalCombustion_Subset, .(year, type), function(x) sum(x$Emissions))
colnames(CoalCombustion_ByYear)[3] <- "Emissions"

png("plot4.png")
qplot(year, Emissions, data=CoalCombustion_ByYear, color=type, geom="line") +
    stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", 
                 color = "black", aes(shape="total"), geom="line") +
    geom_line(aes(size="total", shape = NA)) +
    ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) +
    xlab("Year") +
    ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()
