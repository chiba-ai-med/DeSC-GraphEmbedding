source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
if(length(grep("", infile)) == 1){
	data <- as.matrix(read.table(infile, skip=1, header=FALSE, row.names=1))
}else{
	data <- as.matrix(read.table(infile))
}

# UMAP
out <- umap(data)$layout

# Save
write.table(out, outfile, quote=FALSE, row.names=FALSE, col.names=FALSE)