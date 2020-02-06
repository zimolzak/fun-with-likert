library(ggplot2)
samp_size = 650
unit_interval = c(0,1,2,3,4,5,6,7,8,9,10) / 10

b22 = rbeta(samp_size, 2, 2)
qplot(round(b22 * 4))

b24 = rbeta(samp_size, 2, 4)
qplot(round(b24 * 4), xlim=c(-0.1,4))

b42 = rbeta(samp_size, 4, 2)
qplot(round(b42 * 4), xlim=c(-0.1,4.2))

qplot(rbeta(samp_size, 8,   1))   # concave
qplot(rbeta(samp_size, 8,   0.9)) # more concave?
qplot(rbeta(samp_size, 2,   0.9)) # ramp
qplot(rbeta(samp_size, 1.1, 0.9)) # gentle ramp
qplot(rbeta(samp_size, 2,   1))   # ramp
qplot(rbeta(samp_size, 1.5, 1))   # moderate ramp
qplot(rbeta(samp_size, 1.5, 0.5)) # very spiky
qplot(rbeta(samp_size, 1,   0.5)) # less spiky
