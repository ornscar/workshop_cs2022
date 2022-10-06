library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "Utilizando o shinydashboard",
    titleWidth = "300px"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Tabela",
        tabName = "tabela",
        icon = icon("table")
      ),
      menuItem(
        text = "Gráfico",
        tabName = "grafico",
        icon = icon("chart-bar")
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "tabela",
        fluidRow(
          box(
            width = 4,
            title = "Filtros",
            status = "primary",
            selectInput(
              inputId = "cilindros_table",
              label = "Selecione o número de cilindros do motor:",
              choices = sort(unique(mtcars$cyl))
            ),
            actionButton(
              inputId = "atualizar_table",
              label = "Atualizar a tabela")
            
          ), 
          box(
            width = 6,
            title = "Tabela dos automóveis",
            status = "primary",
            tableOutput(outputId = "tabela")
          )
        )
      ),
      tabItem(
        tabName = "grafico",
        fluidRow(
          box(
            width = 4,
            title = "Filtros",
            status = "primary",
            selectInput(
              inputId = "cilindros_plot",
              label = "Selecione o número de cilindros do motor:", 
              choices = sort(unique(mtcars$cyl))
              ),
            selectInput(
              "eixo_x", 
              label = "Selecione a variável do eixo x do gráfico:", 
              choices = names(mtcars)
              ),
            selectInput(
              "eixo_y", 
              label = "Selecione a variável do eixo y do gráfico:", 
              choices = names(mtcars)
              ),
            actionButton(
              inputId = "atualizar_plot",
              label = "Atualizar o gráfico"
              )
          ),
          box(
            width = 8,
            title = "Gráfico de dispersão",
            status = "primary",
            plotOutput(outputId = "grafico")
          )
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