# scrapping data
library(dplyr)
library(ggplot2)
library(googleVis)

loldata<-read.delim("~/nycdsa/DataVisandExpl/PythonScrapper/moba/moba/spiders/LOL_moba_champs.txt",header = FALSE, stringsAsFactors = FALSE)
# add colum names
colnames(loldata)<-c("Champ","Alias","pos1","pickrate1","winrate1","pos2","pickrate2","winrate2","damage","toughness","cc","mobility","utility")

## How many champs can only play one role vs two

pos1only<-loldata %>% group_by(pos1) %>% summarise(Total=n())
pos1only[,1]<-c("ADC or Mage bottom champs","Jungle champs","Mid champs","Support champs","Top champs")
pos2only<-loldata %>% group_by(pos2) %>% summarise(Total=n())%>%filter(pos2!='-')
pos2only[,1]<-c("ADC or Mage bottom champs","Jungle champs","Mid champs","Support champs","Top champs")

Piepos1 <- gvisPieChart(pos1only,
                        options=list(width="1300",
                                     height="800",
                                     title = "Proportion of champs that can only play one position",
                                     size="large",
                                     colors = "['#ff8100','#ffa700','#91bfff','#5292ff','#4c6aff']"
                        )
)


plot(Piepos1)

Piepos2 <- gvisPieChart(pos2only,
                        options=list(width="1300",
                                     height="800",
                                     title = "Proportion of champs that can play two positions",
                                     size="large",
                                     colors = "['#cccccc','#5f47ff','#4951c5','#212140','#111121']"
                        )
)


plot(Piepos2)



pos1and2only<-loldata %>% group_by(pos1,pos2) %>% summarise(Total=n()) %>% filter(pos2!="-")
#pos1and2only[,1]<-c("ADC or Mage bottom champs","Jungle champs","Mid champs","Support champs","Top champs")


barpos1pos2<-ggplot(pos1and2only, aes(x=pos1,y=Total,fill=factor(pos2),width=0.5)) + geom_bar(stat = "identity") +
  xlab("Champs primary position") + 
  ylab("Number of champs with versitle positioning") + 
  scale_fill_discrete(name="Champs secondary role") +
  scale_fill_manual(values=c('#004949','#198989','#36A679','#E46B2A','#F48950'))

plot(barpos1pos2)

barpos1pos2<-ggplot(pos1and2only, aes(x=pos1,y=Total,fill=factor(pos2),width=0.5)) + geom_bar(stat = "identity", position ="dodge") +
  xlab("Champs primary position") + 
  ylab("Number of champs with versitle positioning") + 
  scale_fill_discrete(name="Champs secondary role") +
  scale_fill_manual(values=c('#004949','#198989','#36A679','#E46B2A','#F48950'))

plot(barpos1pos2)

## What is the pick rate for positional champs pos 1 and pos 2

pr<-loldata %>% group_by(Champ,pos1,pickrate1) %>% select(pos1,pickrate1)
pr[,3]<-as.integer(strsplit(unlist(pr[,3]),"[%]"))

pr2<-loldata %>% group_by(pos2,pickrate2) %>% select(pos2,pickrate2) %>% filter(pos2!='-')
pr2[,2]<-as.integer(strsplit(unlist(pr2[,2]),"[%]"))

#histogram or boxplot

#histogram
pickrate1<-ggplot(data=pr, aes(pickrate1)) + geom_histogram(breaks=seq(40, 100, by = 5), 
                                            aes(fill=..count..)) + 
                                  labs(title="Pick rate for position 1 in %") +
                                  labs(x="Pick rate 1", y="Count") + 
                                  xlim(c(50,100)) + 
                                  ylim(c(0,60)) +
                                  scale_fill_gradient("Count", low = "#004949", high = "#36A679")
plot(pickrate1)

pickrate2<-ggplot(data=pr2, aes(pickrate2)) + geom_histogram(breaks=seq(0, 50, by = 5), 
                                                 aes(fill=..count..)) + 
                                  labs(title="Pick rate for position 2 in %") +
                                  labs(x="Pick rate 2", y="Count") + 
                                  xlim(c(5,50)) + 
                                  ylim(c(0,15)) +
                                  scale_fill_gradient("Count", low = "#004949", high = "#36A679")

plot(pickrate2)

#boxplot
bp<-ggplot(pr,aes(pos1,pickrate1)) + geom_boxplot(fill = c('#004949','#198989','#36A679','#E46B2A','#F48950'))
plot(bp)

bp2<-ggplot(pr2,aes(pos2, pickrate2)) + geom_boxplot(fill = c('#004949','#198989','#36A679','#E46B2A','#F48950'))
plot(bp2)

