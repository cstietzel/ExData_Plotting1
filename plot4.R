## load packages
library(tidyverse)

## set to location and file name of the power consumption data
pwrdatafile <- "../household_power_consumption.txt"

## Setup row filter on file based on regex
datafilter <- paste ("grep -e \"^[1-2]/2/2007\\|^Date\"", pwrdatafile)

## Load file data
pwrdata<-read_delim(pipe(datafilter), ";", na = "?",
                    col_types = 
                        cols(
                            Date = col_date(format = "%d/%m/%Y"),
                            Time = col_time(format = ""),
                            Global_active_power = col_double(),
                            Global_reactive_power = col_double(),
                            Voltage = col_double(),
                            Global_intensity = col_double(),
                            Sub_metering_1 = col_double(),
                            Sub_metering_2 = col_double(),
                            Sub_metering_3 = col_double()
                        )) %>%
    mutate(dateTime = as.POSIXct(paste(pwrdata$Date, pwrdata$Time)))

## Set up multiple plots for 2 charts in 2 columns
## Set up png device
png("plot4.png", width=480, height=480, type="quartz")
par(mfcol = c(2,2))

## Plot for Col 1 Row 1
## Plot Global Active Power as function of time
plot(pwrdata$dateTime, pwrdata$Global_active_power, type="l",
     xlab="", ylab="Global Active Power",
     main="")

## Plot for Col 1 Row 2
## Submeter readingds as function of time
plot(pwrdata$dateTime, pwrdata$Sub_metering_1, type="l", col = "black",
     xlab="", ylab="Energy sub metering", main="")

## Add Sub meter 2 series
points(pwrdata$dateTime, pwrdata$Sub_metering_2, type="l", col = "red")

## Add Sub meter 3 series
points(pwrdata$dateTime, pwrdata$Sub_metering_3, type="l", col = "blue")

## Add legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
      col = c("black", "red", "blue"), lty = c(1, 1, 1), bty = "n")

## Plot for Col 2 Row 1
## Voltage as function of time
plot(pwrdata$dateTime, pwrdata$Voltage, type="l",
     xlab="datetime", ylab="Voltage",
     main="")

## Plot for Col 2 Row 2
## Global_reactive_power as function of time
plot(pwrdata$dateTime, pwrdata$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global_reactive_power",
     main="")

## Close device
dev.off()