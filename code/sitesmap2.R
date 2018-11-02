# sitesmap2.R
# An interactive web map using the R leaflet package.

library(leaflet)
library(maps)
library(htmlwidgets) # To save the map as a web page.

# The data to map.
sites <- read.csv("https://richardlent.github.io/rnotebooks/sites.csv")

# State boundaries from the maps package. The fill option must be TRUE.
bounds <- map('state', c('Massachusetts', 'Vermont', 'New Hampshire'), fill=TRUE)

# A custom icon.
icons <- awesomeIcons(
    icon = 'disc',
    iconColor = 'black',
    library = 'ion', # Options are 'glyphicon', 'fa', 'ion'.
    markerColor = 'blue',
    squareMarker = FALSE
)

map <- leaflet(data = sites) %>%
    addTiles(group = "OpenStreetMap") %>% # Adds default OpenStreetMap base map.
    addProviderTiles("CartoDB.Positron", group = "Grey Scale") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satellite") %>% 
    addProviderTiles("Esri.WorldShadedRelief", group = "Relief") %>%
    addProviderTiles("Stamen.Watercolor", group = "Other") %>%
    addMarkers(~lon_dd, ~lat_dd, label = ~locality,
             popup = "<img src='https://richardlent.github.io/img/willie.png' height='149' width='112'>",
             group = "Sites") %>%
    # addAwesomeMarkers(~lon_dd, ~lat_dd, label = ~locality, 
    #          popup = "<a href='https://www.rstudio.com/'>RStudio</a>", 
    #          group = "Sites", icon=icons) %>%
    addPolygons(data=bounds, group="States", weight=3.5, fillOpacity = 0) %>%
    addLayersControl(
        baseGroups = c("OpenStreetMap", "Grey Scale", "Satellite", "Relief", "Other"),
        overlayGroups = c("Sites", "States"),
        options = layersControlOptions(collapsed = FALSE)
    )

print(map)
saveWidget(map, file="sitesmap2.html", selfcontained=TRUE)
