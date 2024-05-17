source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile1 <- args[4]
outfile2 <- args[5]

# Load
coordinate <- read.table(infile1, header=FALSE, skip=1)
load(infile2)
d <- unlist(read.table(infile3, header=FALSE))

# Pre-process
coordinate <- coordinate[order(coordinate[,1]), ]
coordinate <- coordinate[,2:3]
coordinate <- as.matrix(coordinate)

# Plot
png(file=outfile1, width=3000, height=3000)
plot(g, layout=coordinate,
	vertex.size=0.8,
	vertex.color=V(g)$color,
	vertex.label.cex=0.8,
	vertex.label.color=rgb(0,0,0),
	edge.width=E(g)$weight/75, edge.color=rgb(0,0,0))
dev.off()

# Plot
png(file=outfile2, width=3000, height=3000)
plot(g, layout=coordinate,
	vertex.size=.min_max_norm(log10(d+1))*6,
	vertex.color=smoothPalette(-log10(d+1), pal="RdBu"),
	vertex.label.cex=.min_max_norm(log10(d+1))*2,
	vertex.label.color=rgb(0,0,0),
	edge.width=E(g)$weight/75, edge.color=rgb(0,0,0))
dev.off()
