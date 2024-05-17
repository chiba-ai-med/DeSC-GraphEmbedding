source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))
A[which(is.na(A))] <- 0
A <- log10(A + 1)

# Clustering
dev.new()
clr <- heatmap(A, scale="none")
dev.off()

# Pre-processing
row_index <- rownames(A)[clr$rowInd]
col_index <- colnames(A)[clr$colInd]
melted_A <- melt(A)
melted_A$Var1 <- factor(melted_A$Var1, levels=row_index)
melted_A$Var2 <- factor(melted_A$Var2, levels=col_index)

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
