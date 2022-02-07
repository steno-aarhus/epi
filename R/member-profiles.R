
# Needs survey with:
#
# - Full name
# - Link to profile pic (e.g. SDCA) (or upload one on the form)
# - Link to personal webpage (if have one)
# - List of research topics involved in
# - List of data sources used
# - List of methods used (is this necessary?)
#
# (TODO: Get agreed upon list of sources, methods, topics)
#
# Matrix could be:
#
# Topics (columns) by data/methods (rows), with multiple small-ish circles for
# people within each cell?
#
# Actions:
# 1. Import survey link.
# 2. Wrangle data into long format so columns are:
# name, personal_url, picture_url, research_topics, data_sources, methods
# 3. Format into appropriate string to display on website (with glue)
# - Some options are "![[NAME](PERSONAL_URL)](PIC_URL)"
# - Have images rounded
# 4. Summarize by data source/topic so images are all in one cell, separated by a space?
# 5. Convert to wide form so data source is on rows and topic is by columns
# 6. Convert to table with pre-set cell width and height?
#
# Similar thing for methods?
#

library(googlesheets4)
library(tidyr)
library(dplyr)
library(gt)

# Need access token? If will be on website, can be public than?
gs4_deauth()

read_sheet("") %>%
    rename(name, personal_url, picture_url, research_topics,
           data_sources, methods) %>%
    mutate(
        name = if_else(
            is.na(personal_url),
            name,
            as.character(glue::glue("[{name}]({personal_url})"))
        ),
        table_cell_contents = glue::glue("![{name}]({picture_url})")
    ) %>%
    pivot_longer(-table_cell_contents) %>%
    nest( = -c(table_cell_contents, )

# - Some options are "![[NAME](PERSONAL_URL)](PIC_URL)"
