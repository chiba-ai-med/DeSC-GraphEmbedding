source("src/Functions.R")

# Argument
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile <- args[2]

# Load
A <- as.matrix(read.table(infile))
A[which(is.na(A))] <- 0

# Outlier Nodes
if(length(grep("small", infile))){
	target <- which(rownames(A) == "A301") # TT型ハンセン病
	A <- A[setdiff(seq(ncol(A)), target), ]
	A <- A[, setdiff(seq(ncol(A)), target)]
	target <- which(rownames(A) == "P93") # 新生児特異的薬物中毒
	A <- A[setdiff(seq(ncol(A)), target), ]
	A <- A[, setdiff(seq(ncol(A)), target)]
	target <- which(rownames(A) == "T534") # ジクロロメタン中毒
	A <- A[setdiff(seq(ncol(A)), target), ]
	A <- A[, setdiff(seq(ncol(A)), target)]
}

if(length(grep("medium", infile))){
	target <- which(rownames(A) == "U1") # ?
	A <- A[setdiff(seq(ncol(A)), target), ]
	A <- A[, setdiff(seq(ncol(A)), target)]
}

# Save
write.table(A, outfile)