source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
A <- as.matrix(read.table(infile))
A <- log10(A + 1)

# Graph Laplacian
D1 <- diag(rowSums(A))
D2 <- diag(1/sqrt(rowSums(A)))
L <- D2 %*% (D1 - A) %*% D2

# Embedding
out <- eigen(L)

# Save
tmp <- NA
save(tmp, file=outfile1)
write.table(out$vectors[, (ncol(A)-1):(ncol(A)-2)], outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)