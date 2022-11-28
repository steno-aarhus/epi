source(here::here("R/functions.R"))
# library(assertr)
library(tidyverse)
library(lubridate)
library(calendar)
library(glue)

stop("This prevents accidentally sourcing the whole script.")

meeting_dates <- tribble(
  ~month, ~day,
  "January", 9,
  "February", 6,
  "March", 6,
  "March", 24,
  "May", 1,
  "June", 5,
  "September", 4,
  "October", 9,
  "November", 6,
  "December", 4
) %>%
  mutate(
    year = "2023",
    date = ymd(glue("{year}-{month}-{day}"), tz = "Europe/Copenhagen"),
    start_time = "13:00",
    end_time = "15:00"
  )

upcoming_meetings <- meeting_dates %>%
  transmute(
    UID = map_chr(1:n(), ~ ic_guid()),
    DTSTART = ymd_hm(glue("{date} {start_time}"), tz = "Europe/Copenhagen"),
    DTEND = ymd_hm(glue("{date} {end_time}"), tz = "Europe/Copenhagen"),
    # To show up as the event description
    DESCRIPTION = "Details about the meeting are found on the Trello board: https://trello.com/b/ipcYGXhC/epidemiology-group",
    # To show up as the event title
    SUMMARY = "Steno Aarhus Epidemiology Group Monthly Meeting"
  )

public_calendar_link <- "https://calendar.google.com/calendar/ical/086okoggkv7c4b0dcbbrj230s8%40group.calendar.google.com/public/basic.ics"
current_calendar <- read_ical(public_calendar_link) %>%
  select(DTSTART, DTEND, SUMMARY)

new_calendar_data <- anti_join(upcoming_meetings, current_calendar)

ic_write(ical(new_calendar_data), here::here("R/calendar.ics"))
