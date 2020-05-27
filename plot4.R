library(dplyr)
library(lubridate)
path = "./exdata_data_household_power_consumption/household_power_consumption.txt"

# calculate number of rows needed to skip
first_row <- dmy_hms("16/12/2006 17:24:00")
start <- ymd_hms("2007-02-01 00:00:00")
stop <- ymd_hms("2007-02-02 23:59:00")
skip_row <- as.numeric(difftime(start, first_row, units = 'mins')) + 1
nrow <- as.numeric(difftime(stop, start, units = 'mins')) + 1
colname <- c('Date', 'Time', 'Global_active_power', 'Global_reactive_power', 
             'Voltage', 'Global_intensity', 'Sub_metering_1', 
             'Sub_metering_2', 'Sub_metering_3')
colclass <- c('character', 'character', 'numeric', 'numeric', 'numeric',
              'numeric', 'numeric', 'numeric', 'numeric')

# load the data
data <- read.table(path, skip = skip_row, nrows = nrow,
                   sep = ";", header = FALSE,
                   colClasses = colclass, na.strings = "?",
                   col.names = colname)

# generate DateTime column
# convert date and time to class Date and POXITct
data <- mutate(data, DateTime = dmy_hms(paste(Date, Time)))

# Plot 4
png(filename = "plot4.png", width = 480, height = 480, units = 'px')
par(mfcol = c(2,2))

# plot 2 at upperleft 
with(data, plot(DateTime, Global_active_power, type = 'l', 
                ylab = "Global Active Power (kilowatts)"), xlab = 'datetime')

# plot 3 at lowerleft
with(data, plot(DateTime, Sub_metering_1, type = 'l', col = 'black', 
                ylab = 'Energy sub metering'), xlab = "datetime")
points(data$DateTime, data$Sub_metering_2, type = 'l', col = 'red')
points(data$DateTime, data$Sub_metering_3, type = 'l', col = 'blue')
legend("topright", lwd = 2, seg.len = 3, col = c('black', 'red', 'blue'), 
       legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       border = 'white')

# plot Voltage-DateTime at upperright
with(data, plot(DateTime, Voltage, type = 'l', 
                ylab = "Voltage", xlab = "datetime"))

# plot Global_reactive_power-DateTime at upperright
with(data, plot(DateTime, Global_reactive_power, type = 'l', 
                ylab = "Global_reactive_power", xlab = "datetime"))

dev.off()