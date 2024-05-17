source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))
A[which(is.na(A))] <- 0
diag(A) <- 0

# Degree
d <- colSums(A)

# Save
write.table(d, outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)