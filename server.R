# server.R
server <- function(input, output) {
  
  startTime <- as.numeric(Sys.time())
  
  token <- anonymous_login(project_api = "AIzaSyDt2yl4_YFhPmaLnlowccxGJKARPfMhFjE")
  # purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/"
  #purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/TestEC3/fakeData/"
  purl = "https://esp32-firebase-demo-b9d6b-default-rtdb.firebaseio.com/"
 
  
  # observeEvent(input$toggleSidebar, {
  #   shinyjs::toggle(id = "Sidebar")
  # })
  
  observeEvent(input$toggle_btn, {
    shinyjs::toggleClass(selector = "body", class = "sidebar-collapse")
  })
  
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
        # datetime = as.integer(rownames(.)),
        #datetime = Sys.Date() + as.integer(rownames(.)),
        datetime = as_datetime(time$ts/1000),
        date = as.Date(datetime),
        time1 = time(datetime),
        hour = hour(datetime),
        minute = minute(datetime),
        second = second(datetime),
        obs = 1
      ) %>% 
      select(
        ID,
        datetime,
        date, time1, hour, minute, second,
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
    )
  })  
  
  output$humidity <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = x$humidity$value[1]
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "Humidity (%)",
      icon = icon("percent"),
      color = "yellow"
    )
  })  
  
  output$pressure <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = x$pressure$value[1]
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "Pressure (bar)",
      icon = icon("temperature-half"),
      color = "yellow"
    )
  }) 
  
  output$gas <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = x$gas$value[1]
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "Gas (%)",
      icon = icon("fire-flame-simple"),
      color = "yellow"
    )
  }) 
  
  # water
  
  output$watertemp <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    # fb.value = 99.9
    fb.value = x$extra1$value[1]
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "Extra 1",
      icon = icon("fire-flame-simple"),
      color = "blue"
    )
  }) 
  
  output$waterph <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = 7.4
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "pH",
      icon = icon("chart-simple"),
      color = "blue"
    )
  }) 
  
  output$turbidity <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    # fb.value = 99.9
    fb.value = x$extra2$value[1]
    valueBox(
      value = formatC(fb.value, digits = 1, format = "f"),
      subtitle = "Extra 2",
      icon = icon("vial"),
      color = "blue"
    )
  }) 
  
  output$voltage <- renderValueBox({
    db = sensorInput()
    x = db %>%filter(ID == max(ID))
    fb.value = x$voltage$value[1]
    # fb.value = 99.9
    valueBox(
      value = formatC(fb.value, digits = 3, format = "f"),
      subtitle = "Voltage (V)",
      icon = icon("bolt"),
      color = "blue"
    )
  }) 
  

  output$voltagePlot<-renderPlotly({
    df = sensorInput()
  
    plot_ly(type = 'scatter', mode = 'lines') %>%
      add_trace(x = ~df$datetime, y = ~df$voltage$value, 
                line = list(shape = "spline", color = 'red'),
                name = 'Voltage') %>%
      layout(
        title = list(text = "Voltage"),
        xaxis = list(rangemode = "normal",
                     title = 'Datetime',
                     zerolinecolor = 'black',
                     zerolinewidth = 6,
                     gridcolor = 'white'
        ),
        yaxis = list(rangemode = "normal",
                     title = 'Voltage [V]',
                     zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff',
                     tickformat = ".2f"
        ),
        plot_bgcolor='#e5ecf6',
        showlegend = F
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