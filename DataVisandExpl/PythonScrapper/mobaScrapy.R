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


