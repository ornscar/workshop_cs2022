library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Entendendo a necessidade de uma expressão reativa"),
  hr(),
  fluidRow(
    column(
      width = 4,
      selectInput(
        inputId = "cilindros",
        label = "Selecione o número de cilindros do motor:",
        choices = sort(unique(mtcars$cyl))
      )
    ),
    column(
      width = 4,
      selectInput(
        inputId = "eixo_x",
        label = "Selecione a variável do eixo x do gráfico:",
        choices = names(mtcars)
      )
    ),
    column(
      width = 4,
      selectInput(
        inputId = "eixo_y",
        label = "Selecione a variável do eixo y do gráfico:",
        choices = names(mtcars)
      )
    )
  ), 
  br(),
  fluidRow(
    column(
      width = 6,
      tableOutput(outputId = "tabela")
    ),
    column(
      width = 6,
      plotOutput(outputId = "grafico")
    )
  )
)

server <- function(input, output, session) {
  mtcars_filtrada <- reactive({
    mtcars |>
      filter(cyl == input$cilindros)
  })
  
  output$tabela <- renderTable(mtcars_filtrada(), rownames = TRUE)
  
  output$grafico <- renderPlot({
    mtcars_filtrada() |>
      ggplot(mapping = aes_string(x = input$eixo_x, y = input$eixo_y)) +
      geom_point()
  })
}
shinyApp(ui, server)