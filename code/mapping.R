library(rgdal)
library(dplyr)
library(leaflet)
library(ggplot2)
library(broom)
library(readr)

#Loading in data
local_authorities <- rgdal::readOGR("data/local_authority_simplified.json")
la_data <- read_csv("data/demo.csv")

#tidy into tibble, force names back on
dataframe_map <- tidy(local_authorities) %>% 
  mutate(id = as.numeric(id) + 1) %>%
    left_join(tibble(id = 1:32,
                     la_name = local_authorities@data$local_authority,
                     la_code = local_authorities@data$code))

#Map
dataframe_map %>%
  left_join(la_data, by= c("la_code" = "la_code")) %>%
  ggplot(aes( x = long, y = lat, group = group, fill = value)) +
  geom_polygon(colour = "black") +
  scale_fill_gradient(low = "#efedf5", high = "#252ba1",na.value = "grey40",
                      name = "Name of measure") +
  coord_equal() +
  theme_void()

ggsave("graphs/la_map.png", width = 4, height = 4)
