# global.R for moba
library(shinydashboard)

loldata<-read.delim("~/nycdsa/DataVisandExpl/PythonScrapper/moba/moba/spiders/LOL_moba_champs.txt",header = FALSE, stringsAsFactors = FALSE)
# add colum names
colnames(loldata)<-c("Champ","Alias","pos1","pickrate1","winrate1","pos2","pickrate2","winrate2","damage","toughness","cc","mobility","utility")

whoWins<- function(champ1,champ2){
  champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  
  statChamp1<- (sum(champ1data[,4:8])*champ1data$damage^2) * (as.integer(strsplit(champ1data$winrate1,"[%]")[[1]]))/100
  statChamp2<- (sum(champ2data[,4:8])*champ2data$damage^2) * (as.integer(strsplit(champ2data$winrate1,"[%]")[[1]]))/100
  
  if (statChamp1 > statChamp2){
    return (paste("The winner is: ",champ1))
  }else if (statChamp1 == statChamp2){
    return (paste("Both champs are equal. The winner would depend on farming and champ build"))
  }else{
    return (paste("The winner is: ",champ2))
  }
  
}

champStats<-function(champ1,champ2){
  champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  
  combo<-rbind(champ1data[,c(1,4:8)],champ2data[,c(1,4:8)])
  
  comboChart<-gvisColumnChart(combo,options=list(wdith="700",legend='bottom',colors="['#004949','#198989','#36A679','#E46B2A','#F48950']"))
  return (comboChart)
}

