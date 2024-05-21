source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Load
A <- as.matrix(read.table(infile1))
diag(A) <- 0
d <- unlist(read.table(infile2, header=FALSE))
data <- data.frame(node=rownames(A), degree=d)
data <- data[rank(-data$degree) <= 100, ]

# Plot
g <- ggplot(data=data, aes(x=reorder(node, degree), y=degree, fill=degree))
g <- g + geom_bar(stat="identity")
g <- g + theme(axis.text.x = element_text(angle=90, size=12))
g <- g + theme(axis.title.x = element_blank())
g <- g + scale_fill_gradient2(
	low = "blue", high = "red", mid = "white",
	midpoint = max(d)/2,
	limit = c(min(d), max(d)))
ggsave(file=outfile, g, dpi=100, width=15, height=7)

