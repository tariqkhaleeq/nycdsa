library(dplyr)
library(ggplot2)
library(googleVis)
### Project 
rest.data<-read.csv("~/Downloads/Restaurant_Health_Inspections.csv",stringsAsFactors = FALSE)
head(rest.data)

#Total number of restaurants 
# 8444 inspected out of over 24,000 resturants in Manhatten
length(unique(rest.data[,1]))

# 81 types of cuisines
types.of.cuisine<-unique(rest.data$CUISINE.DESCRIPTION)
# Tally results 
tally<-rest.data %>%group_by(CUISINE.DESCRIPTION) %>% summarise(Total=n()) %>% arrange(desc(Total))
tally$CUISINE.DESCRIPTION<-factor(tally$CUISINE.DESCRIPTION, levels=tally$CUISINE.DESCRIPTION)

fig1<-ggplot(tally[1:20,], aes(x=CUISINE.DESCRIPTION, y=Total)) + 
  geom_bar(aes(fill=CUISINE.DESCRIPTION), stat="identity") +
  labs(title="Top 20 Cuisines with highest violation",x="Cuisines", y = "Amount of violations per cuisine") + 
  theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_blank()) +
  scale_fill_discrete(name="Types of cuisines in Manhattan")
  #coord_flip() 
plot(fig1)
ggsave("fig1.png")
#make barplot/histogram or piechart -> Prob the best way is to make it a table. Too big data

Table1 <- gvisTable(tal,options=list(width="1000",height="automatic",
                                       size="large",
                                       page='enable',
                                       pageSize=20,
                                       showRowNumber=TRUE))
plot(Table1)

#Types of violation = 95
types_of_violation<-unique(rest.data$VIOLATION.CODE)
# Not sure if I would be able to explain all of this.

# Types of explanation for the violations = 6
#Show potentially how many were closed and how many werent.
unique(rest.data$ACTION)
tally2<-rest.data %>%group_by(ACTION) %>% summarise(Total=n()) %>% arrange(desc(Total))
tally2[1:3,1]<-c("Violations that did not require closure", "Establishment closed due to critical violations", "No Violations")
tally2$ACTION<-factor(tally2$ACTION, levels = tally2$ACTION)

# bar plot
BC<-gvisColumnChart(tally2,"ACTION","Total",options = list(height="1000"))
plot(BC)

fig2<-ggplot(tally2[1:3,], aes(x=ACTION, y=Total)) + 
  geom_bar(aes(fill=ACTION), stat="identity", width=0.2) +
  geom_text(aes(label=Total),position=position_dodge(width=0.9), vjust=-0.25) +
  labs(title="Comparison between violators and non violators",x="Violations", y = "Total number of violations") + 
  theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_blank()) +
  scale_fill_discrete(name="Type of violations")
plot(fig2)

ggsave("fig2.png")

Pie <- gvisPieChart(tally2[1:3,],options=list(width="1300",height="800",size="large"))
plot(Pie)

fig2b<-ggplot(tally2, aes(x=factor(1), fill=ACTION)) + geom_bar(width=1) + coord_polar(theta="y")
plot(fig2b)
# Try to explain what each of the 6 violations meant. DOnt know what to do for "".

# Types of violation description= 93
unique(rest.data$VIOLATION.DESCRIPTION)
#Get the top 10 reasons why restaurants were given a bad grade
tally3<-rest.data %>%group_by(VIOLATION.DESCRIPTION) %>% summarise(Total=n()) %>% arrange(desc(Total))
tally3[c(1,7,8),1]<-c("Non-food contact surface improperly constructed.","Plumbing not properly installed or maintained","Filth flies or food/refuse/sewage-associated (FRSA) flies present in facility\032s food and/or non-food areas.")
tally3$VIOLATION.DESCRIPTION<-factor(tally3$VIOLATION.DESCRIPTION, levels=tally3$VIOLATION.DESCRIPTION)
tall3top10<-tally3[1:10,]

#color them differently and add legend ||| Pie is better. Legends needs to be readable and smaller font.
BC<-gvisColumnChart(tall3top10,"VIOLATION.DESCRIPTION","Total",options = list(height="1000"))
plot(BC)

Pie <- gvisPieChart(tall3top10,options=list(width="1200",height="800",size="large",legend.textStyle.fontSize="10"))
plot(Pie)

fig3<-ggplot(tall3top10, aes(x=VIOLATION.DESCRIPTION, y=Total)) + 
  geom_bar(aes(fill=VIOLATION.DESCRIPTION), stat="identity", width=0.2) +
  geom_text(aes(label=Total),position=position_dodge(width=0.9), vjust=-0.25) +
  labs(title="Top 10 reasons for violations",x="Reasons", y = "Total occurances of reasons") + 
  theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_blank(),legend.justification=c(1,1),legend.position=c(1,1)) +
  scale_fill_discrete(name="Type of reasons")
