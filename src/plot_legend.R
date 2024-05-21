source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]

# Plot
png(file=outfile, width=1600, height=890)
plot.new()
legend("topleft", legend=diseasevec, col=colvec, pch=16, cex=2)
dev.off()
