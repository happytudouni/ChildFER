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
data <- read_xlsx("//Users/huangshuran/Downloads/Data & Code/Study III/Data and Materials/GEE_final(children)_ROIall.xlsx")
data_clean <- data[complete.cases(data), ]
# GEE model 
gee_model <- geeglm(sorting~rating*age+ssvep*age+FACS, 
                    data = data_clean, 
                    id = participantnumber, 
                    family = gaussian, 
                    corstr = "exchangeable")

summary(gee_model)

# Simple Slope Test
age_mean <- mean(data_clean$age, na.rm = TRUE)
age_sd <- sd(data_clean$age, na.rm = TRUE)

data_clean$age_group <- cut(data_clean$age, 
                            breaks = c(-Inf, age_mean - age_sd, age_mean + age_sd, Inf),
                            labels = c("mean-sd", "mean", "mean+sd"))

table(data_clean$age_group)

for (group in levels(data_clean$age_group)) {
  cat("Analyzing age group:", group, "\n")

  subset_data <- subset(data_clean, age_group == group)
  model <- geeglm(sorting ~ ssvep, 
                  data = subset_data, 
                  id = participantnumber, 
                  family = gaussian, 
                  corstr = "exchangeable")
  print(summary(model))
  cat("\n")
}