plot(fig3)

ggsave("fig3.png",width = 12, height =9)

tall3top5<-tally3[1:5,]
fig3b<-ggplot(tall3top5, aes(x=VIOLATION.DESCRIPTION, y=Total)) + 
  geom_bar(aes(fill=VIOLATION.DESCRIPTION), stat="identity", width=0.2) +
  geom_text(aes(label=Total),position=position_dodge(width=0.9), vjust=-0.25) +
  labs(title="Top 5 reasons for violations",x="Reasons", y = "Total occurances of reasons") + 
  theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_blank(),legend.justification=c(1,1),legend.position=c(1,1)) +
  scale_fill_discrete(name="Type of reasons")
plot(fig3b)

ggsave("fig3b.png",width = 13, height =9)
# How many of the violations were critical, non critical and not applicable. Cr=92831, NonCr=72154 NotApp = 2792

tally4<-rest.data %>% group_by(CRITICAL.FLAG) %>% summarise(Total=n()) %>% arrange(desc(Total))

fig4<-ggplot(tally4,aes(x=factor(CRITICAL.FLAG),y=Total,color=CRITICAL.FLAG)) + 
  geom_bar(aes(fill=CRITICAL.FLAG),stat="identity") + 
  geom_text(aes(label=Total),position=position_dodge(width=0.9), vjust=-0.25)+
  xlab("Types of Flag") +
  ggtitle("Number and types of Flag") +
  theme(plot.title = element_text(hjust = 0.5),legend.position = "None")+
  labs(linetype="Type") +
  scale_x_discrete(limits=c('Critical','Not Critical','Not Applicable'))
plot(fig4)

ggsave("fig4.png")

######
# Probably the frequncy of scores doesnt make sense
# range of scores

unique(rest.data$SCORE)
score<-data.frame(score=rest.data$SCORE)
score<-list(score[!is.na(score)]) #157752
for (x in score){ print (sum(x<14)) } # 75009
#lessthan14<-filter(score, score<14)
for (x in score){ print (sum(x>14 & x<=23)) } # 37777
#gthan14lthan23<-filter(score, score>14 & score<=23)
for (x in score){ print (sum(x>=24)) } # 42596
#gthan23<-filter(score, score>=24)
score %>% filter(score>=24) %>% summarise(sum(score>=24)) 

rest.data %>% group_by(SCORE) %>% filter(SCORE<14) %>%summarise(Frequency=n())

## ^^ histogram

# frequency of grades for resturants 
grade<-as.data.frame(rest.data$GRADE)
dim(rest.data[which(rest.data$GRADE=="A"),]) #64568
dim(rest.data[which(rest.data$GRADE=="B"),]) #12023
dim(rest.data[which(rest.data$GRADE=="C"),]) #3154
dim(rest.data[which(rest.data$GRADE==""),])# 86199
dim(rest.data[which(rest.data$GRADE=="Z"),]) #882
dim(rest.data[which(rest.data$GRADE=="P"),]) #448
dim(rest.data[which(rest.data$GRADE=="Not Yet Graded"),]) # 503

tally5<-rest.data %>% group_by(GRADE) %>% summarise(Total=n()) #filter(GRADE=="A")

fig5<-ggplot(tally5[-1,],aes(x=factor(GRADE),y=Total,color=GRADE)) + 
  geom_bar(aes(fill=GRADE),stat="identity") + 
  geom_text(aes(label=Total),position=position_dodge(width=0.9), vjust=-0.25)+
  xlab("Types of Grades") +
  ggtitle("The total number and types of Grade") +
  theme(plot.title = element_text(hjust = 0.5),legend.position = "None")+
  labs(linetype="Type")
  #scale_x_discrete(limits=c('Critical','Not Critical','Not Applicable'))
plot(fig5)
ggsave("fig5.png")

## Investigate the reason for the first bar

#####
#Probably not add this one
# Inpsection TYPE
unique(rest.data$INSPECTION.TYPE) # 31 different types of Inspections

rest.data %>% group_by(INSPECTION.TYPE) %>% summarise(Total=n())


### Special
# A look at resturants that Grade A but critical and non critical ratio. 

# However when we are looking at Total number of Critical and non; the sum is 31541 to 32607
tally6<-rest.data %>% filter(GRADE=="A") %>% summarise(TotalC=sum(CRITICAL.FLAG=="Critical"), TotalNC=sum(CRITICAL.FLAG=="Not Critical"))
tall6<-data.frame(CorNC=c("Total number of critical flags","Total number of non critical flags"), Total = c(as.integer(tally6)[1],as.integer(tally6)[2]))

