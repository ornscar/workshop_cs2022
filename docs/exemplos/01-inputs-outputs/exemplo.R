library(shiny)

ui <- fluidPage(
  titlePanel("Meu primeiro app"),
  hr(),
  fluidRow(
    column(
      width = 4, 
      textInput(
        inputId = "titulo",
        label = "Digite o título do gráfico",
        value = "Meu gráfico de dispersão"
      ),
      selectInput(
        inputId = "eixo_x",
        label = "Selecione a variável do eixo x do gráfico:",
        choices = names(mtcars)
      ),
      selectInput(
        inputId = "eixo_y",
        label = "Selecione a variável do eixo y do gráfico:",
        choices = names(mtcars)
      )
    ),
    column(
      width = 8,
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  output$grafico <- renderPlot(
    plot(x = mtcars[[input$eixo_x]],
         y = mtcars[[input$eixo_y]],
         main = input$titulo,
         xlab = input$eixo_x,
         ylab = input$eixo_y,
         pch = 19)
  )
}

shinyApp(ui, server)