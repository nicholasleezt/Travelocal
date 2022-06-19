##Set URLdirectory and Read CSV into "HotSpots"
rm(list=ls())


url <- "data/hotosm_original_file.csv"
hotosm<-read.csv(url)

library(readr)
library(shiny) #For Rshiny app
library(shinydashboard)
library(shinyjs)
library(leaflet) #For Open Streetmap
library(data.table) #For dataframe table
library(dplyr)
library(sp)
library(rgdal)
library(stringi) #For data cleaning and identifying new strings
library(shinyWidgets)
library(maps)

#**DATA CLEANING**

hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('tyres', 'truck', 'Spares_parts_shop'),
                                                 replacement=c('car', 'car', 'car'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('coffeeshop', 'coffee', 'beverages','tea','pastry'),
                                                 replacement=c('cafe', 'cafe', 'cafe','cafe','cafe'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('gallery', 'paint'),
                                                 replacement=c('art', 'art'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('chocholate', 'kiosk', 'money_transfer','bridal','Wedding_Services'),
                                                 replacement=c('confectionary', 'atm', 'atm','wedding_services','wedding_services'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('computer', 'cosmetics', 'chemist','appliance','shower'),
                                                 replacement=c('electronics', 'beauty', 'beauty','electrical','toilets'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('dry_cleaning', 'pawnbroker', 'second_hand'),
                                                 replacement=c('laundry', 'pawn', 'pawn'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('sewing_workshop', 'tailor', 'viewpoint'),
                                                 replacement=c('sewing', 'sewing', 'riverview'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('veterinary', 'pet_grooming', 'coworking_space'),
                                                 replacement=c('pet', 'pet', 'office'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('funeral_directors', 'grave_yard', 'religion'),
                                                 replacement=c('cemetary', 'cemetary', 'place_of_worship'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('conference_centre', 'Beach', 'weighbridge','bookmaker','public_bookcase','Tuition_Centre','mobile_phone','telephone','post_depot'),
                                                 replacement=c('events_venue', 'attraction', 'attraction','books','books','school','telecommunication','telecommunication','post_box'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('frame', 'photo','doctors','dentist','health','picnic_site','camp_pitch','caravan_site','city','commercial_Building','communication'),
                                                 replacement=c('camera', 'camera','clinic','clinic','clinic','camp_site','camp_site','camp_site','townhall','commercial_building','community_centre'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('nightclub', 'party', 'swingerclub','bar','Chinese_Medical_& Herb','hearing_aids','nutrition_supplements','medical_supply'),
                                                 replacement=c('club', 'pub', 'club','pub','herbalist','pharmacy','pharmacy','pharmacy'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('alpine_hut', 'chalet','hotel','wilderness_hut','clothes','bag','shoes','closet','ice_cream','classroom'),
                                                 replacement=c('resort', 'resort', 'resort', 'resort','boutique','boutique','boutique','boutique','desert','school'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('social_facility', 'snooker_&_billiard_equipment_&_supplies','Manufacture_of_ICT_Infrastructure Equipment','Factory'),
                                                 replacement=c('social_centre', 'social_centre','factory','factory'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('bed', 'bathroom_furnishing','furniture','gate','Tiles_Distributor','window_blind','curtain','carpet','interior_decoration'),
                                                 replacement=c('home_furnishing','home_furnishing','home_furnishing','home_furnishing','home_furnishing','home_furnishing','home_furnishing','home_furnishing','home_furnishing'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('deli', 'food','food_court','bbq','seafood','health_food','biergarten'),
                                                 replacement=c('restaurant', 'restaurant', 'restaurant', 'restaurant', 'restaurant', 'restaurant', 'restaurant'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('data_room'),
                                                 replacement=c('information'),
                                                 vectorize=FALSE)

hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('data_room'),
                                                 replacement=c('information'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('bakery_ingredients', 'bicycle_parking', 'bicycle_rental','parking_entrance','parking_space','water_filter','water','drinking_water'),
                                                 replacement=c('bakery', 'parking', 'bicycle','parking','parking','water_point','water_point','water_point'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('Muzium','hairdresser;tailor','wet_market','greengrocer','Online_Gift','gift'),
                                                 replacement=c('museum','hairdresser','marketplace','grocery','souvenir','souvenir'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('artwork','arts_centre','artwork;attraction','coffee','coffeeshop','office/building','office_factory'),
                                                 replacement=c('art','art','art','cafe','cafe','office','office'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('language_school','prep_school','swimming_school','driving_school','music_school'),
                                                 replacement=c('school','school','school','school','school'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('Motor_Cycle_Repair','motorcycle_parking','motorcycle_parts','motorcycle_repair'),
                                                 replacement=c('motorcycle','motorcycle','motorcycle','motorcycle'),
                                                 vectorize=FALSE)
hotosm$amenity_derived <- stri_replace_all_regex(hotosm$amenity_derived,
                                                 pattern=c('car_parts','car_accessories','car_rental','car_wash','car_repair'),
                                                 replacement=c('car','car','car','car','car'),
                                                 vectorize=FALSE)

###New Column to identify West or East Malaysia
hotosm$ew[hotosm$coords.x1 > 108] <- "em"
hotosm$ew[hotosm$coords.x1 < 108] <- "wm"


##Set Dataframe
df<-data.frame(cbind(hotosm[,"name"],hotosm[,"amenity_derived"]
                     ,hotosm[,"coords.x1"],hotosm[,"coords.x2"],hotosm[,"ew"]))
##Set Names
setnames(df,c("Place_Name","Amenity","long","lat","EastORWest"))

##Check Unique Amenity
UniqueAmenity<-unique(df[,"Amenity"])

##Set Numerical for Longitude and Latitude of the Data Frame
df$long<-as.numeric(as.character(df$long))
df$lat<-as.numeric(as.character(df$lat))
sapply(df,class) ##Check Class for 5 Variables
