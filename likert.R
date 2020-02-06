library(ggplot2)
samp_size = 60

likert_beta = function(n, a, b){
        round(rbeta(n, a, b) * 4)
}

centered      = likert_beta(samp_size, 2,   2)
r_tail        = likert_beta(samp_size, 2,   4)
l_tail        = likert_beta(samp_size, 4,   2)
concave       = likert_beta(samp_size, 8,   1)
more_concave  = likert_beta(samp_size, 8,   0.9)
ramp          = likert_beta(samp_size, 2,   0.9)
gentle_ramp   = likert_beta(samp_size, 1.1, 0.9)
ramp2         = likert_beta(samp_size, 2,   1)
moderate_ramp = likert_beta(samp_size, 1.5, 1)
very_spiky    = likert_beta(samp_size, 1.5, 0.5)
less_spiky    = likert_beta(samp_size, 1,   0.5)



samp_names = c("centered", "r_tail", "l_tail", "concave", "more_concave", "ramp", "gentle_ramp", "ramp2", "moderate_ramp", "very_spiky", "less_spiky")





qplot(concave, xlim=c(-0.2, 4.2))


wilcox.test(ramp, gentle_ramp)
