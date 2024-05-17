source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
d <- unlist(read.table(infile, header=FALSE))

# Binning
if(length(grep("small", infile))){
	bin_width <- 10^7
}
if(length(grep("medium", infile))){
	bin_width <- 10^8
}
if(length(grep("large", infile))){
	bin_width <- 10^9
}
degree_bins <- cut(d, breaks = seq(min(d), max(d) + bin_width,
	by = bin_width), right = FALSE)
degree_distribution <- table(degree_bins)
bin_centers <- (seq(min(d), max(d),
	by = bin_width) + (bin_width / 2))[1:length(degree_distribution)]
P_k <- as.numeric(degree_distribution) / sum(degree_distribution)
data <- data.frame(k = bin_centers, P_k = P_k)
data <- data[data$P_k > 0, ]

# Log-Transformation
data$log_k <- log(data$k)
data$log_P_k <- log(data$P_k)

# Linear Regression
fit <- lm(log_P_k ~ log_k, data = data)

# Plot
g <- ggplot(data, aes(x = log_k, y = log_P_k)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "log(k)", y = "log(P(k))") +
  ggtitle(sprintf("γ = %.2f", -coef(fit)[2])) +
  theme_minimal()
ggsave(file=outfile, g, dpi=100, width=7, height=7)