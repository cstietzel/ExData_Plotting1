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

## Set up png device
png("plot2.png", width=480, height=480, type="quartz")

## Plot Global Active Power as function of time
plot(pwrdata$dateTime, pwrdata$Global_active_power, type="l",
     xlab="", ylab="Global Active Power (kilowatts)",
     main="")

## Close device
dev.off()