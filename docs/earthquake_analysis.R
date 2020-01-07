library("ggplot2")
library("dplyr")
library(dplyr)
library(plotly)
library(stringr)
library(ggplot2)
library(tidyr)

df <- read.csv("quakes.csv")

# years plot- displays number of earthquakes happen each year
year <- df %>%
  mutate(year = as.numeric(substring(df$Date, 7, 11))) %>%
  group_by(year) %>%
  count()
offical_year <- year[complete.cases(year), ]

year_breakdown <- ggplot(offical_year, aes(x = year, y = n)) +
  scale_x_continuous(breaks = seq(1965, 2016, 5)) + 
  geom_line(group = 1) + labs(x = "year", y = "# of earthquakes",
                              title = "Number of Earthquakes every year",
                              caption = "(based on data from earthquake
                              database. which only counts significant
                              earthquakes that have a magnitude of 5.5
                              or higher.)")

# Map of earthquake locations
map <- list(
  scope = "world",
  showland = TRUE,
  landcolor = toRGB("gray95"),
  countrycolor = toRGB("black")
)

mapping <- plot_geo(df, lat = ~Latitude, lon = ~Longitude) %>%
add_markers(
  text = ~paste("Force: ", Magnitude),
  colors = c("yellow", "orange", "red", "red2", "red3"),
  color = ~Magnitude, symbol = I("circle"), hoverinfo = "text",
  marker = list(size = ~Magnitude)) %>%
  colorbar(title = "Magnitude") %>%
  layout(title = "Locations of Earthquakes", geo = map) 
