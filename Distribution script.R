##GIS project
#distribution of African penguin colonies across False Bay

##Title/question: What is the distribution of African penguin colonies across false bay
##editor: meghan
##Version: pdf

##install and load libs

library(rinat)#retrieve the data from INAT
library(sf)##make spatial object
library(leafpop)
##add a baselayer to the plot
library(rosm)
library(ggspatial)
library(prettymapr)
##generates interactive maps
library(leaflet)
library(htmltools)
##common sense check 
library(mapview)##handles layers and legends
library(leafpop)

#Call the data directly from iNat
peng <- get_inat_obs(taxon_name = "African penguin",
                   bounds = c(-35.2, 16.3, -30.5, 24),
                   maxresults = 1000)
head(peng)
names(peng)

##filter to get quality grade research
peng <- peng %>% filter(positional_accuracy<46 & 
                      latitude<0 &
                      !is.na(latitude) &
                      captive_cultivated == "false" &
                      quality_grade == "research")

##double check the data frames crs
st_crs(peng)##4326

#make the penguin data frame a spacial object of class sf
peng <- st_as_sf(peng, coords = c("longitude", "latitude"), crs = 4326)

class(peng)
names(peng)
##plot the basic points inside the bounds
ggplot() + geom_sf(data=peng)

##add a basemap to see more of the coastline and features
ggplot() + 
  annotation_map_tile(type = "thunderforestoutdoors", progress = "none") + 
  geom_sf(data=peng)

rosm::osm.types()##tyes of baselayer maps

##generate an interactive map
leaflet() %>%
  # Add default OpenStreetMap map tiles
  addTiles(group = "Default") %>%  
  # Add our points
  addCircleMarkers(data = peng,
                   group = "African Penguin",
                   radius = 3, 
                   color = "purple") 
##do a common sense check on the data to make sure that it is legitemate sightings
##cause it was taken from INat
mapview(peng, 
        popup = 
          popupTable(peng,
                     zcol = c("user_login", "captive_cultivated", "url")))
##make live links
lpeng <- peng %>%
  mutate(click_url = paste("<b><a href='", url, "'>Link to iNat observation</a></b>"))

mapview(peng, 
        popup = 
          popupTable(lpeng,
                     zcol = c("user_login", "captive_cultivated", "click_url")))

##overlay caracal  sightings data

##draw caracal data from INat
cara <- get_inat_obs(taxon_name = "Caracal",
                     bounds = c(-35.2, 16.3, -30.5, 24),
                     maxresults = 1000)
#filter, shape and sort out caracal data from INat
cara <- cara %>% filter(positional_accuracy<46 & 
                          latitude<0 &
                          !is.na(latitude) &
                          captive_cultivated == "false" &
                          quality_grade == "research")

##double check the data frames crs
st_crs(cara)##4326 same as peng

#make the penguin data frame a spacial object of class sf
cara <- st_as_sf(cara, coords = c("longitude", "latitude"), crs = 4326)

##attempt to intersect the two maps
hmm <- st_intersection(peng, cara)

pengcar <- st_transform(peng, st_crs(cara)) 
dim(map)

##overlap
library(dplyr)

peng$type <- "African Penguins"
cara$type <- "Caracals"

pc <- rbind(peng, cara)

ggplot(combined) +
  geom_sf(aes(color = type), alpha = 0.7) +
  theme_minimal()## created an overlayed plot
##code for base layer of intersepted plot

leaflet() %>%
  # Add default OpenStreetMap map tiles
  addTiles(group = "Default") %>%  
  # Add our points
  addCircleMarkers(data = peng,
                   group = "African Penguin",
                   radius = 3, 
                   color = "purple") %>%
  # Cara points
  addCircleMarkers(data = cara,
                   group = "Cara",
                   radius = 3,
                   color = "orange",
                   fillOpacity = 0.7) %>%
  addLayersControl(
    overlayGroups = c("African Penguin", "Cara"),
    options = layersControlOptions(collapsed = FALSE)
  )  ##this adds a layer so that you can toggle the two species on and off

##filter the caracal pts so that they are not in the ocean or lakes, ie. more plausable
# Load land polygons for South Africa
sa_land <- ne_countries(scale = "medium", country = "South Africa", returnclass = "sf")

# Convert your caracal data to sf points
cara_sf <- st_as_sf(cara, coords = c("lon", "lat"), crs = 4326)

# Filter points that intersect with land
cara_on_land <- cara_sf[st_intersects(cara_sf, sa_land, sparse = FALSE), ]
##intersect and filter 
ggplot() + 
  annotation_map_tile(type = "osm", progress = "none") + 
  geom_sf(data = , colour = "blue") +
  geom_sf(data=bs)

##colour circles 
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = peng, color = "orange", radius = 3, label = "African Penguin") %>%
  addCircleMarkers(data = cara_on_land, color = "lightgreen", radius = 3, label = "Caracal")


mapview(peng, 
        popup = 
          popupTable(peng,
                     zcol = c("user_login", "captive_cultivated", "url")))

# Create mapview objects for each species with different colors
mp_peng <- mapview(peng,
                   col.regions = "lightgreen",
                   popup = popupTable(peng, zcol = c("user_login", "captive_cultivated", "click_url")),
                   layer.name = "Penguins")

mp_cara <- mapview(cara_on_land,
                   col.regions = "orange",
                   popup = popupTable(cara_on_land, zcol = c("user_login", "captive_cultivated", "click_url")),
                   layer.name = "Caracals")

# Combine layers into a single interactive map
mp_peng + mp_cara

###make interactive map with clickable URL groups
#Load South Africa land polygons 
sa_land <- ne_countries(scale = "medium", country = "South Africa", returnclass = "sf")

##Convert your data to sf points again to ensure they are in the same crs 
peng <- st_as_sf(peng, coords = c("lon", "lat"), crs = 4326)
cara <- st_as_sf(cara, coords = c("lon", "lat"), crs = 4326)

#Filter to keep only the caracal pts recorded on land as INat sourced data has a few ocean sightings which would make no sense
cara <- cara[st_intersects(cara, sa_land, sparse = FALSE), ]

##Add clickable URL popups for both peng and cara
peng <- peng %>%
  mutate(click_url = paste0("<b><a href='", url, "'>Link to iNat observation</a></b>"))

cara <- cara %>%
  mutate(click_url = paste0("<b><a href='", url, "'>Link to iNat observation</a></b>"))
mp_peng <- mapview(peng,
                   col.regions = "lightgreen",
                   popup = popupTable(peng, zcol = c("user_login", "captive_cultivated", "click_url")),
                   layer.name = "African Penguins")

mp_cara <- mapview(cara,
                   col.regions = "orange",
                   popup = popupTable(cara, zcol = c("user_login", "captive_cultivated", "click_url")),
                   layer.name = "Caracals")

##Combine the layers
mp_peng + mp_cara##Final map with legend and open street map view
