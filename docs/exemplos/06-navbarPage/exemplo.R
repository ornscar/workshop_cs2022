library(shiny)
library(ggplot2)

ui <- navbarPage(
  title = "Utilizando a navbarPage",
  tabPanel(
    title = "Sobre",
    "Aqui você pode encontrar informações sobre o painel."
  ),
  navbarMenu(
    title = "Visualizações",
    tabPanel(
      title = "Tabela",
      fluidRow(
        column(
          width = 4,
          selectInput(
            inputId = "cilindros_table", 
            label = "Selecione o número de cilindros do motor:", 
            choices = sort(unique(mtcars$cyl))
            ),
          actionButton(
            inputId = "atualizar_table", 
            label = "Atualizar a tabela"
            )
        ),
        column(
          width = 8,
          tableOutput(outputId = "tabela")
        )
      )
    ),
    tabPanel(
      title = "Gráfico",
      fluidRow(
        column(
          width = 4,
          selectInput(
            inputId = "cilindros_plot", 
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
            inputId = "atualizar_plot", 
            label = "Atualizar o gráfico"),
        ),
        column(
          width = 8,
          plotOutput(outputId = "grafico")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  tabela_atualizada <- eventReactive(input$atualizar_table, {
    mtcars[mtcars$cyl == input$cilindros_table, ]
  })
  
  output$tabela <- renderTable(tabela_atualizada(), rownames = TRUE)
  
  grafico_atualizado <- eventReactive(input$atualizar_plot, {
    mtcars[mtcars$cyl == input$cilindros_plot, ] |>
      ggplot(mapping = aes_string(x = input$eixo_x, y = input$eixo_y)) +
      geom_point()
  })
  
  output$grafico <- renderPlot(grafico_atualizado())
}

shinyApp(ui, server)