## ui for moba

dashboardPage(skin="blue",
              dashboardHeader(title="Moba builds",titleWidth=170),
              dashboardSidebar(width = 170,
                               sidebarMenu(
                                 menuItem("Welcome", tabName="welcome",icon = icon("hand-peace-o")),
                                 menuItem("1 v 1 matchup", tabName="1v1",icon = icon("king",lib="glyphicon")),
                                 menuItem("Team matchup", tabName = "team", icon = icon("users")),
                                 menuItem("Basic Stats", tabName = "basic", icon = icon("pie-chart")),
                                 menuItem("About", tabName = "about", icon = icon("hand-spock-o"))
                               )
              ),
              dashboardBody(
                tabItems(
                  tabItem(tabName = "welcome",
                          fluidRow(
                            box(
                              h1("Are you going to eat that?"),
                              p("Its really simple to find a restaurant with apps such as Yelp! etc.
                                However what they miss out are hygiene related conditions of various restaurants.
                                With stats that show immense downloads of fitness apps, we can assume that most people are health conscience and probably prefer to eat healthy.
                                But is eating healthy the only thing that matters?"),
                              p("The Department of Health and Mental Hygenie (DOHMH) published over 167,000 records of restaurants in the Manhattan area. The dataset can be
                                investigated to determine various information about the violations violated by restaurant and their resultant grades. Some severe violations have even lead to closures!  "),
                              h3("What to expect from this app"),
                              p("The app can be used to qualitatively see various aspects of the dataset. For example, how many restaurants have been awarded grades such as A, B, C or have not yet been graded.
                                Additionaly you can view the summarised version of the dataset in the",strong('Summary Stats tab.'),"  
                                Finally you can also view grade A and B restaurants with non critical violations in the Manhattan area. "),
                              
                              width='1000px')
                            
                                  )
                            ),
                
                  tabItem(tabName = "1v1",
                          fluidRow( 
                            column(width = 3,wellPanel(
                              box(width=NULL,title = "Choose you champion",solidHeader = TRUE, status = "primary",
                                  selectInput("your_champ", label = "Your champion", selectize = FALSE,
                                              choices = c("",loldata$Champ), selected = 20)),
                              box(width=NULL,title = "Choose you opponent",solidHeader = TRUE, status = "danger",
                                  selectInput("opp_champ", label = "Your opponent",selectize = FALSE,
                                              choices = c("",loldata$Champ), selected = NULL)),
                              div(style="display:inline-block",submitButton(h3("FIGHT!!")),style="display:center-align"),br()
                            )),
                            column(width = 8, wellPanel(
                              box(width=NULL,title = "Result",solidHeader = TRUE, status = "success",
                                  htmlOutput("answer")),
                              box(width=NULL,title = "Graph",solidHeader = TRUE, status = "warning",
                                  htmlOutput("champGraph"))
                            )
                          )
                      )
              )
                  
                  
                  
                )#tabItems
  )#dashboardBody
)#dashboardPage