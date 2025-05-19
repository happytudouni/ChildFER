# install packages
# install.packages("haven")
# install.packages("geepack")
# install.packages("ggplot2")
# install.packages("emmeans")
# install.packages("lme4")
# install.packages("readxl")
# install.packages("visreg")
# install.packages("effects")

# load packages
library(haven)
library(geepack)
library(ggplot2)
library(emmeans)
library(lme4)
library(readxl)
library(effects)
# import data
data <- read_xlsx("/Users/huangshuran/Downloads/GEE_children.xlsx")
data <- read_xlsx("/Users/huangshuran/Downloads/data_final/RSA/results/GEE_children_20sec.xlsx")
data <- read_xlsx("/Users/huangshuran/Downloads/data_final/RSA/results/GEE_adult.xlsx")

data_clean <- data[complete.cases(data), ]
# GEE model for children

gee_model <- geeglm(sorting~ssvep*month+rating*month+FACS, 
                    data = data_clean, 
                    id = participantnumber, 
                    family = gaussian, 
                    corstr = "exchangeable")

gee_model <- geeglm(sorting~ssvep+rating, 
                    data = data_clean, 
                    id = participantnumber, 
                    family = gaussian, 
                    corstr = "exchangeable")

gee_model <- geeglm(ssvep~rating*month+FACS, 
                    data = data_clean, 
                    id = participantnumber, 
                    family = gaussian, 
                    corstr = "exchangeable")

summary(gee_model)
#for adults
gee_model <- geeglm(mt~ssvep+rating+FACES, 
                    data = data_clean, 
                    id = participantnumber, 
                    family = gaussian, 
                    corstr = "exchangeable")

summary(gee_model)

# Simple Slope Test
age_mean <- mean(data_clean$month, na.rm = TRUE)
age_sd <- sd(data_clean$month, na.rm = TRUE)

data_clean$age_group <- cut(data_clean$month, 
                            breaks = c(-Inf, age_mean - age_sd, age_mean + age_sd, Inf),
                            labels = c("mean-sd", "mean", "mean+sd"))




write.csv(data_clean, "data_clean_export.csv", row.names = FALSE)

table(data_clean$age_group)

for (group in levels(data_clean$age_group)) {
  cat("Analyzing age group:", group, "\n")

  subset_data <- subset(data_clean, age_group == group)
  model <- geeglm(mt ~rating, 
                  data = subset_data, 
                  id = participantnumber, 
                  family = gaussian, 
                  corstr = "exchangeable")
  print(summary(model))
  cat("\n")
}


# Parameters of outcome
coef_table <- summary(gee_model)$coefficients
B_total <- sum(abs(coef_table[, 1]))

for (i in 1:nrow(coef_table)) {
  term <- rownames(coef_table)[i]
  B <- coef_table[i, 1]
  SE <- coef_table[i, 2]
  Wald <- coef_table[i, 3]
  Z <- sign(B) * sqrt(Wald)
  p <- coef_table[i, 4]
  
  CI_lower <- B - 1.96 * SE
  CI_upper <- B + 1.96 * SE
  
  NC <- abs(B) / B_total * 100
  
  B_fmt  <- formatC(B, format = "e", digits = 2)
  SE_fmt <- formatC(SE, format = "e", digits = 2)
  CI_fmt <- paste0("[", formatC(CI_lower, format = "e", digits = 2),
                   ", ", formatC(CI_upper, format = "e", digits = 2), "]")
  Z_fmt  <- formatC(Z, format = "f", digits = 2)
  NC_fmt <- formatC(NC, format = "f", digits = 2)
  p_fmt  <- ifelse(p < .0001, "< 0.0001", formatC(p, format = "f", digits = 4))
  
  cat(term, ": B = ", B_fmt,
      ", s.e. = ", SE_fmt,
      ", 95% CI ", CI_fmt,
      ", Z = ", Z_fmt,
      ", %NC = ", NC_fmt, "%, P = ", p_fmt, "\n", sep = "")
}


