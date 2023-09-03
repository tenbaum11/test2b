# server.R
server <- function(input, output) {
  
  startTime <- as.numeric(Sys.time())
  
  token <- anonymous_login(project_api = "AIzaSyDt2yl4_YFhPmaLnlowccxGJKARPfMhFjE")
  # purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/"
  #purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/TestEC3/fakeData/"
  purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/"
 
  
  sensorInput <- reactive({
    fname = input$firebase_test
    nodename = input$node
    # fname = 'allDataSensor01'
    #urlPath = paste0(purl,"/",fname,".json")
    # urlPath = paste0(purl, nodename, "/", "fakeData", fname)
    urlPath = paste0(purl, nodename, "/", "fakeData/")
    x.df = download(projectURL = urlPath, fileName = fname)
    # x.df2 = as.data.frame(x.df) %>% drop_na() %>%
    #   rename_all(list( ~gsub("fakeData.fakeSensor03", "sensor_03", .) )) %>%
    #   mutate(
    #     datetime = as_datetime(sensor_03.time$ts/1000),   
    #     date = as.Date(datetime),
    #     time = time(datetime),
    #     hour = hour(datetime),
    #     minute = minute(datetime),
    #     second = second(datetime)
    #   )
    # x.df = download(projectURL = purl, fileName = "allDataSensor01")
    x.df2 = x.df %>%
      mutate(
        ID = as.integer(rownames(.))-1,
        datetime = as.integer(rownames(.)),
        #datetime = Sys.Date() + as.integer(rownames(.)),
        # datetime = as_datetime(time$ts/1000),  
        # date = as.Date(datetime),
        # time1 = time(datetime),
        # hour = hour(datetime),
        # minute = minute(datetime),
        # second = second(datetime),
        obs = 1
      ) %>% 
      select(
        ID,
        datetime,
        everything(),
        -time
      )
    
    return(x.df2)
  })
  
  output$airtemp <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = x$temperature$value[1]
    valueBox(
      value = formatC(fb.value, digits = 2, format = "f"),
      subtitle = "Air Temp (F)",
      icon = icon("temperature-half"),
      color = "yellow"
      # width = 22
      #color = if (downloadRate >= input$rateThreshold) "yellow" else "aqua"
    )
  })  
  
  
  
  
  
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