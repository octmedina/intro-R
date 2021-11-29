

install.packages("mapSpain", dependencies = TRUE)

library(mapSpain)
library(tidyverse)
#library(palmerpenguins)
library(hrbrthemes)
library(viridis)



census <- mapSpain::pobmun19

# Extract CCAA from base dataset

codelist <- mapSpain::esp_codelist


census <- census %>%
  left_join(select(codelist, cpro, ccaa.shortname.es), by = c("cpro"))


# Summarize by CCAA
census_ccaa <- census %>%
  rename(ccaa = ccaa.shortname.es) %>%
  group_by(ccaa) %>%
  summarize(total_men = sum(men),
            total_women = sum(women),
            total = sum(pob19)) %>%
  mutate(share_women = round(100*total_women / total, 2))

# Merge into spatial data

CCAA_sf <- esp_get_ccaa() %>%
  rename(ccaa = ccaa.shortname.es)
CCAA_sf <- left_join(CCAA_sf, census_ccaa)
can <- esp_get_can_box()


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


# PROVINCIAS


# Summarize by CCAA
census_prov <- census %>%
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


