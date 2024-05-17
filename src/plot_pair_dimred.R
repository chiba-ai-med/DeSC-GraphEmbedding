source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile1 <- args[4]
outfile2 <- args[5]

# Load
load(infile1)
load(infile2)
d <- unlist(read.table(infile3, header=FALSE))

# Plot
if(length(grep("umap", infile1)) == 0){
	file.create(outfile1, showWarnings=TRUE)
	file.create(outfile2, showWarnings=TRUE)
}else{
	if(length(grep("small", infile1))){
		if(length(grep("lem|lev|evd", infile1))){
			png(file=outfile1, width=3000, height=3000)
			pairs(out$vectors[, seq(min(ncol(out$vectors), 20))], col=V(g)$color, pch=16)
			dev.off()

			png(file=outfile2, width=3000, height=3000)
			pairs(out$vectors[, seq(min(ncol(out$vectors), 20))], col=smoothPalette(-log10(d+1), pal="RdBu"),
				pch=16)
			dev.off()
		}else{
			png(file=outfile1, width=1000, height=1000)
			pairs(out$U, col=V(g)$color, pch=16)
			dev.off()

			png(file=outfile2, width=1000, height=1000)
			pairs(out$U, col=smoothPalette(-log10(d+1), pal="RdBu"),
				pch=16)
			dev.off()
		}
	}else{
		if(length(grep("lem|lev|evd", infile1))){
			png(file=outfile1, width=1000, height=1000)
			pairs(out$vectors[, seq(min(ncol(out$vectors), 20))], col=V(g)$color, pch=16)
			dev.off()

			png(file=outfile2, width=1000, height=1000)
			pairs(out$vectors[, seq(min(ncol(out$vectors), 20))], col=smoothPalette(-log10(d+1), pal="RdBu"),
				pch=16)
			dev.off()
		}else{
			png(file=outfile1, width=1000, height=1000)
			pairs(out$U, col=V(g)$color, pch=16)
			dev.off()

			png(file=outfile2, width=1000, height=1000)
			pairs(out$U, col=smoothPalette(-log10(d+1), pal="RdBu"),
				pch=16)
			dev.off()
		}
	}
}
