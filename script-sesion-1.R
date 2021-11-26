
# Este es un do file un poco raritto

library(tidyverse)
library(gapminder)

mi_anyo <- 2021

a <- 45
b <- 57

c <- a + b

mi_nombre <- "KSNET"

## Vector de letras

mis_letras <- c("a", "b", "c")
mis_letras 

mis_numeros <- c(1, 2, 3)

all_mixed <- c("a", 2, "b", 3)

oveja_nombre <- c("Molly", "Polly", "Dolly" )

oveja_peso <- c(120, 90, NA)

oveja_edad <- c(3,4,2)

mis_ovejas <- data.frame(oveja_nombre, oveja_peso, oveja_edad)


library(haven)

# read_dta("mi_stata.dta")
# read_sav
# read_sas

# read_csv 

# write_dta
# write_sav


merkel <- read_csv("https://raw.githubusercontent.com/octmedina/zi-ordinal/main/merkel_data.csv")

a <- c(1,2,3)
b <- c(2,3,4)

a*b

#
library(gapminder)

data(gapminder)


head(gapminder)
head(gapminder, 20)

summary(gapminder)

# library(skimr)
# library(janitor)

summary(gapminder$country)
table(gapminder$country)

table(gapminder$country, gapminder$continent)

# SELECT

df_redux <- select(gapminder, country, year, lifeExp)

head(df_redux)

# FILTER

df_filtered <- filter(df_redux, year == 1957, country == "Belgium")

my_table <- gapminder %>%
  filter(year == 1957, continent == "Europe") %>%
  select(-continent, -pop) 

my_table <- gapminder %>%
  filter(year == 1957, continent == "Europe") %>%
  select(-c(continent, pop, lifeExp)) 


# Mutate

df_gdp <- gapminder %>%
  transmute(gdp = pop * gdpPercap, country)

df_gdp <- gapminder %>%
  mutate(gdp = pop * gdpPercap)

df_gdp <- mutate(gapminder, gdp = pop * gdpPercap)


# library(tidylog)

df_gdp <- df_gdp %>%
  mutate(gdp = gdp / 1000000, 
         gdp_log = log(gdp),
         life_sqrt = sqrt(lifeExp)) %>%
  filter(continent == "Europe")


gapminder %>%
  mutate(africa = if_else(continent == "Africa", 1, 0),
         europe = if_else(continent == "Europe", 1, 0))


## Arrange

gapminder %>%
  filter(year == 1957) %>%
  arrange(lifeExp) %>%
  head(3) # esto no te va a afectar el resultado


# library(datapasta)



#00B2A9

summ_stats <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(exp_mean = mean(lifeExp),
            exp_median = median(lifeExp),
            exp_sd = sd(lifeExp))

## gt::gt(summ_stats) %>% gtExtras::gt_theme_538() 


# REGRESIONESSS

df_regression <- gapminder %>%
  filter(year == 1982) %>%
  mutate(africa = if_else(continent == "Africa", 1, 0),
         europe = if_else(continent == "Europe", 1, 0),
         americas = if_else(continent == "Americas", 1, 0))

my_ols <- lm(lifeExp ~ log(gdpPercap) , data = df_regression)
my_logit <- glm(africa ~ log(gdpPercap), data = df_regression)

# fixest

summary(my_logit)
summary(my_ols)



## Ver un dataframe
# alt gr 4 para ~, alt guion para asignacion

library(broom)

my_table <- tidy(my_ols)

my_table

#Library(gt)
#gt(my_table)

library(modelsummary)

install.packages("gt")

modelsummary(my_ols,
             estimate = "{estimate}{stars}",
             gof_omit = ".*",
             output = "gt")

my_ols2 <- lm(lifeExp ~ log(gdpPercap) + africa + europe + americas, data = df_regression)
my_ols3 <- lm(lifeExp ~ log(gdpPercap) + africa + europe + americas + log(pop), data = df_regression)

all_models <- list(Simple = my_ols,
                   Continente = my_ols2,
                   Población = my_ols3)

modelsummary(all_models,
            estimate = "{estimate}{stars}", 
            output = "gt",
            gof_omit = ".*"
            )















