library(ggplot2)
samp_size = 650
unit_interval = c(0,1,2,3,4,5,6,7,8,9,10) / 10

b22 = rbeta(samp_size, 2, 2)
qplot(b22)

b24 = rbeta(samp_size, 2, 4)
qplot(b24)

b42 = rbeta(samp_size, 4, 2)
qplot(b42)