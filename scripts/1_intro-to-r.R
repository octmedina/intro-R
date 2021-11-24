# R training script!

# For this training, we'll be using these two packages, so you'll have to install them.
# Feel free to do this ahead of time.

# Packages only have to be installed once in a computer. Once they're installed, you can 
# call them using library(mypackage)

# The tidyverse package includes a bunch of data wrangling and plotting functions
install.packages("tidyverse")
# The gapminder package contains the data we'll be using for the training
install.packages("gapminder")
                                                                         

# Ok great, let's load the packages!                                         
library(tidyverse)
library(gapminder)

# SECTION 1: DATA STRUCTURES

# 1.1 Let's start with VECTORS.
# You can create a vector by using the assignment operator

my_letters <- c("a", "b", "c")
my_numbers <- c(1,2,3)

# Now let's see what happens if we mix types
all_mixed <-c("a", 2, "b", 3)
# That's right, they're all characters now.

# ------------Reference: You can  subset vectors----------------
my_letters[1]
# --------------------------------------------------------------

# 1.2 DATA FRAMES: the main type of dataset we'll be using

# A dataframe is the kind of data you would see in a spreadsheet or
# Stata dataset. It's rectangular in nature, with variables organized vertically,
# and observations organized horizontally.

# If you think about it, data frames are just a bunch of vectors organized vertically!

# Let's organize our sheep. We can create vectors
sheep_name <- c("Molly", "Polly", "Dolly")
sheep_weight <- c(120, 90, 85)
sheep_age <- c(3,4,2)

# And then put them all in a dataframe
my_sheep <- data.frame(sheep_name, sheep_weight, sheep_age)

# Try printing it out
my_sheep

# ------------Reference: You can also subset dataframes----------------
my_sheep[1,] # Gives you the first observation
my_sheep[,1] # Gives you the first column
my_sheep$sheep_name # You can also subset by name
mean(my_sheep$sheep_weight) # Note you can start playing around with functions
# --------------------------------------------------------------------

# 2. IMPORTING AND WRANGLING DATA

# For our training, we'll just use the gapminder dataset, which we can call 
# using data(gapminder), since it's already installed with the package.

data(gapminder) # This loads the data stored in a package  into our environment


head(gapminder) # First 6 rows

summary(gapminder) # Summary of the variables

table(gapminder$continent) # Similar to Stata's tab

# ------------Reference: Use the read_* family to read in data ----------------
# We don't have time to cover this in the training, so here's some examples of
# how to read in data.

# There's many kinds of read_* functions depending on the data you're interested in.
# read_csv() reads in CSVs
# 
# read_dta() reads in Stata files (you'll need to install the haven package)
# read_sav() reads in SPSS, read_sas() reads in SAS, etc etc

# You can read in data from an online dataset. Try running this:
my_penguins <- read_csv("https://raw.githubusercontent.com/allisonhorst/palmerpenguins/master/inst/extdata/penguins.csv")

# You can read in data from a file in your computer
# my_data <- read_excel("my_file.xlsx") # Remember to find the path to your file
# -----------------------------------------------------------------------------

# 2.1 THE TIDYVERSE WRANGLING VERBS

# ------------Reference: The verbs you'll most likely need ----------------
#select() to select variables you want to work with
#filter() to filter observations
#mutate() to create or modify variables
#arrange() to order your data
#summarize() to create data summaries (think collapse in Stata. e.g. mean, median, sd,count, etc)
#group_by() to group your data by relevant grouping variables. Most useful with summarize
# -----------------------------------------------------------------------------

# Select three variables and see the result
df_redux <- select(gapminder, country, year, lifeExp)

head(df_redux) # Limits output to 6

# Now let's try using filter(). You can filter by any condition! Here we'll filter by year and country.
df_filtered <- filter(gapminder, year == 1957, country == "Belgium")

df_filtered

# But we would like to avoid saving a ton of intermediate datasets
# Enter the pipe. Use it to chain operations.
gapminder %>% # Think of the pipe as an "and then..."
  filter(continent == "Oceania", year == 2007) %>%
  select(continent, country, lifeExp)