Pie <- gvisPieChart(tall6,options=list(width="1200",height="800",size="large",
                                       legend="bottom",
                                       gvis.editor = "Edit me!",
                                       title="Total number of critical flags vs non critical flags in Grade A restaurants"
                                       ))
plot(Pie)

## centering is bitch

# Filter out the ones that were re inspected and still critical. 
rest.data %>% filter(GRADE=="A" & CRITICAL.FLAG=="Critical") %>% summarise(sum(INSPECTION.TYPE=="Cycle Inspection / Re-inspection"))
Critical<-rest.data %>% group_by(GRADE) %>% filter(GRADE=="A" & CRITICAL.FLAG=="Critical" & INSPECTION.TYPE=="Cycle Inspection / Re-inspection")
# total = 14668 out of the total grade A 64568 

# Filter out the best one that had grade A, a really low score and not critical. #4103
test<-rest.data %>%group_by(DBA)%>% filter(GRADE =="A" & CRITICAL.FLAG=="Not Critical" & SCORE<5) #%>% summarise(n())

#put this in table
# How to make it savable by R
PopTable <- gvisTable(test[,c(1:5,11:12)],options=list(width="1000",height="automatic",
                                       size="large",
                                       page='enable',
                                       pageSize=20,
                                       showRowNumber=TRUE))
plot(PopTable)

datatable(test)

##### pie chart for grade A critical and non critical piechart
gradeACrit<-rest.data %>% group_by(DBA,GRADE,CRITICAL.FLAG) %>% filter(GRADE=="A" & CRITICAL.FLAG=="Critical" & INSPECTION.TYPE=="Cycle Inspection / Re-inspection")
gacTotal<-length(unique(gradeACrit$DBA))

gradeANoCrit<-rest.data %>% group_by(DBA,GRADE,CRITICAL.FLAG) %>% filter(GRADE=="A" & CRITICAL.FLAG=="Not Critical" & INSPECTION.TYPE=="Cycle Inspection / Re-inspection")
gancTotal<-length(unique(gradeANoCrit$DBA))

A<-data.frame(CorNC=c("Total number of critical flags","Total number of non critical flags"), Total = c((gacTotal-gancTotal),gancTotal))

Pie <- gvisPieChart(A,options=list(width="700",height="500",size="large",
                                       legend="bottom",
                                       title="Total number of critical flags vs non critical flags in Grade A restaurants",
                                        colors = "['#82e0aa' , '#ec7063']"
))
plot(Pie)


#bestrestaurants

best<-rest.data %>% group_by(DBA, GRADE, CRITICAL.FLAG) %>% filter(GRADE=="A" | GRADE=="B" & INSPECTION.TYPE=="Cycle Inspection / Re-inspection") %>% select(DBA,BORO, STREET, CUISINE.DESCRIPTION, GRADE, SCORE, CRITICAL.FLAG, VIOLATION.DESCRIPTION)
colnames(best)<-c("Restaurant","City","Street","Cuisine","Grade","Score","Critical Flag","Violaton")
testTable<- gvisTable(best,option=list(page='enable', pageSize=10))
plot(testTable)

# Restaurants for mapping

abc<-read.csv("~/Downloads/Restaurant_Health_Inspections_plus.csv",stringsAsFactors = FALSE)
beta<-abc %>% group_by(DBA,GRADE,CRITICAL.FLAG,INSPECTION.TYPE)%>%filter(CRITICAL.FLAG=="Not Critical" & INSPECTION.TYPE=="Cycle Inspection / Re-inspection")

write.csv(abc,file = "~/Downloads/Restaurant_Health_Inspections_plus.csv",row.names = FALSE)

readElement<- function(data){
  colorList=c()
  for (i in 1:nrow(data)){
    #print (i)
    if(data$GRADE[i]=="A"){
      #print ("Green")
      colorList[i]<-"Green"
    }else colorList[i]<-"Yellow"
  }
  return (colorList)
}

getColor2 <- function(quakes) {
  sapply(quakes$SCORE, function(SCORE) {
    if(SCORE < 14) {
      "green"
    } else {
      "orange"
    } })
}
co<-readElement(beta)

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor2(beta)
)

leaflet(beta) %>% addTiles() %>%
  addAwesomeMarkers(~X1, ~X2, icon=icons, label=~as.character(c(DBA,GRADE)))

df.20 <- quakes[1:20,]

getColor <- function(quakes) {
  sapply(quakes$mag, function(mag) {
    if(mag <= 4) {
      "green"
    } else if(mag <= 5) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df.20)
)

leaflet(df.20) %>% addTiles() %>%
  addAwesomeMarkers(~long, ~lat, icon=icons, label=~as.character(mag))


