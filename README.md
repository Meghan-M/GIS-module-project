Questions: How much does the distibution of caracal and penguins overlap along the western cape coast?

Author: Meghan miehe

Date: 03/03/2026

There has been a history of predation by Caracals on African penguin colonies in the Western Cape, some allegedly killing over 100 penguins. As African penguins have low population numbers already, it would be largely detrimental to their future success to have death rates of such a high number. Hence it would be useful for conservationists to be able to see the overlap in Caracal and penguin distribution to aid protection of the African Penguin colonies where necessary. 
This study aims to map the distribution of African penguins along the Western cape coastline, and through overlaying Caracal sightings in the same region, determine whether these two species' distributions overlap.
The data for both species ditributions were extracted from INaturalist, using the code chunks seen the 'Data wrangling scripts' folder. Following extraction, the data was filtered for quality grade research, then formatted into an shape file of class sf, after checking the crs. An interactive map was then plotted for African penguins with a clickable URL link for each point. The Caracal data was then overlayed ensuring the same crs and parameters for both data sets. The Caracal data was filtered to ensure only sightings on land were shown, excluding points in the ocean or lakes. Caracal sightings were coloured orange and penguins lightgreen. 

Output: An overlayed interactive map with clickable URL links to INaturalist and a legend for easy identification of species. 

Code: Packages used were as follows.
library(rinat)## to retrieve the data from INAT.
library(sf) ##for making spatial object
library(leafpop)

##add a baselayer to the plot
library(rosm)
library(ggspatial)
library(prettymapr)

##generates interactive maps
library(leaflet)
library(htmltools)

##common sense checks
library(mapview)##handles layers and legends
library(leafpop)

