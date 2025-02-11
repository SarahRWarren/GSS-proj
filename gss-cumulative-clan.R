library(tidyverse)
library(haven)
library(labelled)
rm(list=ls())

#BEOFRE RUNNING: Unzip GSS_stata(1) on your machine

df <- read_dta("GSS_stata/gss7222_r4.dta")

df <- df %>%
  select(natheal, nathealy, health, race, relig, sex, income, happy, educ,
         year, wtssps, wtssall,
         wtssnr) %>%
  remove_labels()

write_rds(df, "clean-GSS-vars-w-weights.RDS")
write_csv(df, "clean-GSS-vars-w-weights.csv")


##########################take a peek

#health over time

health_df <- df %>%
  select(health, year, sex) %>%
  drop_na() %>%
  group_by(year) %>%
  mutate(mean_health = mean(health))

ggplot(health_df, aes(x=year, y=mean_health)) + geom_point() +
  theme_bw() +
  labs(x= "", y="Average Health Rating")

health_df <- health_df %>%
  group_by(year,sex) %>%
  mutate(mean_health_bysex = mean(health))

health_df$sex_factor <- ifelse(health_df$sex==1, "Male", "Female")

#forgive my problematic color choices
ggplot(health_df, aes(x=year, y=mean_health_bysex, color=sex_factor)) + geom_point() +
  theme_bw() +
  scale_color_manual(values = c("#FC0FE9", "cornflowerblue"))+
  theme(legend.position = c(0.8,0.2)) +
  labs(x= "", y="Average Health Rating", color = "")
ggsave("figs/average-health-by-sex.png")
