library(ggplot2)

#### GENERATE ASSORTED SAMPLES OF FAKE LIKERT DATA

SAMP_SIZE = 60
MAX_LIKERT = 4   # 0 to 4 Likert scale

likert_beta = function(n, a, b){
        round(rbeta(n, a, b) * MAX_LIKERT)
}

centered      = likert_beta(SAMP_SIZE, 2,   2)
r_tail        = likert_beta(SAMP_SIZE, 2,   4)
l_tail        = likert_beta(SAMP_SIZE, 4,   2)
concave       = likert_beta(SAMP_SIZE, 8,   1)
more_concave  = likert_beta(SAMP_SIZE, 8,   0.9)
ramp          = likert_beta(SAMP_SIZE, 2,   0.9)
gentle_ramp   = likert_beta(SAMP_SIZE, 1.1, 0.9)
ramp2         = likert_beta(SAMP_SIZE, 2,   1)
moderate_ramp = likert_beta(SAMP_SIZE, 1.5, 1)
very_spiky    = likert_beta(SAMP_SIZE, 1.5, 0.5)
less_spiky    = likert_beta(SAMP_SIZE, 1,   0.5)


#### BUILD UP A DATA FRAME

# Group:        A                B

samp_names = c("centered",      "r_tail",         # question 1
	       "l_tail",        "concave",        # question 2
	       "more_concave",  "ramp",		  # 3
	       "gentle_ramp",   "ramp2",	  # 4
	       "moderate_ramp", "very_spiky",	  # 5
	       "less_spiky",    "moderate_ramp")  # 6

# Q1 group A

X = data.frame(score = centered, pop_name = rep("centered", length(centered)), 
                                 group = rep("A", length(centered)),
                                 question_num = rep(1, length(centered)))

# Q1 group B, through Q6 group B

npanel = 1
for (s in samp_names[-1]){
        g = "A"
        if(npanel %% 2 == 1){
                g = "B"
        }
        q = floor(npanel / 2) + 1
        temp_vec = eval(parse(text=s))
        temp_frame = data.frame(score = temp_vec, pop_name = rep(s, length(temp_vec)), 
                                                  group = rep(g, length(temp_vec)),
                                                  question_num = rep(q, length(temp_vec)))
        X = rbind(X, temp_frame)
        npanel = npanel + 1
}


#### Sketch 2 probability distributions and make variates from them.
#### Allows us to more easily make tricky ones with high P values.

q7a = c(1, 3.2, 2, 1.5, 1)
q7b = c(1, 1.5, 2, 3, 1)
q7a = round(SAMP_SIZE / sum(q7a) * q7a) # normalize
q7b = round(SAMP_SIZE / sum(q7b) * q7b)

for (s in 0:MAX_LIKERT){
	replicates_a = q7a[s+1]
	replicates_b = q7b[s+1]
	for (i in 1:replicates_a){
		X = rbind(X, data.frame(score = s, pop_name = "sketched",
		                        group = "A", question_num = 7))
	}
	for (i in 1:replicates_b){
		X = rbind(X, data.frame(score = s, pop_name = "sketched",
		                        group = "B", question_num = 7))
	}
}


#### PLOTS AND ANALYSIS

p = ggplot(X, aes(score)) + geom_bar() + xlab("Likert score")
p + facet_grid(rows = vars(question_num), cols = vars(group))
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

        temp_frame = data.frame(question = q, wilcoxon_p = wt$p.value,
	                        ttest_p = tt$p.value, catt_p = catt$p.value, chi_p = cs$p.value)
        Results= rbind(Results, temp_frame)
}

# T test may be OK?
# Norman G. Adv Health Sci Educ Theory Pract. 2010 Dec;15(5):625-32. PMID 20146096.
# Sullivan & Artino. J Grad Med Educ. 2013 Dec; 5(4): 541–542. PMID 24454995.

round(Results, 8)
