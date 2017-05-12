## server.R for moba

source("./global.R")

shinyServer(function(input,output){
  
  output$answer<-renderPrint({
    if (input$your_champ=="" | input$opp_champ==""){
      "Select a Champion"
    }else{
    whoWins(input$your_champ,input$opp_champ)
    }
  })
  
  output$champGraph<-renderGvis({
    champStats(input$your_champ,input$opp_champ)
  })
})