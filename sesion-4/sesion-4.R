

install.packages("mapSpain", dependencies = TRUE)

library(mapSpain)
library(tidyverse)
library(viridis)


# Si teneis un paquete muy grande y solo quereis una funcion
# podeis usar el nombre del paquete y ::
# tidyverse::select

census <- pobmun19


# Extract CCAA from base dataset

codelist <- esp_codelist

# Merge es join
# left_join (1), right_join (2), full_join (todo), inner_join (3)

t <- data.frame(name = c("Maria", "Elena", "Pere"))
t2 <- data.frame(name = c("Pere", "Cristina"))

t %>%
  left_join(t2)

t %>%
  inner_join(t2)

t2 %>%
  left_join(t)

t %>%
  full_join(t2)

t %>%
  anti_join(t2)

### MAPAS

# duplicates drop, force etc etc
code_redux <- codelist %>%
  select(cpro, ccaa.shortname.es) %>%
  distinct(cpro, ccaa.shortname.es)

census2 <- census %>%
  left_join(code_redux, by = "cpro")

census_rightjoin <- census %>%
  left_join(code_redux, by = "cpro")


# Summarize by CCAA
census_ccaa <- census2 %>%
  rename(ccaa = ccaa.shortname.es) %>%
  group_by(ccaa) %>%
  summarize(total_men = sum(men),
            total_women = sum(women),
            total = sum(pob19)) %>%
  mutate(share_women = round(100*total_women / total, 2))
  #mutate(share_women = 100*total_women / total)


# Merge into spatial data

CCAA_sf <- esp_get_ccaa() %>%
  rename(ccaa = ccaa.shortname.es)

CCAA_sf <- left_join(CCAA_sf, census_ccaa)


can <- esp_get_can_box()


# geom_sf es el geom para mapas
ggplot(CCAA_sf) +
  geom_sf(aes(fill = share_women))


##
ggplot(CCAA_sf) +
  geom_sf(aes(fill = share_women),
          color = "grey70",
          lwd = .3
  ) +
  geom_sf(data = can, color = "grey70") +
  geom_sf_label(aes(label = share_women),
                fill = "white", alpha = 0.5,
                size = 3,
                label.size = 0
  ) +
  scale_fill_gradientn(
    colors = hcl.colors(10, "Blues", rev = TRUE),
    n.breaks = 10,
    labels = function(x) {
      sprintf("%1.1f%%", x)
    },
    guide = guide_legend(title = "Porc. women")
  ) +
  theme_void() +
  theme(legend.position = c(0.1, 0.6))


##

ggplot(CCAA_sf) +
  geom_sf(aes(fill = share_women),
          color = "grey70",
          lwd = .3
  ) +
  geom_sf(data = can, color = "grey70") +
  geom_sf_label(aes(label = share_women),
                fill = "white", alpha = 0.5,
                size = 3,
                label.size = 0
  ) +
  scale_fill_viridis_c(option = "viridis", begin = 0.1, end = 0.9) +
  theme_void() +
  theme(legend.position = c(0.1, 0.6)) +
  labs(title = "Esto es el % de mujeres por CCAA")



# PROVINCIAS


# Summarize by CCAA
census_prov <- census2 %>%
  group_by(cpro) %>%
  summarize(total_men = sum(men),
            total_women = sum(women),
            total = sum(pob19)) %>%
  mutate(share_women = round(100*total_women / total, 2))

# Merge into spatial data

prov_sf <- esp_get_prov() 
prov_sf <- left_join(prov_sf, census_prov)
can <- esp_get_can_provinces()

ggplot(prov_sf) +
  geom_sf(aes(fill = share_women),
          color = "grey70",
          lwd = .3
  ) +
  geom_sf(data = can, color = "grey70") +
  geom_sf_label(aes(label = share_women),
                fill = "white", alpha = 0.5,
                size = 3,
                label.size = 0
  ) +
  scale_fill_gradientn(
    colors = hcl.colors(10, "Blues", rev = TRUE),
    n.breaks = 10,
    labels = function(x) {
      sprintf("%1.1f%%", x)
    },
    guide = guide_legend(title = "Porc. women")
  ) +
  theme_void() +
  theme(legend.position = c(0.1, 0.6))


