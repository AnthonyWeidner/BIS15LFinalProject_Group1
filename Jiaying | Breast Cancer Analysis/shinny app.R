library(tidyverse)
library(janitor)
options(scipen=999) #disables scientific notation when printing
library(ggthemes)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Tumor Features"),
                    dashboardSidebar(disable = T),
                    dashboardBody(
                      fluidRow(
                        box(title = "Plot Options", width = 3,
                            selectInput("x", "Select Tumor Features", choices = c("tumor_size", "tumor_stage", "mutation_count", "lymph_nodes_examined_positive"), selected = "tumor_size"),
                            hr(),
                            helpText("Source: METABRIC database"),
                        ), 
                        box(title= "Tumor Features vs. Overall Survival Months", width = 5,
                            plotOutput("plot", width = "500px", height = "500px")
                        )
                      )
                    ) 
) 

server <- function(input, output, session) { 
  
  output$plot <- renderPlot({
    breast_cancer_clean %>% 
      filter(death_from_cancer == "Died of Disease") %>%
      ggplot(aes_string(x = input$x, y = "overall_survival_months")) +
      geom_point(alpha=0.9, size=2) +
      theme_grey(base_size = 18)+ labs(x="Tumor Feature", y="Overall Survival Months", fill="Fill Variable")+
      theme(axis.text.x = element_text(angle = 65, hjust = 1))
  })
  
  session$onSessionEnded(stopApp)
}
shinyApp(ui, server)