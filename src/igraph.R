source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))

# iGraph Object
g <- graph_from_adjacency_matrix(log10(A+1),
	mode="undirected", weighted=TRUE, diag=FALSE)

# Node Color（ICD-10）
V(g)$color <- label2color(rownames(A))

# Save
save(g, file=outfile)