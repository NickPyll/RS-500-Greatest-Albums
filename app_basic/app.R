library(tidyverse)
library(reactable)
library(reactablefmtr)

rs_list <- readRDS('data/rs_list.RDS')

ui <- basicPage(
  includeCSS("custom_css.css"),
  h2("The 500 Greatest Albums of All Time...According to Rolling Stone (in 2020)."),
  reactable::reactableOutput("mytable")
)

server <- function(input, output) {
  output$mytable = reactable::renderReactable({
    
    reactable(
      rs_list,
      
      # theme
      highlight = TRUE,
      striped = TRUE,
      height = 910,
      theme = reactableTheme(
        stripedColor ='#e6ffe6',
        highlightColor = '#c79e9e',
        style = list(fontFamily = 'Menlo')
      ),
      
      # sorting and searching
      defaultSorted = 'rank',
      searchable = TRUE,
      
      # page options
      showPageSizeOptions = TRUE, 
      pageSizeOptions = c(10, 25, 50),
      paginationType = "jump", 
      
      # column options
      columns = list(
        rank = colDef(name = 'Rank', align = 'left', minWidth = 20),
        artist = colDef(name = 'Artist', align = 'center', minWidth = 45),
        album = colDef(name = 'Album', align = 'center', minWidth = 45),
        label = colDef(name = 'Label', align = 'center', minWidth = 45),
        year = colDef(name = 'Year', align = 'center', minWidth = 45),
        description = colDef(name = 'Notes', align = 'left', minWidth = 300, sortable = FALSE)
      )
    ) 
    
  })
}

shinyApp(ui, server)


