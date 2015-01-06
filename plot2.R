library("data.table") # data table works fast
# I expect raw data file to be already in the working directory
# load and unzip it if it is not
if (!file.exists("household_power_consumption.txt")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  destfile = "household_power_consumption.zip",
                  method = "curl",
                  quite = TRUE
                  )
    unzip(zipfile = "household_power_consumption.zip")
}
dt <- fread("household_power_consumption.txt",na.strings = c("",'?')) # we need to convert ? to NA but due to bug in fread it is done AFTER numerics has been bumped to characters
dt <- dt[dt$Date=="1/2/2007"|dt$Date=="2/2/2007",] # subset to the two days
dt[, Global_active_power:=as.double(Global_active_power)] # we need it numeric
dt[,timestamp:=as.POSIXct(strptime(paste(dt$Date, dt$Time), format="%d/%m/%Y %H:%M:%S"))] # convert dtae and time to timestamp
plot(dt$timestamp, dt$Global_active_power, type="n", ylab = "Global Active Power (kilowatts)", xlab="") # draw enpty canvas
lines(dt$timestamp, dt$Global_active_power) #plot lone
dev.copy(device = png, filename = "plot2.png", width=480, height=480) # copy plot to png
dev.off() #close graphic device

