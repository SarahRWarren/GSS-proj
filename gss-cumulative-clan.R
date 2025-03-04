library(tidyverse)
library(haven)
library(labelled)
rm(list=ls())

#BEOFRE RUNNING: Unzip GSS_stata(1) on your machine

df <- read_dta("GSS_stata/gss7222_r4.dta")

df <- df %>%
  select(natheal, nathealy, happy, health, race, relig, sex, educ, age,
         year, wtssps, natarmsy, natarms, conarmy) %>%
  remove_labels()

write_rds(df, "clean-GSS-vars-w-weights.RDS")
write_csv(df, "clean-GSS-vars-w-weights.csv")


##########################take a peek

rm(list=ls())
df <- read_rds("clean-GSS-vars-w-weights.RDS") %>%
  subset(age >= 18 & age <= 29)

#health over time

health_df <- df %>%
  select(natheal, nathealy, happy, health, wtssps, year) %>%
  group_by(year) %>%
  summarize(natheal_w_av_yr = weighted.mean(natheal, wtssps, na.rm=TRUE),
            sd_natheal = sd(natheal, na.rm=TRUE),
            se_natheal = sd_natheal / sqrt(n()),
         nathealy_w_av_yr = weighted.mean(nathealy, wtssps, na.rm=TRUE),
         sd_nathealy = sd(nathealy,na.rm=TRUE),
         se_nathealy = sd_nathealy / sqrt(n()),
         happy_w_av_yr = weighted.mean(happy, wtssps, na.rm=TRUE),
         sd_happy = sd(happy, na.rm=TRUE),
         se_happy = sd_happy / sqrt(n()),
         health_w_av_yr = weighted.mean(health, wtssps, na.rm=TRUE),
         sd_health = sd(health, na.rm=TRUE),
         se_health = sd_health / sqrt(n()))

health_df_by_sex <- df %>%
  select(natheal, nathealy, happy, health, wtssps, year, sex) %>%
  group_by(year, sex) %>%
  summarize(natheal_w_av_sex = weighted.mean(natheal, wtssps, na.rm=TRUE),
            sd_natheal = sd(natheal,na.rm=TRUE),
            se_natheal = sd_natheal / sqrt(n()),
            nathealy_w_av_sex = weighted.mean(nathealy, wtssps, na.rm=TRUE),
            sd_nathealy = sd(nathealy,na.rm=TRUE),
            se_nathealy = sd_nathealy / sqrt(n()),
            happy_w_av_sex = weighted.mean(happy, wtssps, na.rm=TRUE),
            sd_happy = sd(happy,na.rm=TRUE),
            se_happy = sd_happy / sqrt(n()),
            health_w_av_sex = weighted.mean(health, wtssps, na.rm=TRUE),
            sd_health = sd(health,na.rm=TRUE),
            se_health = sd_health / sqrt(n()))

ggplot(health_df, aes(x=year, y=natheal_w_av_yr)) + geom_point() +
  geom_line(linetype="dashed") +
  theme_bw() +
  labs(x="", y="Weighted Average Health Rating: Natheal") +
  geom_errorbar(aes(ymin = (natheal_w_av_yr -1.96*se_natheal), 
                    ymax = (natheal_w_av_yr + 1.96*se_natheal)), width = 0.4)
ggsave("figs/wav-natheal.png")

ggplot(health_df, aes(x=year, y=nathealy_w_av_yr)) + geom_point() +
  geom_line(linetype="dashed") +
  theme_bw() +
  labs(x="", y="Weighted Average Health Rating: Nathealy") +
  geom_errorbar(aes(ymin = (nathealy_w_av_yr -1.96*se_nathealy), 
                    ymax = (nathealy_w_av_yr + 1.96*se_nathealy)), width = 0.4)
ggsave("figs/wav-nathealy.png")


ggplot(health_df, aes(x=year, y=happy_w_av_yr)) + geom_point() +
  geom_line(linetype="dashed") +
  theme_bw() +
  labs(x="", y="Weighted Average Health Rating: Happy") +
  geom_errorbar(aes(ymin = (happy_w_av_yr -1.96*se_happy), 
                    ymax = (happy_w_av_yr + 1.96*se_happy)), width = 0.4)
ggsave("figs/wav-happy.png")


ggplot(health_df, aes(x=year, y=health_w_av_yr)) + geom_point() +
  geom_line(linetype="dashed") +
  theme_bw() +
  labs(x="", y="Weighted Average Health Rating: Health") +
  geom_errorbar(aes(ymin = (health_w_av_yr -1.96*se_health), 
                    ymax = (health_w_av_yr + 1.96*se_health)), width = 0.4)
ggsave("figs/wav-happy.png")



health_df_by_sex$sex_factor <- ifelse(health_df_by_sex$sex==1, "Male", "Female")
health_df_by_sex <- health_df_by_sex %>%
  drop_na(sex_factor)

#forgive my problematic color choices
ggplot(health_df_by_sex, aes(x=year, y=natheal_w_av_sex, color=sex_factor)) +
  geom_point() + geom_line(linetype="dashed") +
  theme_bw() +
  scale_color_manual(values = c("#FC0FE9", "cornflowerblue"))+
  theme(legend.position = c(0.8,0.2)) +
  labs(x= "", y="Weighted Average Health Rating: Natheal", color = "") +
  geom_errorbar(aes(ymin = (natheal_w_av_sex -1.96*se_natheal), 
                    ymax = (natheal_w_av_sex + 1.96*se_natheal)), width = 0.4)
ggsave("figs/wav-natheal-by-sex.png")
  

ggplot(health_df_by_sex, aes(x=year, y=nathealy_w_av_sex, color=sex_factor)) +
  geom_point() + geom_line(linetype="dashed") +
  theme_bw() +
  scale_color_manual(values = c("#FC0FE9", "cornflowerblue"))+
  theme(legend.position = c(0.2,0.2)) +
  labs(x= "", y="Weighted Average Health Rating: Nathealy", color = "") +
  geom_errorbar(aes(ymin = (nathealy_w_av_sex -1.96*se_nathealy), 
                    ymax = (nathealy_w_av_sex + 1.96*se_nathealy)), width = 0.4)
ggsave("figs/wav-nathealy-by-sex.png")


ggplot(health_df_by_sex, aes(x=year, y=happy_w_av_sex, color=sex_factor)) +
  geom_point() + geom_line(linetype="dashed") +
  theme_bw() +
  scale_color_manual(values = c("#FC0FE9", "cornflowerblue"))+
  theme(legend.position = c(0.8,0.8)) +
  labs(x= "", y="Weighted Average Health Rating: Happy", color = "") +
  geom_errorbar(aes(ymin = (happy_w_av_sex -1.96*se_happy), 
                    ymax = (happy_w_av_sex + 1.96*se_happy)), width = 0.4)
ggsave("figs/wav-happy-by-sex.png")


ggplot(health_df_by_sex, aes(x=year, y=health_w_av_sex, color=sex_factor)) +
  geom_point() + geom_line(linetype="dashed") +
  theme_bw() +
  scale_color_manual(values = c("#FC0FE9", "cornflowerblue"))+
  theme(legend.position = c(0.8,0.15)) +
  labs(x= "", y="Weighted Average Health Rating: Health", color = "") +
  geom_errorbar(aes(ymin = (health_w_av_sex -1.96*se_health), 
                    ymax = (health_w_av_sex + 1.96*se_health)), width = 0.4)
ggsave("figs/wav-health-by-sex.png")


