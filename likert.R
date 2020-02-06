library(ggplot2)
samp_size = 650

likert_beta = function(n, a, b){
	round(rbeta(n, a, b) * 4)
}

centered = likert_beta(samp_size, 2, 2)
r_tail = likert_beta(samp_size, 2, 4)
l_tail = likert_beta(samp_size, 4, 2)



qplot(rbeta(samp_size, 8,   1))   # concave
qplot(rbeta(samp_size, 8,   0.9)) # more concave?
qplot(rbeta(samp_size, 2,   0.9)) # ramp
qplot(rbeta(samp_size, 1.1, 0.9)) # gentle ramp
qplot(rbeta(samp_size, 2,   1))   # ramp
qplot(rbeta(samp_size, 1.5, 1))   # moderate ramp
qplot(rbeta(samp_size, 1.5, 0.5)) # very spiky
qplot(rbeta(samp_size, 1,   0.5)) # less spiky
