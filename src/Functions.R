library("igraph")
library("tagcloud")
library("dcTensor")
library("ggplot2")
library("patchwork")
library("umap")
library("reshape2")

.min_max_norm <- function(x){
	x <- x + 1E-10
	(x - min(x)) / (max(x) - min(x))
}

# V以外
# https://en.wikipedia.org/wiki/ICD-10
colvec <- rep(0, length=25)
names(colvec) <- LETTERS[c(1:21, 23:26)]
colvec[1] <- "#E7298A" # A (Magenta)
colvec[2] <- "#E7298A" # B (Magenta)
colvec[3] <- "#66A61E" # C (Green)
colvec[4] <- "#1B9E77" # D (Blue/Green)
colvec[5] <- "#D95F02" # E (Blown)
colvec[6] <- "#666666" # F (Gray)
colvec[7] <- "#888888" # G (Gray)
colvec[8] <- "#A6761D" # H (Ocher)
colvec[9] <- "#7570B3" # I (Purple/Blue)
colvec[10] <- "#E6AB02" # J (Yellow/Ocher)
colvec[11] <- "#66C2A5" # K (Pale Blue/Green)
colvec[12] <- "#FC8D62" # L (Pale Orange)
colvec[13] <- "#8DA0CB" # M (Pale Blue)
colvec[14] <- "#E78AC3" # N (Pale Red)
colvec[15] <- "#A6D854" # O (Pale Green)
colvec[16] <- "#FFD92F" # P (Pale Yellow)
colvec[17] <- "#E5C494" # Q (Pale Blown)
colvec[18] <- "#B3B3B3" # R (Pale Gray)
colvec[19] <- "#FFFFFF" # S (White)
colvec[20] <- "#FFFFFF" # T (White)
colvec[21] <- rgb(1,0,0) # U (Red)
colvec[22] <- rgb(0,1,0) # W (Green)
colvec[23] <- rgb(0,1,0) # X (Green)
colvec[24] <- rgb(0,1,0) # Y (Green)
colvec[25] <- rgb(0,0,1) # Z (Blue)

# Disease Name
diseasevec <- rep(0, length=25)
names(diseasevec) <- LETTERS[c(1:21, 23:26)]
diseasevec[1] <- "Certain infectious and parasitic diseases" # A
diseasevec[2] <- "Certain infectious and parasitic diseases" # B
diseasevec[3] <- "Neoplasms" # C
diseasevec[4] <- "Neoplasms / Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism" # D
diseasevec[5] <- "Endocrine, nutritional and metabolic diseases" # E
diseasevec[6] <- "Mental and behavioural disorders" # F
diseasevec[7] <- "Diseases of the nervous system" # G
diseasevec[8] <- "Diseases of the eye and adnexa / Diseases of the ear and mastoid process" # H
diseasevec[9] <- "Diseases of the circulatory system" # I
diseasevec[10] <- "Diseases of the respiratory system" # J
diseasevec[11] <- "Diseases of the digestive system" # K
diseasevec[12] <- "Diseases of the skin and subcutaneous tissue" # L
diseasevec[13] <- "Diseases of the musculoskeletal system and connective tissue" # M
diseasevec[14] <- "Diseases of the genitourinary system" # N
diseasevec[15] <- "Pregnancy, childbirth and the puerperium" # O
diseasevec[16] <- "Certain conditions originating in the perinatal period" # P
diseasevec[17] <- "Congenital malformations, deformations and chromosomal abnormalities" # Q
diseasevec[18] <- "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified" # R
diseasevec[19] <- "Injury, poisoning and certain other consequences of external causes" # S
diseasevec[20] <- "Injury, poisoning and certain other consequences of external causes" # T
diseasevec[21] <- "Codes for special purposes" # U
diseasevec[22] <- "External causes of morbidity and mortality" # W
diseasevec[23] <- "External causes of morbidity and mortality" # X
diseasevec[24] <- "External causes of morbidity and mortality
" # Y
diseasevec[25] <- "Factors influencing health status and contact with health services" # Z

label2color <- function(x){
	colvec[substr(x, 1, 1)]
}

# Symmetric Matrix Tri-Factorization from SBSNTFCV
SMTF <- function(A, M=NULL, J, num.iter, Bin_U=0, Beta=2){
	U <- matrix(runif(nrow(A)*J), nrow=nrow(A), ncol=J)
	S <- matrix(runif(J*J), nrow=J, ncol=J)
	S <- S %*% t(S)
	RecError <- rep(0, length=num.iter)
	TestRecError <- rep(0, length=num.iter)
	RelChange <- rep(0, length=num.iter)
	for(i in seq_len(num.iter)){
		print(i)
		if(is.null(M)){
			# Update U
			out <- dNMTF(A, initU=U, initV=U, initS=S,
				fixS=TRUE, fixV=TRUE, rank=c(J,J), num.iter=1, Bin_U=Bin_U, Beta=Beta)
			U <- out$U
			# Update S
			out <- dNMTF(A, initU=U, initV=U, initS=S,
				fixU=TRUE, fixV=TRUE, rank=c(J,J), num.iter=1, Bin_U=Bin_U, Beta=Beta)
			S <- out$S
		}else{
			# Update U
			out <- dNMTF(A, M=M, initU=U, initV=U, initS=S,
				fixS=TRUE, fixV=TRUE, rank=c(J,J), num.iter=1, Bin_U=Bin_U, Beta=Beta)
			U <- out$U
			# Update S
			out <- dNMTF(A, M=M, initU=U, initV=U, initS=S,
				fixU=TRUE, fixV=TRUE, rank=c(J,J), num.iter=1, Bin_U=Bin_U, Beta=Beta)
			S <- out$S
		}
		# Log
		RecError[i] <- out$RecError[2]
		TestRecError[i] <- out$TestRecError[2]
		RelChange[i] <- out$RelChange[2]
	}
	list(U=U, S=S, RecError=RecError, RelChange=RelChange,
		TestRecError=TestRecError)
}
