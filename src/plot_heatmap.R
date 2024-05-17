source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))
A[which(is.na(A))] <- 0
A <- log10(A + 1)

# Pre-processing
melted_A <- melt(A)

# Plot
g <- ggplot(data = melted_A, aes(x=Var1, y=Var2, fill=value))
g <- g + geom_tile(color="white")
g <- g + xlab("")
g <- g + ylab("")
g <- g + guides(x="none", y="none")
g <- g + scale_fill_gradient2(
	low = "blue", high = "red", mid = "white",
	midpoint = (min(A)+max(A))/2, limit = c(min(A), max(A)),
	name = "log10(x+1)", space = "Lab")
ggsave(file=outfile, g, dpi=100, width=14, height=14)
