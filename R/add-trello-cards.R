source(here::here("R/functions.R"))
# Comments will be added over time.
library(tidyverse)
library(lubridate)
library(calendar)
library(trelloR)
library(askpass)

stop("This prevents accidentally sourcing the whole script.")

# Details about getting Key and OAuth Secret found here:
# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/
trello_key <- askpass("Trello Key.")
trello_oauth_secret <- askpass("Trello OAuth Secret.")

token <- get_token(
    "steno-epi-board",
    key = trello_key,
    secret = trello_oauth_secret,
    scope = c("read", "write"),
    expiration = "1day",
    cache = FALSE
)

board_url <- "https://trello.com/b/ipcYGXhC/epidemiology-group"
upcoming_board_id <- get_board_lists(board_url, token = token) %>%
    filter(str_detect(name, "Upcoming")) %>%
    pull(id)

public_calendar_link <- "https://calendar.google.com/calendar/ical/086okoggkv7c4b0dcbbrj230s8%40group.calendar.google.com/public/basic.ics"
upcoming_meetings <- read_ical(public_calendar_link)

meetings_to_add <- upcoming_meetings %>%
    transmute(year = year(DTSTART),
              date = as.character(as_date(DTSTART))) %>%
    filter(year == "2023")

meeting_label <- get_board_labels(board_url, token = token) %>%
    filter(name == "Meeting") %>%
    pull(id)

zoom_link <- askpass("Add Zoom link.")
zoom_passcode <- askpass("Add Zoom passcode.")
template_card_desc <- read_lines(here::here("R/card-template.md")) %>%
    whisker::whisker.render(data = list(
        passcode = zoom_passcode,
        link = zoom_link
    ))

meetings_to_add$date %>%
    walk(
        ~ add_card(
            upcoming_board_id,
            body = list(
                name = .x,
                desc = template_card_desc,
                pos = "bottom",
                idLabels = array(meeting_label)
            ),
            token = token
        )
    )
