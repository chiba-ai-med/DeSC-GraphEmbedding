source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
A <- as.matrix(read.table(infile1))
A[which(is.na(A))] <- 0
A <- log10(A + 1)
d <- unlist(read.table(infile2, header=FALSE))
data <- data.frame(node=rownames(A), degree=d)

# Pre-processing
rank_degree <- rank(d)
names(rank_degree) <- rownames(A)
melted_A <- melt(A)
melted_A <- data.frame(melted_A,
	rank_Var1=rank_degree[melted_A[,1]],
	rank_Var2=rank_degree[melted_A[,2]])

# Plot
g <- ggplot(data = melted_A, aes(x=reorder(Var1, rank_Var1),
	y=reorder(Var2, rank_Var2), fill=value))
g <- g + geom_tile(color="white")
g <- g + xlab("")
g <- g + ylab("")
g <- g + guides(x="none", y="none")
g <- g + scale_fill_gradient2(
	low = "blue", high = "red", mid = "white",
	midpoint = (min(A)+max(A))/2, limit = c(min(A), max(A)),
	name = "log10(x+1)", space = "Lab")
ggsave(file=outfile, g, dpi=100, width=14, height=14)
