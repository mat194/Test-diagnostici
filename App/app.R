library(tidyverse)
library(plotly)
library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Diagnostic tests by MM"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("prevalence", "Prevalence", min = 0, max = 100, value = 20),
      sliderInput("sensitivity", "Sensitivity", min = 0, max = 100, value = 90, step = 1),
      sliderInput("specificity", "Specificity", min = 0, max = 100, value = 90, step = 1),
      tableOutput("statsTable")
    ),
    mainPanel(
      tabPanel("Test performance",plotlyOutput("testResultPlot")),
      tabPanel("Fagan's Nomogram", plotlyOutput("faganNomogram"))
    )
  )
)

server <- function(input, output) {
  values <- reactive({
    req(input$prevalence, input$sensitivity, input$specificity)
    
    prevalenceRate <- input$prevalence / 100
    sensitivity <- input$sensitivity / 100
    specificity <- input$specificity / 100
    
    LR_plus <- sensitivity / (1 - specificity)
    LR_minus <- (1 - sensitivity) / specificity
    PPV <- (sensitivity * prevalenceRate) / (sensitivity * prevalenceRate + (1 - specificity) * (1 - prevalenceRate))
    NPV <- (specificity * (1 - prevalenceRate)) / (specificity * (1 - prevalenceRate) + (1 - sensitivity) * prevalenceRate)
    correctly_classified <- (sensitivity * prevalenceRate) + (specificity * (1 - prevalenceRate))
    
    list(
      prevalenceRate = prevalenceRate,
      sensitivity = sensitivity,
      specificity = specificity,
      LR_plus = LR_plus,
      LR_minus = LR_minus,
      PPV = PPV,
      NPV = NPV,
      correctly_classified = correctly_classified
    )
  })
  
  output$statsTable <- renderTable({
    v <- values()
    statsDF <- data.frame(
      Metric = c("Sensitivity", "Specificity", "Correctly Classified", "LR+", "LR-", "PPV", "NPV"),
      Value = c(
        paste0(formatC(v$sensitivity * 100, format = "f", digits = 0), "%"),
        paste0(formatC(v$specificity * 100, format = "f", digits = 0), "%"),
        paste0(formatC(v$correctly_classified * 100, format = "f", digits = 0), "%"),
        round(v$LR_plus, 2),
        round(v$LR_minus, 2),
        paste0(formatC(v$PPV * 100, format = "f", digits = 0), "%"),
        paste0(formatC(v$NPV * 100, format = "f", digits = 0), "%")
      )
    )
    statsDF
  })
  
  output$testResultPlot <- renderPlotly({
    v <- values()

    VP <- round(v$sensitivity * v$prevalenceRate * 100)
    VN <- round(v$specificity * (1 - v$prevalenceRate) * 100)
    FP <- round((1 - v$specificity) * (1 - v$prevalenceRate) * 100)
    FN <- round((1 - v$sensitivity) * v$prevalenceRate * 100)
    
    confusionMatrix <- tibble(
      Category = c("True Positive", "True Negative", "False Positive", "False Negative"),
      Count = c(VP, VN, FP, FN),
      Label = c("TP", "TN", "FP", "FN")
    )

    p <- plot_ly(
      data = confusionMatrix,
      labels = ~Label,
      parents = c("", "", "", ""),
      values = ~Count,
      type = 'treemap',
      textinfo = 'label+value',
      hovertemplate = "<b>%{label}:</b> %{value}<extra></extra>"
    )
    
    p
  })
  
  
  calculate_post_probability <- function(pre_probability, LR) {
    odds <- pre_probability / (1 - pre_probability)
    post_odds <- odds * LR
    post_probability <- post_odds / (1 + post_odds)
    return(post_probability * 100)
  }
  output$faganNomogram <- renderPlotly({
    v <- values()
    
    pre_probs <- seq(0, 1, length.out = 100)
    
    data <- tibble(
      PreTestProb = pre_probs,
      PostTestProbLRPlus = calculate_post_probability(pre_probs, v$LR_plus),
      PostTestProbLRMinus = calculate_post_probability(pre_probs, v$LR_minus)
    )
    
    p <- ggplot(data) +
      geom_line(aes(x = PreTestProb * 100, y = PostTestProbLRPlus, color = "LR+")) +
      geom_line(aes(x = PreTestProb * 100, y = PostTestProbLRMinus, color = "LR-")) +
      geom_vline(xintercept = v$prevalenceRate * 100, color = "red", linetype = "dashed") +
      scale_color_manual(values = c("LR+" = "blue", "LR-" = "green")) +
      labs(
        x = "Pre-test probability (%)",
        y = "Post-test probability (%)",
        color = ""
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
}

shinyApp(ui = ui, server = server)
