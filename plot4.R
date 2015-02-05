if(!file.exists("household_power_consumption.txt")) {
      download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip", method = "curl")
      unzip("household_power_consumption.zip")
}
if(!exists("hpc_sub")) {
      hpc <- read.table("household_power_consumption.txt", sep = ";", col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), stringsAsFactors = FALSE)
      hpc$Time <- strptime(paste(hpc$Date, hpc$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
      hpc <- hpc[,2:9]
      hpc_sub <- subset(hpc, format(Time, "%Y-%m-%d") %in% c("2007-02-01", "2007-02-02"))
      rm(hpc)
      for(i in 2:8){hpc_sub[,i]<-as.numeric(hpc_sub[,i])}
      hpc_sub <- cbind("Date_time" = hpc_sub[,1], hpc_sub[,2:8])
}


#plot4
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))

with(hpc_sub, {
      #graph1
      with(hpc_sub, plot(Date_time, Global_active_power, type = "n", xlab = "", ylab = "Global active power (kilowatts)"))
      lines(hpc_sub$Date_time, hpc_sub$Global_active_power)
      #graph2
      with(hpc_sub, plot(Date_time, Voltage, type = "n", xlab = "datetime", ylab = "Voltage"))
      lines(hpc_sub$Date_time, hpc_sub$Voltage)
      #graph3
      with(hpc_sub, plot(Date_time, Sub_metering_1, type = "n", xlab = "", ylab = "Energy hpc_sub metering"))
      lines(hpc_sub$Date_time, hpc_sub$Sub_metering_1)
      lines(hpc_sub$Date_time, hpc_sub$Sub_metering_2, col = "red")
      lines(hpc_sub$Date_time, hpc_sub$Sub_metering_3, col = "blue")
      legend("topright", col = c("black", "red", "blue"), lty = c("solid", "solid", "solid"), legend = names(hpc_sub[,6:8]), xjust = 1, yjust = 0.5)
      #graph4
      with(hpc_sub, plot(Date_time, Global_reactive_power, type = "n", xlab = "datetime"))
      lines(hpc_sub$Date_time, hpc_sub$Global_reactive_power)
})

dev.off()
par(mfrow = c(1,1))
