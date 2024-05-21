source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))

# Pre-processing (Diagonal Elements)
diagA <- A
diagA[upper.tri(diagA)] <- NA
diagA[lower.tri(diagA)] <- NA
melted_diagA <- melt(diagA)
melted_diagA <- melted_diagA[which(!is.na(melted_diagA$value)), ]
melted_diagA <- cbind(melted_diagA, type="diagonal")

# Pre-processing (Off-Diagonal Elements)
offdiagA <- A
diag(offdiagA) <- NA
offdiagA[lower.tri(offdiagA)] <- NA
melted_offdiagA <- melt(offdiagA)
melted_offdiagA <- melted_offdiagA[which(!is.na(melted_offdiagA$value)), ]
melted_offdiagA <- cbind(melted_offdiagA, type="off-diagonal")

# Plot
g1 <- ggplot(data = melted_diagA, aes(x=value))
g1 <- g1 + coord_cartesian(xlim = c(0, max(A)))
g2 <- ggplot(data = melted_offdiagA, aes(x=value))
g2 <- g2 + coord_cartesian(xlim = c(0, max(A)))
if(length(grep("small", infile))){
	g1 <- g1 + geom_histogram(fill="red", binwidth=10^5.5)
	g2 <- g2 + geom_histogram(fill="blue", binwidth=10^5.5)
}
if(length(grep("medium", infile))){
	g1 <- g1 + geom_histogram(fill="red", binwidth=10^6)
	g2 <- g2 + geom_histogram(fill="blue", binwidth=10^6)
}
if(length(grep("large", infile))){
	g1 <- g1 + geom_histogram(fill="red", binwidth=10^7)
	g2 <- g2 + geom_histogram(fill="blue", binwidth=10^7)
}
g <- g1 + g2 + plot_layout(ncol=1, heights=c(1,1))
ggsave(file=outfile, g, dpi=100, width=14, height=7)
