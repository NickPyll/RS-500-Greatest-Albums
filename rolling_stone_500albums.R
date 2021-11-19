library(jsonlite)
library(magrittr)
library(purrr)
library(tidyverse)
library(rvest)
library(DT)

# list urls...they are divided into groups of 50. probably a better way to do this but here we are...it works...get over it
urls <- 
  c(
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/linda-mccartney-and-paul-ram-1062783/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/the-go-gos-beauty-and-the-beat-1062833/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/stevie-wonder-music-of-my-mind-2-1062883/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/shania-twain-come-on-over-1062933/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/buzzcocks-singles-going-steady-2-1062983/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/sade-diamond-life-1063033/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/bruce-springsteen-nebraska-3-1063083/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/the-band-music-from-big-pink-2-1063133/',
    'https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/jay-z-the-blueprint-3-1063183/'
)

# create empty data frame
rs_list <- 
  data.frame(
    rank = integer(),
    title = character(),
    subtitle = character(),
    description = character()
  )

# loop through urls
for (j in 1:10) {

  # read url as text
  response <- read_html(urls[[j]]) %>% html_text()
  
  # parse json
  regex_response <- jsonlite::parse_json(stringr::str_match(response, "var pmcGalleryExports = (.*\\})")[, 2])

  # loop through entries on page
  for (i in 1:50) {
  
    # create tibble and append
    rs_list <-
      rs_list %>% 
      bind_rows(
        tibble(
          rank = regex_response$gallery[[i]]$positionDisplay %>% unlist(),
          title = regex_response$gallery[[i]]$title %>% unlist(),
          subtitle = regex_response$gallery[[i]]$subtitle %>% unlist(),
          description = regex_response$gallery[[i]]$description %>% unlist()
        )
      )
  }
}

# clean data
rs_list %<>% 
  separate(title, c('artist', 'album'), ", '") %>% 
  separate(subtitle, c('label', 'year'), ", ") %>% 
  mutate(
    album = str_trim(album, side = 'both'),
    album = str_sub(album, 1, nchar(album) - 1),
    description = gsub("<.*?>", "", description),
    label = gsub("&amp;", "&", label),
    album = gsub("&amp;", "&", album),
    description = gsub("&amp;", "&", description),
    description = gsub("&#8220;", '"', description),
    description = gsub("&#8221;", '"', description))
  
# write.csv(rs_list, 'rs_list.csv', fileEncoding="UTF-16", row.names = FALSE)

datatable(rs_list)
