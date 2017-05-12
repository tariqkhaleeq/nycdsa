# global.R for moba
library(shinydashboard)

loldata<-read.delim("~/nycdsa/DataVisandExpl/PythonScrapper/moba/moba/spiders/LOL_moba_champs.txt",header = FALSE, stringsAsFactors = FALSE)
# add colum names
colnames(loldata)<-c("Champ","Alias","pos1","pickrate1","winrate1","pos2","pickrate2","winrate2","damage","toughness","cc","mobility","utility")

