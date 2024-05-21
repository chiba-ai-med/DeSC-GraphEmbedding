source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
A <- as.matrix(read.table(infile))
A <- log10(A + 1)

# Embedding
out <- eigen(A)

# UMAP
out2 <- umap(out$vectors[, seq(min(20, nrow(A)))])$layout

# Save
save(out, file=outfile1)
write.table(out2, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)