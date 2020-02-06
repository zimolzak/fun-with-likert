library(ggplot2)
samp_size = 650
unit_interval = c(0,1,2,3,4,5,6,7,8,9,10) / 10
b22_sample = rbeta(samp_size, 2, 2)
qplot(b22_sample)

