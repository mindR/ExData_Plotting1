library(dplyr)
library(reshape2)

#loading data into R

Hdata <- read.csv(unzip("exdata-data-household_power_consumption.zip","household_power_consumption.txt"),sep = ";", na.strings = "?")

#filtering data based on date and mutating date column
Adata <- Hdata %>% mutate(Date = as.Date(as.character(Date), "%d/%m/%Y")) %>%
  filter(Date >= '2007-02-01' & Date <= '2007-02-02')

#formatting time column
Adata$Time <- format(strptime(as.character(Adata$Time), format = "%H:%M:%S"), "%H:%M:%S")

#adding a datetime column
Adata$datetime <- as.POSIXct(paste(Adata$Date,Adata$Time), format = "%Y-%m-%d %H:%M:%S")


#reshaping the table to get a single Submetering column

Cdata <- Adata[c("Sub_metering_1","Sub_metering_2","Sub_metering_3","datetime")]
Ddata <- melt(Cdata, id=c("datetime"))

#creating base plot using annotation

with(Ddata,plot(datetime, value, type="n", ylab = "Energy sub metering", xlab = "Date & Time"))
with(subset(Ddata,variable=="Sub_metering_1"),lines(datetime,value))
with(subset(Ddata,variable=="Sub_metering_2"),lines(datetime,value, col="red"))
with(subset(Ddata,variable=="Sub_metering_3"),lines(datetime,value, col="blue"))

#adding the legend
legend("topright", lwd=1,col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

