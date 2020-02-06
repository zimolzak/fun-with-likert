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

samp_names = c("centered", "r_tail", "l_tail", "concave", "more_concave", "ramp", "gentle_ramp", "ramp2", "moderate_ramp", "very_spiky", "less_spiky", "moderate_ramp")

X = data.frame(score = centered, pop_name = rep("centered", length(centered)), 
								timepoint = rep("pre", length(centered)),
								question_num = rep(1, length(centered)))
npanel = 1
for (s in samp_names[-1]){
	tp = "pre"
	if(npanel %% 2 == 1){
		tp = "post"
	}
	qn = floor(npanel / 2) + 1
	temp_vec = eval(parse(text=s))
	temp_frame = data.frame(score = temp_vec, pop_name = rep(s, length(temp_vec)), 
											timepoint = rep(tp, length(temp_vec)),
											question_num = rep(qn, length(temp_vec)))
	X = rbind(X, temp_frame)
	npanel = npanel + 1
}

#### PLOTS AND ANALYSIS

p = ggplot(X, aes(score)) + geom_bar()
p + facet_grid(rows = vars(pop_name))  # all in one col, lined up

p + facet_wrap(vars(pop_name))    # wrap, broken in several cols

wilcox.test(ramp, gentle_ramp)

#prop.test
#prop.trend.test
#spineplot

g = ggplot(X, aes(pop_name))
g + geom_bar(aes(fill=as.factor(score))) # kind of spine plot, colors not great
