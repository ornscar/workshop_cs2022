library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Utilizando a função eventReactive()"),
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
  fluidRow(
    column(
      width = 2,
      offset = 5,
      actionButton(inputId = "atualizar",
                   label = "Atualizar a tabela e o gráfico"
                   )
    )
  ), 
  br(),
  fluidRow(
    column(
      width = 4,
      tableOutput(outputId = "tabela")
    ),
    column(
      width = 8,
      plotOutput(outputId = "grafico")
    )
  )
)

server <- function(input, output, session) {
  mtcars_filtrada <- reactive({
    mtcars |>
      filter(cyl == input$cilindros)
  })
  
  tabela_atualizada <- eventReactive(input$atualizar, {
    mtcars_filtrada()
  })
  
  output$tabela <- renderTable(tabela_atualizada())
  
  grafico_atualizado <- eventReactive(input$atualizar, {
    mtcars_filtrada() |>
      ggplot(mapping = aes_string(x = input$eixo_x, y = input$eixo_y)) +
      geom_point()
  })
  
  output$grafico <- renderPlot(grafico_atualizado())
}

shinyApp(ui, server)