## Win rate with respect to pickrate
pwr<-loldata %>% group_by(pos1,pickrate1,winrate1) %>% select(pos1,pickrate1,winrate1)
pwr[,2]<-as.integer(strsplit(unlist(pwr[,2]),"[%]"))
pwr[,3]<-as.integer(strsplit(unlist(pwr[,3]),"[%]"))

ggplot(loldata, aes(x=pos1,y=pickrate1)) + geom_tile(aes(fill=winrate1), colour = "white") 

pwr2<-loldata %>% group_by(pos2,pickrate2,winrate2) %>% filter(pos2!='-') %>% select(pos2,pickrate2,winrate2)
pwr2[,2]<-as.integer(strsplit(unlist(pwr2[,2]),"[%]"))
pwr2[,3]<-as.integer(strsplit(unlist(pwr2[,3]),"[%]"))

ggplot(pwr2, aes(x=pos2,y=pickrate2)) + geom_tile(aes(fill=winrate2)) 

#ggplot(loldata, aes(x=winrate1,y=pickrate1)) + geom_tile(aes(fill=pos1)) 

## Top 5 champs in each position and their win rates


### calculations for best champ

champ1<-loldata[23,1]
champ2<-loldata[55,1]

champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)

combo<-rbind(champ1data[,c(1,4:8)],champ2data[,c(1,4:8)])

comboChart<-gvisColumnChart(combo,options=list(legend='bottom',colors="['#004949','#198989','#36A679','#E46B2A','#F48950']"))
plot(comboChart)

statChamp1<- (sum(champ1data[,4:8])*champ1data$damage^2) * (as.integer(strsplit(champ1data$winrate1,"[%]")[[1]]))/100

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

thewinner<-whoWins(champ1,champ2)

champStats<-function(champ1,champ2){
  champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  
  combo<-rbind(champ1data[,c(1,4:8)],champ2data[,c(1,4:8)])
  
  comboChart<-gvisColumnChart(combo,options=list(legend='bottom',colors="['#004949','#198989','#36A679','#E46B2A','#F48950']"))
  return (comboChart)
}


### Team stats

champ1<-loldata[3,1]
champ2<-loldata[25,1]
champ3<-loldata[54,1]
champ4<-loldata[45,1]
champ5<-loldata[67,1]
ochamp1<-loldata[98,1]
ochamp2<-loldata[100,1]
ochamp3<-loldata[14,1]
ochamp4<-loldata[50,1]
ochamp5<-loldata[88,1]

champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
champ3data<-loldata %>% filter(Champ == champ3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
champ4data<-loldata %>% filter(Champ == champ4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
champ5data<-loldata %>% filter(Champ == champ5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
ochamp1data<-loldata %>% filter(Champ == ochamp1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
ochamp2data<-loldata %>% filter(Champ == ochamp2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
ochamp3data<-loldata %>% filter(Champ == ochamp3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
ochamp4data<-loldata %>% filter(Champ == ochamp4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
ochamp5data<-loldata %>% filter(Champ == ochamp5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)

statChamp1<- (sum(champ1data[,4:8])*champ1data$damage^2) * (as.integer(strsplit(champ1data$winrate1,"[%]")[[1]]))/100
statChamp2<- (sum(champ2data[,4:8])*champ2data$damage^2) * (as.integer(strsplit(champ2data$winrate1,"[%]")[[1]]))/100
statChamp3<- (sum(champ3data[,4:8])*champ3data$damage^2) * (as.integer(strsplit(champ3data$winrate1,"[%]")[[1]]))/100
statChamp4<- (sum(champ4data[,4:8])*champ4data$damage^2) * (as.integer(strsplit(champ4data$winrate1,"[%]")[[1]]))/100
statChamp5<- (sum(champ5data[,4:8])*champ5data$damage^2) * (as.integer(strsplit(champ5data$winrate1,"[%]")[[1]]))/100
statoChamp1<- (sum(ochamp1data[,4:8])*ochamp1data$damage^2) * (as.integer(strsplit(ochamp1data$winrate1,"[%]")[[1]]))/100
statoChamp2<- (sum(ochamp2data[,4:8])*ochamp2data$damage^2) * (as.integer(strsplit(ochamp2data$winrate1,"[%]")[[1]]))/100
statoChamp3<- (sum(ochamp3data[,4:8])*ochamp3data$damage^2) * (as.integer(strsplit(ochamp3data$winrate1,"[%]")[[1]]))/100
statoChamp4<- (sum(ochamp4data[,4:8])*ochamp4data$damage^2) * (as.integer(strsplit(ochamp4data$winrate1,"[%]")[[1]]))/100
statoChamp5<- (sum(ochamp5data[,4:8])*ochamp5data$damage^2) * (as.integer(strsplit(ochamp5data$winrate1,"[%]")[[1]]))/100

# make filter function and stat function
whowinsTeam<-function(champ1,champ2,champ3,champ4,champ5,ochamp1,ochamp2,ochamp3,ochamp4,ochamp5){
  champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ3data<-loldata %>% filter(Champ == champ3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ4data<-loldata %>% filter(Champ == champ4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ5data<-loldata %>% filter(Champ == champ5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp1data<-loldata %>% filter(Champ == ochamp1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp2data<-loldata %>% filter(Champ == ochamp2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp3data<-loldata %>% filter(Champ == ochamp3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp4data<-loldata %>% filter(Champ == ochamp4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp5data<-loldata %>% filter(Champ == ochamp5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  
  statChamp1<- (sum(champ1data[,4:8])*champ1data$damage^2) * (as.integer(strsplit(champ1data$winrate1,"[%]")[[1]]))/100
  statChamp2<- (sum(champ2data[,4:8])*champ2data$damage^2) * (as.integer(strsplit(champ2data$winrate1,"[%]")[[1]]))/100
  statChamp3<- (sum(champ3data[,4:8])*champ3data$damage^2) * (as.integer(strsplit(champ3data$winrate1,"[%]")[[1]]))/100
  statChamp4<- (sum(champ4data[,4:8])*champ4data$damage^2) * (as.integer(strsplit(champ4data$winrate1,"[%]")[[1]]))/100
  statChamp5<- (sum(champ5data[,4:8])*champ5data$damage^2) * (as.integer(strsplit(champ5data$winrate1,"[%]")[[1]]))/100
  statoChamp1<- (sum(ochamp1data[,4:8])*ochamp1data$damage^2) * (as.integer(strsplit(ochamp1data$winrate1,"[%]")[[1]]))/100
  statoChamp2<- (sum(ochamp2data[,4:8])*ochamp2data$damage^2) * (as.integer(strsplit(ochamp2data$winrate1,"[%]")[[1]]))/100
  statoChamp3<- (sum(ochamp3data[,4:8])*ochamp3data$damage^2) * (as.integer(strsplit(ochamp3data$winrate1,"[%]")[[1]]))/100
  statoChamp4<- (sum(ochamp4data[,4:8])*ochamp4data$damage^2) * (as.integer(strsplit(ochamp4data$winrate1,"[%]")[[1]]))/100
  statoChamp5<- (sum(ochamp5data[,4:8])*ochamp5data$damage^2) * (as.integer(strsplit(ochamp5data$winrate1,"[%]")[[1]]))/100
  
  yourteamScore<-sum(statChamp1,statChamp2,statChamp3,statChamp4,statChamp4)
  oppteamScore<-sum(statoChamp1,statoChamp2,statoChamp3,statoChamp4,statoChamp4)
  if (yourteamScore > oppteamScore){
    return ("Red team wins!")
  }else if (statChamp1 == statChamp2){
    return ("Both teams are equal. The winner would depend on farming and champ build")
  }else{
    return ("Blue team wins!")
  }
}

teamStats<-function(champ1,champ2,champ3,champ4,champ5,ochamp1,ochamp2,ochamp3,ochamp4,ochamp5){
  champ1data<-loldata %>% filter(Champ == champ1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ2data<-loldata %>% filter(Champ == champ2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ3data<-loldata %>% filter(Champ == champ3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ4data<-loldata %>% filter(Champ == champ4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  champ5data<-loldata %>% filter(Champ == champ5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp1data<-loldata %>% filter(Champ == ochamp1) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp2data<-loldata %>% filter(Champ == ochamp2) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp3data<-loldata %>% filter(Champ == ochamp3) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp4data<-loldata %>% filter(Champ == ochamp4) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  ochamp5data<-loldata %>% filter(Champ == ochamp5) %>% select(Champ, pickrate1, winrate1, damage, toughness, cc, mobility, utility)
  
  comboTeamA<-rbind(champ1data[,c(1,4:8)],
                    champ2data[,c(1,4:8)],
                    champ3data[,c(1,4:8)],
                    champ4data[,c(1,4:8)],
                    champ5data[,c(1,4:8)])
  comboTeamB<-rbind(ochamp1data[,c(1,4:8)],
                    ochamp2data[,c(1,4:8)],
                    ochamp3data[,c(1,4:8)],
                    ochamp4data[,c(1,4:8)],ochamp5data[,c(1,4:8)])
  
  teamAScore<-colSums(comboTeamA[,2:6])
  teamBScore<-colSums(comboTeamB[,2:6])
  
  finalTeamScore<-cbind(data.frame(Team=c('Team A','Team B')),rbind(teamAScore,teamBScore))
  
  teamGraphStats<-gvisColumnChart(finalTeamScore,options=list(legend='bottom',colors="['#004949','#198989','#36A679','#E46B2A','#F48950']"))
  return (teamGraphStats)
}

whowinsTeam(champ1,champ2,champ3,champ4,champ5,ochamp1,ochamp2,ochamp3,ochamp4,ochamp5)
#plot(teamGraphStats)
