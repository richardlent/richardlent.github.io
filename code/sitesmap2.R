# sitesmap2.R
# Map the sites data using the leaflet package.
# This creates a prettier, interactive map.

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
    # setView(-72.14600, 43.82977, zoom = 8) %>%
    addTiles(group = "OpenStreetMap") %>% # Adds default OpenStreetMap base map.
    addProviderTiles("CartoDB.Positron", group = "Grey Scale") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satellite") %>% 
    addProviderTiles("Esri.WorldShadedRelief", group = "Relief") %>%
    addMarkers(~lon_dd, ~lat_dd, label = ~locality, group = "Sites") %>% 
    # addAwesomeMarkers(~lon_dd, ~lat_dd, label = ~locality, group = "Sites", icon=icons) %>%
    addPolygons(data=bounds, group="States", weight=3.5, fillOpacity = 0) %>%
    addLayersControl(
        baseGroups = c("OpenStreetMap", "Grey Scale", "Satellite", "Relief"),
        overlayGroups = c("Sites", "States"),
        options = layersControlOptions(collapsed = FALSE)
    )

print(map)
saveWidget(map, file="sitesmap2.html", selfcontained=TRUE)
