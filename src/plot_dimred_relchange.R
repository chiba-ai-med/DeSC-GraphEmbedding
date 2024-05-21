source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
load(infile)

if(length(grep("smtf", infile)) && length(grep("umap", infile))){
	png(file=outfile, width=750, height=750)
	plot(out$RelChange, type="b")
	dev.off()
}else{
	file.create(outfile, showWarnings=TRUE)
}