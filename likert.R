library(ggplot2)

#### GENERATE ASSORTED SAMPLES OF FAKE LIKERT DATA

samp_size = 60

likert_beta = function(n, a, b){
        round(rbeta(n, a, b) * 4)   # 0 to 4 Likert scale
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


#### BUILD UP A DATA FRAME

samp_names = c("centered", "r_tail", "l_tail", "concave", "more_concave", "ramp", "gentle_ramp", "ramp2", "moderate_ramp", "very_spiky", "less_spiky", "moderate_ramp")

X = data.frame(score = centered, pop_name = rep("centered", length(centered)), 
								group = rep("A", length(centered)),
								question_num = rep(1, length(centered)))
npanel = 1
for (s in samp_names[-1]){
	tp = "A"
	if(npanel %% 2 == 1){
		tp = "B"
	}
	qn = floor(npanel / 2) + 1
	temp_vec = eval(parse(text=s))
	temp_frame = data.frame(score = temp_vec, pop_name = rep(s, length(temp_vec)), 
											group = rep(tp, length(temp_vec)),
											question_num = rep(qn, length(temp_vec)))
	X = rbind(X, temp_frame)
	npanel = npanel + 1
}


#### PLOTS AND ANALYSIS

p = ggplot(X, aes(score)) + geom_bar()
p + facet_grid(rows = vars(pop_name))  # all in one col, lined up

p + facet_wrap(vars(pop_name))    # wrap, broken in several cols

p + facet_grid(rows = vars(question_num), cols = vars(group)) # best one yet

g = ggplot(X, aes(pop_name))
g + geom_bar(aes(fill=as.factor(score))) # kind of like spineplot, colors not great


#### TESTS

Results = data.frame()

for (q in 1:6){
	wt = wilcox.test(X[X$question_num == q & X$group == "A", ]$score,
				X[X$question_num == q & X$group == "B", ]$score)
	tt = t.test(score ~ group, data = X[X$question_num == q, ])
	tab = with(X[ X$question_num == q, ], table(score, group)) # 5x2 table
	catt = prop.trend.test(tab[,1], apply(tab,1, sum))
	# https://www.rdocumentation.org/packages/DescTools/versions/0.99.32/topics/CochranArmitageTest

	temp_frame = data.frame(question = q, wilcoxon_p = wt$p.value, ttest_p = tt$p.value, catt_p = catt$p.value)
	Results= rbind(Results, temp_frame)
	#print(q)
	#print(wt)
	#print(tt)
	#print(catt)
}

tapply(X$pop_name, X[,-2], length) # 5x2 tables for each of 6 questions

# T test maybe OK?
# Norman G. Adv Health Sci Educ Theory Pract. 2010 Dec;15(5):625-32. PMID 20146096.
# Sullivan & Artino. J Grad Med Educ. 2013 Dec; 5(4): 541–542. PMID 24454995.

round(Results, 8)
