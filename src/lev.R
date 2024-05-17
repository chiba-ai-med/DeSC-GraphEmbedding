source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
A <- as.matrix(read.table(infile))
A[which(is.na(A))] <- 0
A <- log10(A + 1)

# Modularity Matrix
d <- rowSums(A) / 2
Q <- A - ((d %*% t(d)) / sum(A))

# Embedding
out <- eigen(Q)

# Save
tmp <- NA
save(tmp, file=outfile1)
write.table(out$vectors[, (ncol(A)-1):(ncol(A)-2)], outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)