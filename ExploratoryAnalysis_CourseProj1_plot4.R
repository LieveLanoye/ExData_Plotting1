#########################################################
################### creating plot 1 #####################
#########################################################

## ------------------------------------------------------
## Download and unzip source dataset 
## ------------------------------------------------------

data.source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data.file <- "PowerConsumption.zip"

if (!file.exists(data.file)) {
  download.file(data.source, data.file, mode="wb")
}
unzip(data.file)

col.names <- c("Date", "Time", "GlobalActivePower", "GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMeter1", "SubMeter2", "SubMeter3")

#Data starts on 16/12/2006 at 17:29, data needed is 01/02/2007 at 00:00, so first 66637 lines are non-relevant, and we need 2881 (2*24*60+1) lines
data <- read.table("household_power_consumption.txt", sep=";", col.names = col.names, na.strings = "?", as.is=TRUE, skip = 66637, nrows = 2881)

#some sanity checks
summary(data)
colSums(is.na(data))

class(data$Sun)

## ------------------------------------------------------
## Deal with dates
## ------------------------------------------------------

DateTime_pre = paste(data$Date, data$Time)
library(lubridate)
DateTime <- dmy_hms(DateTime_pre)
data <-cbind(DateTime, data)

## ------------------------------------------------------
## Create and export plot 4
## ------------------------------------------------------
dev.off()  #to clear the pallet
par(mfrow = c(2,2), mar = c(4,4,2,1))
  plot(data$DateTime, data$GlobalActivePower, ylab = "Global Active Power (kilowatts)", type = "l")

  plot(data$DateTime, data$Voltage, ylab = "Voltage", xlab = "datetime", type = "l")

  with(data, plot(data$DateTime, data$SubMeter1, type = "l", col = "black"), type = "n") #empty plot
  lines(data$DateTime, data$SubMeter2, col = "red")
  lines(data$DateTime, data$SubMeter3, col = "blue")
  legend("topright", lty = 1, lwd = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

  plot(data$DateTime, data$GlobalReactivePower, ylab = "Global_reactive_power", xlab = "datetime", type = "l")

dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()