# ------------Reference: select() and filter() ----------------

# Select by column name:
gapminder %>%
  select(country)

# Select by column position:
gapminder %>%
  select(1:2)

# Select all columns except the first:
gapminder %>%
  select(-1)

# Filter using multiple expressions with a comma, or `&`:
gapminder %>%
  filter(continent == "Europe" & year == 2007)


# Use the | operator when you want either-or filtering:
gapminder %>%
  filter(continent == "Europe" | continent == "Americas")

#An exclamation point negates something. So to keep all **non-missing observations** you can do:
gapminder %>%
  filter(!is.na(continent))
# -----------------------------------------------------------------

# Let's mutate stuff. Mutate lets you create and modify variables
# It's sort of like gen and egen in Stata

df_gdp <- gapminder %>%
  mutate(gdp = pop * gdpPercap)

head(df_gdp) # The number is huge!

df_gdp <- df_gdp %>%
  mutate(gdp_million = gdp / 1000000,
         gdp_log = log(gdp))

head(df_gdp)

# Arrange dataframes to order your data!

gapminder %>%
  filter(year == 1957) %>%
  arrange(lifeExp) %>%
  head(3) # You can use head to restrict the output to any number of observations

gapminder %>%
  filter(year == 1957) %>%
  arrange(desc(lifeExp)) %>% # Now in descending order
  head(3)

# Create summaries of your data using summarize()

gapminder %>%
  filter(year == 2007) %>%
  summarize(exp_mean = mean(lifeExp),
            exp_median = median(lifeExp),
            exp_sd = sd(lifeExp))

# Combine this with group_by to get grouped summaries

gapminder %>%
  group_by(continent) %>%
  summarize(exp_mean = mean(lifeExp),
            gdp_mean = mean(gdpPercap))

# ------------Reference: grouping, mutating, and summarizing ----------------

# Some of the most common data summaries are:

# mean(), 
# median(), 
# n() for the number of observations
# sd() for standard deviation
# max() and min()

gapminder %>%
  summarize(my_count = n())

# When looking at some of these, keep in mind that you may have missing values.
# If you want R to ignore missing values when calculating summary stats like the mean,
# add na.rm = TRUE to your call. This will remove missing observations.
gapminder %>%
  summarize(my_mean = mean(gdpPercap, na.rm = TRUE))

# Remember that you can use the pipe %>% to speed up your analysis

# -----------------------------------------------------------------

# EXERCISE: Putting it all together
# Can you find what was the mean and median GDP per capita (as well as the number of obs!) 
# for each of the continents in 1982?
#

# Your answer:
# -------



# -------


#### Bonus track: regression!! #### 

# Let's explore the relationship between life expectancy and gdp per capita
# Use `lm` to run a linear model and `glm` to run a logit 
# (that stands for Generalized Linear Model). These generate an object you can then save.  

df_1982 <- gapminder %>%
  filter(year == 1982)

my_ols <- lm(lifeExp ~ log(gdpPercap), data = df_1982)

#my_logit <- glm(outcome ~ predictor, data = mydata, family = "binomial")

summary(my_ols) # Use summary to look at your regression results! 
# Remember this is an object, so you can use it later on if needeed (see extra bonus)

### Exercise at your own pace: ###
# Try including population and continent as variables in the regression
# Does that change much?

### Extra bonus: turn the results into a dataframe ###
# Turning objects into dataframes is very useful because it allows you to do extra
# things with the objects (for example, plotting them!)


# Install broom
install.packages("broom")
# Call the library
library(broom)

# Tidy my model to turn it into a nice data frame
my_tidy_ols <- tidy(my_ols)

# Glance at it to get basic info from your model as a data frame
glance(my_ols)


### Extra extra bonus: plot it ###
my_tidy_ols %>%
  ggplot(aes(x = estimate,
             y = term)) + 
  geom_point()



