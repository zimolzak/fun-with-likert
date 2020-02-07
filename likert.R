library(ggplot2)

#### GENERATE ASSORTED SAMPLES OF FAKE LIKERT DATA

samp_size = 60
max_likert = 4

likert_beta = function(n, a, b){
        round(rbeta(n, a, b) * max_likert)   # 0 to 4 Likert scale
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


#### Sketch 2 probability distributions and make variates from them.
#### Allows us to more easily make tricky ones with high P values.

q7a = c(1, 3.2, 2, 1.5, 1)
q7b = c(1, 1.5, 2, 3, 1)
q7a = round(samp_size / sum(q7a) * q7a) # normalize
q7b = round(samp_size / sum(q7b) * q7b)

for (s in 0:max_likert){
	replicates_a = q7a[s+1]
	replicates_b = q7b[s+1]
	for (i in 1:replicates_a){
		X = rbind(X, data.frame(score = s, pop_name = "sketched", group = "A", question_num = 7))
	}
	for (i in 1:replicates_b){
		X = rbind(X, data.frame(score = s, pop_name = "sketched", group = "B", question_num = 7))
	}
}


#### PLOTS AND ANALYSIS

p = ggplot(X, aes(score)) + geom_bar()
p + facet_grid(rows = vars(question_num), cols = vars(group)) # best one yet
ggsave("facet_grid.png")

Results = data.frame()

for (q in 1:7){
        wt = wilcox.test(X[X$question_num == q & X$group == "A", ]$score,
                         X[X$question_num == q & X$group == "B", ]$score)
        tt = t.test(score ~ group, data = X[X$question_num == q, ])
        tab = with(X[ X$question_num == q, ], table(score, group)) # 5x2 table
        catt = prop.trend.test(tab[,1], apply(tab,1, sum))
        cs = prop.test(tab[,1], apply(tab,1, sum))
        # https://www.rdocumentation.org/packages/DescTools/versions/0.99.32/topics/CochranArmitageTest

        temp_frame = data.frame(question = q, wilcoxon_p = wt$p.value, ttest_p = tt$p.value, catt_p = catt$p.value, chi_p = cs$p.value)
        Results= rbind(Results, temp_frame)
}

# T test may be OK?
# Norman G. Adv Health Sci Educ Theory Pract. 2010 Dec;15(5):625-32. PMID 20146096.
# Sullivan & Artino. J Grad Med Educ. 2013 Dec; 5(4): 541–542. PMID 24454995.

round(Results, 8)
