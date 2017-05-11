# scrapping data
library(dplyr)
library(ggplot2)
library(googleVis)

loldata<-read.delim("~/nycdsa/DataVisandExpl/PythonScrapper/moba/moba/spiders/LOL_moba_champs.txt",header = FALSE, stringsAsFactors = FALSE)
# add colum names
colnames(loldata)<-c("Champ","Alias","pos1","pickrate1","winrate1","pos2","pickrate2","winrate2","damage","toughness","cc","mobility","utility")

# How many champs can only play one role vs two

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

# What is the pick rate for champs pos 1 and pos 2

# 