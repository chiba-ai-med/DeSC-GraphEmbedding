source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile1 <- args[4]
outfile2 <- args[5]

# Load
coordinate <- as.matrix(read.table(infile1, header=FALSE))
load(infile2)
d <- unlist(read.table(infile3, header=FALSE))

# Plot
if(length(grep("small", infile1))){
	png(file=outfile1, width=3000, height=3000)
	plot(g, layout=coordinate,
		vertex.size=0.8,
		vertex.color=V(g)$color,
		vertex.label.cex=0.8,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/75, edge.color=rgb(0,0,0))
	dev.off()
}

if(length(grep("medium", infile1))){
	png(file=outfile1, width=1000, height=1000)
	plot(g, layout=coordinate,
		vertex.size=7,
		vertex.color=V(g)$color,
		vertex.label.cex=2,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/60, edge.color=rgb(0,0,0))
	dev.off()
}

if(length(grep("large", infile1))){
	png(file=outfile1, width=1000, height=1000)
	plot(g, layout=coordinate,
		vertex.size=10,
		vertex.color=V(g)$color,
		vertex.label.cex=3,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/3, edge.color=rgb(0,0,0))
	dev.off()
}

# Plot
if(length(grep("small", infile1))){
	png(file=outfile2, width=3000, height=3000)
	plot(g, layout=coordinate,
		vertex.size=.min_max_norm(log10(d+1))*6,
		vertex.color=smoothPalette(-log10(d+1), pal="RdBu"),
		vertex.label.cex=.min_max_norm(log10(d+1))*2,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/75, edge.color=rgb(0,0,0))
	dev.off()
}

if(length(grep("medium", infile1))){
	png(file=outfile2, width=1000, height=1000)
	plot(g, layout=coordinate,
		vertex.size=.min_max_norm(log10(d+1))*9,
		vertex.color=smoothPalette(-log10(d+1), pal="RdBu"),
		vertex.label.cex=.min_max_norm(log10(d+1))*2,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/60, edge.color=rgb(0,0,0))
	dev.off()
}

if(length(grep("large", infile1))){
	png(file=outfile2, width=1000, height=1000)
	plot(g, layout=coordinate,
		vertex.size=.min_max_norm(log10(d+1))*12,
		vertex.color=smoothPalette(-log10(d+1), pal="RdBu"),
		vertex.label.cex=.min_max_norm(log10(d+1))*2,
		vertex.label.color=rgb(0,0,0),
		edge.width=E(g)$weight/3, edge.color=rgb(0,0,0))
	dev.off()
}

