library(tidyverse)
library(haven)

df <- read_dta("GSS_stata/gss7222_r4.dta") %>%
  select(NATHEAL, NATHEALY, HEALTH, RACE, RELIG, SEXORNT,
         SEXNOW1,)