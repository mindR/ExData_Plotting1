library(dplyr)

#loading data into R

Hdata <- read.csv(unzip("exdata-data-household_power_consumption.zip","household_power_consumption.txt"),sep = ";", na.strings = "?")

#filtering data based on date and mutating date column
Adata <- Hdata %>% mutate(Date = as.Date(as.character(Date), "%d/%m/%Y")) %>%
  filter(Date >= '2007-02-01' & Date <= '2007-02-02')

#formatting time column
Adata$Time <- format(strptime(as.character(Adata$Time), format = "%H:%M:%S"), "%H:%M:%S")

#adding a datetime column
Adata$datetime <- as.POSIXct(paste(Adata$Date,Adata$Time), format = "%Y-%m-%d %H:%M:%S")


with(Adata, plot(datetime,Global_active_power, "l", xlab = "Date & Time", ylab = "Global Active Power (kilowatts)"))

