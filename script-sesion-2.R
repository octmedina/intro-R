# MI SCRIPT

library(tidyverse)
library(hrbrthemes)
library(viridis)


gap_82 <- gapminder %>% 
  filter(year == 1982) 

# Version completa

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap,
                      y = lifeExp)) +
  geom_point()

# Lienzo
ggplot(gap_82)

# Lienzo con ejes (y pipe)
gap_82 %>%
  ggplot(aes(gdpPercap, lifeExp))

# Lienzo con ejes
ggplot(gap_82, aes(gdpPercap, lifeExp))

# Cambiar colores
ggplot(gap_82, aes(gdpPercap, lifeExp)) +
  geom_point(color = '#00B2A9') +
  geom_smooth(color ='darkgrey')

gap_82 %>%
  mutate(log_gdp = log(gdpPercap)) %>%
  ggplot(aes(log_gdp, lifeExp, size = pop)) +
  geom_point(aes(color = continent)) +
  geom_smooth(method = 'loess')

# library(ggrepel)

gap_82 %>%
  filter(country %in% c("Portugal", "Spain", "Italy", "France", "Germany", "Greece")) %>%
  ggplot(aes(gdpPercap, lifeExp, label = country)) +
  geom_point(color = '#00B2A9') +
  geom_text_repel(color = '#00B2A9') 

# BARRAS

ggplot(gap_82,
      aes(x = continent)) + 
  geom_bar()

gap_82 %>%
  group_by(continent) %>%
  summarize(mean_exp = mean(lifeExp)) %>%
  ggplot(aes(x = mean_exp,
             y = continent)) + 
  geom_col()

gap_82 %>%
  group_by(continent) %>%
  summarize(mean_exp = mean(lifeExp)) %>%
  ggplot(aes(x = mean_exp,
             y = continent)) + 
  geom_col(fill = '#00B2A9', width = 0.5)

## HISTOGRAMA

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap)) +
  geom_histogram(bins = 20, color = 'white')

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, fill = continent)) +
  geom_histogram(bins = 20, color = 'white')

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, color = continent)) +
  geom_density()

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, fill = continent)) +
  geom_density(alpha = 0.3)


library(hrbrthemes)
library(viridis)

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, fill = continent)) +  
  geom_histogram() +
  labs(title = "Mi histograma guay",
       subtitle = "Países pobres y ricos variopintos",
       x = "PIB per capita",
       y = "Cantidad",
       caption = "Fuente: Gapminder, como todo",
       fill = "Continente"
       ) +
  #theme_ipsum() +
  #theme_ipsum_pub() +
  theme_ft_rc() +
  scale_fill_viridis_d() + 
  theme(plot.title.position = "plot")

## FACETS

ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, y = lifeExp, color = continent)) +  
  geom_point() +
  labs(title = "Mi scatterplot guay",
       subtitle = "Países pobres y ricos variopintos",
       x = "PIB per capita",
       y = "Esperanza de vida",
       caption = "Fuente: Gapminder, como todo",
       color = "Continente"
  ) +
  theme_ipsum() +
  facet_wrap(~continent, ncol = 5) +
  #scale_color_viridis_d() +
  scale_color_viridis_d(option = 'plasma') +
  theme(plot.title.position = "plot")



library(patchwork)


p1 <- ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, y = lifeExp, color = continent)) +  
  geom_point() +
  labs(title = "Mi scatterplot guay",
       subtitle = "Países pobres y ricos variopintos",
       x = "PIB per capita",
       y = "Esperanza de vida",
       caption = "Fuente: Gapminder, como todo",
       color = "Continente"
  ) +
  theme_ipsum() +
  facet_wrap(~continent, ncol = 5) +
  #scale_color_viridis_d() +
  scale_color_viridis_d(option = 'viridis') +
  theme(plot.title.position = "plot")


p2 <- ggplot(data = gap_82,
       mapping =  aes(x = gdpPercap, y = lifeExp, color = continent)) +  
  geom_point() +
  labs(title = "Mi scatterplot guay",
       subtitle = "Países pobres y ricos variopintos",
       x = "PIB per capita",
       y = "Esperanza de vida",
       caption = "Fuente: Gapminder, como todo",
       color = "Continente"
  ) +
  theme_ipsum() +
  facet_wrap(~continent, ncol = 5) +
  #scale_color_viridis_d() +
  scale_color_viridis_d(option = 'plasma') +
  theme(plot.title.position = "plot")

p1 / p2

ggsave("migrafico.png")








