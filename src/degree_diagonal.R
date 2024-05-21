source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
d1 <- unlist(read.table(infile1, header=FALSE))
d2 <- unlist(read.table(infile2, header=FALSE))

# Degree
d <- log10(d1 + 1) - log10(d2 + 1)

# Save
write.table(d, outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)