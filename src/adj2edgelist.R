source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))

# Pre-processing
rownames(A) <- seq(nrow(A))
colnames(A) <- seq(ncol(A))
edgelist <- melt(A)
edgelist <- edgelist[which(edgelist$value != 0), ]
edgelist <- edgelist[, 1:2]

# Save
write.table(edgelist, file=outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)