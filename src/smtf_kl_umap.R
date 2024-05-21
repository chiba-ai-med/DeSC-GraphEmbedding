source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
A <- as.matrix(read.table(infile))

# Semi-Binary Matrix Tri-Factorizatoin
out <- SMTF(A, J=min(20, nrow(A)), num.iter=200, Beta=1)

# UMAP
out2 <- umap(out$U)$layout

# Save
save(out, file=outfile1)
write.table(out2, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)