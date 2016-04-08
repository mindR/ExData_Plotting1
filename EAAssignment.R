library(dplyr)
#unable to extract using filter as the columns are in factor format

Hdata <- read.csv(unzip("exdata-data-household_power_consumption.zip","household_power_consumption.txt"),sep = ";", na.strings = "?")

Adata <- Hdata %>% mutate(Date = as.Date(as.character(Date), "%d/%m/%Y")) %>%
  filter(Date >= '2007-02-01' & Date <= '2007-02-02')

Adata$Time <- format(strptime(as.character(Adata$Time), format = "%H:%M:%S"), "%H:%M:%S")

#add a datetime column

Bdata$datetime <- as.POSIXct(paste(Adata$Date,Adata$Time), format = "%Y-%m-%d %H:%M:%S")

#plot 1


hist(Bdata$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")


#plot 2


with(Bdata, plot(datetime,Global_active_power, "l", xlab = "Date & Time", ylab = "Global Active Power (kilowatts)"))

#plot 3

library(reshape2)

#reshaping the table to get a single Submetering column

Cdata <- Bdata[c("Sub_metering_1","Sub_metering_2","Sub_metering_3","datetime")]
Ddata <- melt(Cdata, id=c("datetime"))

#creating base plot using annotation

with(Ddata,plot(datetime, value, type="n", ylab = "Energy sub metering", xlab = "Date & Time"))
with(subset(Ddata,variable=="Sub_metering_1"),lines(datetime,value))
with(subset(Ddata,variable=="Sub_metering_2"),lines(datetime,value, col="red"))
with(subset(Ddata,variable=="Sub_metering_3"),lines(datetime,value, col="blue"))

legend("topright", lwd=1,col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#plot 4


par(mfcol=c(2,2))
par(mar=c(2,2,2,2))

#plot1
with(Bdata, plot(datetime,Global_active_power, "l", xlab = "Date & Time", ylab = "Global Active Power (kilowatts)"))

#plot2
with(Ddata,plot(datetime, value, type="n", ylab = "Energy sub metering", xlab = "Date & Time"))
with(subset(Ddata,variable=="Sub_metering_1"),lines(datetime,value))
with(subset(Ddata,variable=="Sub_metering_2"),lines(datetime,value, col="red"))
with(subset(Ddata,variable=="Sub_metering_3"),lines(datetime,value, col="blue"))

legend("topright", lwd=1,col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#plot3
with(Bdata, plot(datetime,Voltage, "l", xlab = "Date & Time", ylab = "Voltage"))

#plot4
with(Bdata, plot(datetime,Global_reactive_power, "l", xlab = "Date & Time", ylab = "Global reactive power"))
