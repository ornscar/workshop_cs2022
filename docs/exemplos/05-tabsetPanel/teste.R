library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel(title = "Um aplicativo usando o tabsetPanel junto do sidebarLayout"),
  hr(),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "cilindros", 
        label = "Selecione o número de cilindros do motor:", 
        choices = sort(unique(mtcars$cyl))
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
        ),
      actionButton(
        inputId = "atualizar", 
        label = "Atualizar a tabela e o gráfico"
        )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Tabela", tableOutput(outputId = "tabela")),
        tabPanel(title = "Gráfico", plotOutput(outputId = "grafico"))
      )
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
  
  output$tabela <- renderTable(tabela_atualizada(), rownames = TRUE)
  
  grafico_atualizado <- eventReactive(input$atualizar, {
    mtcars_filtrada() |>
      ggplot(mapping = aes_string(x = input$eixo_x, y = input$eixo_y)) +
      geom_point()
  })
  
  output$grafico <- renderPlot(grafico_atualizado())
}

shinyApp(ui, server)