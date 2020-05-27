library(lubridate)
library(dplyr)
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
# convert date and time to class Date and POXITct
data <- mutate(data, Date = dmy(Date), Time = hms(Time))

# Plot 1
png(filename = "plot1.png", width = 480, height = 480, units = 'px')
with(data, hist(Global_active_power, col = 'red', 
                main = "Global Active Power", 
                xlab = "Global Active Power (kilowatts)",
                ylab = 'frequency'))
dev.off()