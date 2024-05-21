source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
load(infile1)
coordinate <- as.matrix(read.table(infile2))

# Filitering
target <- intersect(intersect(intersect(
	which(coordinate[,1] >= -5),
	which(coordinate[,1] <= -1.5)),
	which(coordinate[,2] >= -6.8)),
	which(coordinate[,2] <= 2.5))
label <- rep(0, length=nrow(coordinate))
label[target] <- 1

# Save
write.table(label, outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)