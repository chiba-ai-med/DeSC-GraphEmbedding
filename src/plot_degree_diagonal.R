source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile1 <- args[4]
outfile2 <- args[5]
outfile3 <- args[6]

# Load
d1 <- unlist(read.table(infile1, header=FALSE))
d2 <- unlist(read.table(infile2, header=FALSE))
load(infile3)

# Pre-processing
d <- log10(d1 + 1) - log10(d2 + 1)
high_data <- data.frame(node=names(V(g)), ratio=d)
low_data <- data.frame(node=names(V(g)), ratio=d)
high_data <- high_data[rank(-high_data$ratio) <= 100, ]
low_data <- low_data[rank(low_data$ratio) <= 100, ]

# Plot
png(file=outfile1, width=750, height=750)
plot(log10(d1 + 1), log10(d2 + 1),
	xlab="log10(degree + 1)", ylab="log10(diagonal + 1)",
	col=V(g)$color, pch=16)
dev.off()

# Plot（High）
high_g <- ggplot(data=high_data, aes(x=reorder(node, ratio), y=ratio, fill=ratio))
high_g <- high_g + geom_bar(stat="identity")
high_g <- high_g + theme(axis.text.x = element_text(angle=90, size=12))
high_g <- high_g + theme(axis.title.x = element_blank())
high_g <- high_g + scale_fill_gradient2(
	low = "blue", high = "red", mid = "white",
	midpoint = (min(d) + max(d))/2,
	limit = c(min(d), max(d)))
ggsave(file=outfile2, high_g, dpi=100, width=15, height=7)

# Plot（Low）
low_g <- ggplot(data=low_data, aes(x=reorder(node, ratio), y=ratio, fill=ratio))
low_g <- low_g + geom_bar(stat="identity")
low_g <- low_g + theme(axis.text.x = element_text(angle=90, size=12))
low_g <- low_g + theme(axis.title.x = element_blank())
low_g <- low_g + scale_fill_gradient2(
	low = "blue", high = "red", mid = "white",
	midpoint =(min(d) + max(d))/2,
	limit = c(min(d), max(d)))
ggsave(file=outfile3, low_g, dpi=100, width=15, height=7)
