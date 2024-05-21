source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
A <- as.matrix(read.table(infile))
A <- log10(A + 1)

# Semi-Binary Matrix Tri-Factorizatoin
out <- SMTF(A, J=2, num.iter=200)

# Save
tmp <- NA
save(tmp, file=outfile1)
write.table(out$U, outfile2, quote=FALSE, row.names=FALSE, col.names=FALSE)