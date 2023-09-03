# server.R
server <- function(input, output) {
  
  startTime <- as.numeric(Sys.time())
  
  token <- anonymous_login(project_api = "AIzaSyDt2yl4_YFhPmaLnlowccxGJKARPfMhFjE")
  purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/"
  #fname = "test3"
  
  output$distPlot <- renderPlot({
    dist <- rnorm(input$obs)
    hist(dist,
         col="purple",
         xlab="Random values")
  })
  output$distPlot2 <- renderPlot({
    dist2 <- rnorm(input$obs2)
    hist(dist2,
         col="green",
         xlab="Random values 2")
  })
  
  dataInput <- reactive({
    fname = input$firebase_node
    urlPath = paste0(purl,"/",fname,".json")
    data = httr::GET(url = urlPath)
    xx = jsonlite::fromJSON(httr::content(data,"text"))
    return(xx)
  })
  
  output$count <- renderValueBox({
    fb.json = dataInput()
    fb.key = input$firebase_key
    fb.value = "null"
    fb.value = fb.json[[fb.key]]
    
    valueBox(
      value = formatC(fb.value, digits = 2, format = "f"),
      subtitle = "Arduino Sensor X",
      icon = icon("area-chart"),
      color = "yellow"
      # width = 22
      #color = if (downloadRate >= input$rateThreshold) "yellow" else "aqua"
    )
  })    
    
    
    
  output$rate <- renderValueBox({
    tt = dataInput()
    # urlPath = paste0(purl,"/",fname,".json")
    # data = httr::GET(url = urlPath)
    # xx = jsonlite::fromJSON(httr::content(data,"text"))
    fb.id = input$symb
    fb.value = "null"
    if(fb.id=="float") 
      fb.value = tt[[fb.id]]
    else if (fb.id=="gg") 
      fb.value = tt[[fb.id]]
    else if (fb.id=="int") 
      fb.value = tt[[fb.id]]
    else 
      fb.value = "null"
    # tgg = tt[["gg"]]
    # tint = tt[["int"]]
    # The downloadRate is the number of rows in pkgData since
    # either startTime or maxAgeSecs ago, whichever is later.
    elapsed <- as.numeric(Sys.time()) - startTime
    # downloadRate <- nrow(pkgData()) / min(maxAgeSecs, elapsed)
    downloadRate = sample(100:1000, 1, replace= FALSE)
    valueBox(
      value = formatC(fb.value, digits = 2, format = "f"),
      subtitle = "Downloads per sec (last 5 min)",
      icon = icon("area-chart"),
      color = "yellow"
      # width = 22
      #color = if (downloadRate >= input$rateThreshold) "yellow" else "aqua"
    )
  })
  
}