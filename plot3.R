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
dt[, Sub_metering_1:=as.double(Sub_metering_1)] # we need it numeric
dt[, Sub_metering_2:=as.double(Sub_metering_2)] # we need it numeric
dt[, Sub_metering_3:=as.double(Sub_metering_3)] # we need it numeric
dt[,timestamp:=as.POSIXct(strptime(paste(dt$Date, dt$Time), format="%d/%m/%Y %H:%M:%S"))] # convert dtae and time to timestamp

par(mfrow=c(1,1))
plot(dt$timestamp, dt$Sub_metering_1, type="n", ylab = "Energy sub metering", xlab="") # draw enpty canvas
# Plot lines
lines(dt$timestamp, dt$Sub_metering_1)
lines(dt$timestamp, dt$Sub_metering_2, col="red")
lines(dt$timestamp, dt$Sub_metering_3, col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c("black", "red", "blue"), cex=0.9)
dev.copy(device = png, filename = "plot3.png", width=480, height=480) # copy plot to png
dev.off() #close graphic device

