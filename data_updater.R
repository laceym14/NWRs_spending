setwd("/home/jacobmalcom/open/ESA_intrastate")

library(digest)
library(rvest)

print(Sys.Date())

cur <- readRDS("state_occ.rds")
att1 <- try(
  pg <- read_html("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=htmltable&distinct=true&columns=%2fspecies%40cn%2csn%2cstatus%2cdesc%2clisting_date%3b%2fspecies%2frange_state%40name%3b%2fspecies%2ffws_region%40desc%3b%2fspecies%2ftaxonomy%40group%3b%2fspecies%2frange_state%40abbrev&sort=%2fspecies%40sn%20asc&filter=%2fspecies%40status%20in%20('endangered'%2c'threatened')&filter=%2fspecies%40country%20!%3d%20'foreign'")
)

if(class(att1) == "try-error") {
  att2 <- try(
    pg <- read_html("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=htmltable&distinct=true&columns=%2fspecies%40cn%2csn%2cstatus%2cdesc%2clisting_date%3b%2fspecies%2frange_state%40name%3b%2fspecies%2ffws_region%40desc%3b%2fspecies%2ftaxonomy%40group%3b%2fspecies%2frange_state%40abbrev&sort=%2fspecies%40sn%20asc&filter=%2fspecies%40status%20in%20('endangered'%2c'threatened')&filter=%2fspecies%40country%20!%3d%20'foreign'")
  )
}

if(exists("pg")) {
  new <- html_table(pg)[[1]]
  if(nrow(new) > 2000) {
    if(digest(cur) != digest(new)) {
      file.rename("state_occ.rds", paste0("state_occ_", Sys.Date(), ".rds"))
      saveRDS(new, "state_occ.rds")
      print("Updated data saved.")
    } else {
      print("No data changes.")
    }
  } else {
    print("Something is amiss, data aren't big enough.")
  }
} else {
  print("No data sent from FWS.")
}
