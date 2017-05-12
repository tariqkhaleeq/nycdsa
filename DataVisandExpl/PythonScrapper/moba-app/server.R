## server.R for moba

source("./global.R")

shinyServer(function(input,output){
  
  output$answer<-renderPrint({
    if (input$your_champ=="" | input$opp_champ==""){
      "Select a Champion"
    }else{
    paste(input$your_champ," vs ",input$opp_champ,sep=" ")
    }
  })
  
})