options(warn=-1)

if (!require('data.table')) {
    stop('The package data.table is required. Please install it and try again')
}

options(warn=-0)

#Checks if the file txt exists or not and if not exists downloads it from the url in coursera
if (!file.exists("household_power_consumption.txt")){
    #Downloads file project.zip from the coursera project web site.
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,destfile="exdata_project.zip",method="curl")
    unzip(zipfile="exdata_project.zip")
}
#Set english language default
Sys.setlocale("LC_ALL","C")
#Read table downloaded from coursera project web site
hpc_origin<-read.table("household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?", stringsAsFactors = FALSE)
#Filter by date 01/02/2007 and 02/02/2007
hpc<-hpc_origin[(hpc_origin$Date=="1/2/2007") | (hpc_origin$Date=="2/2/2007"),]
#Generate a datetime dimension for the graph
hpc$dtime <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")
#Generate first graph and export in in png device with transparent backround like the version in prof. Peng github repository.
#The transparent version is the best solution for the inclusion of the object in different contexts : from presentations to websites
png("plot4.png", width = 480, height = 480, units = 'px', bg="transparent")
par(mfrow = c(2, 2))
# 1
plot(hpc$dtime, hpc$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
# 2
plot(hpc$dtime, hpc$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
# 3
plot(hpc$dtime, hpc$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", col = "black")
points(hpc$dtime, hpc$Sub_metering_2, type = "l", xlab = "", ylab = "Sub_metering_2", col = "red")
points(hpc$dtime, hpc$Sub_metering_3, type = "l", xlab = "", ylab = "Sub_metering_3", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", )
# 4
plot(hpc$dtime, hpc$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", ylim = c(0, 0.5))
dev.off()
