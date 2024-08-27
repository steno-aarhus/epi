
# To prevent accidental sourcing
stop("This script is not meant to be sourced. Run it interactively.")

# install.packages("pak")
pak::pak("steno-aarhus/sdcar")
rstudioapi::restartSession()

# See the `vignettes/articles/epi-group.Rmd` doc on the sdcar package
# repository for details about this code.
library(sdcar)

current_sessions <- epi_get_calendar(here::here("calendar.ics"))

upcoming_sessions <- lubridate::as_datetime(c(
  "2024-01-06 13:00:00",
  "2024-02-03 13:00:00",
  "2024-03-03 13:00:00",
  "2024-03-31 13:00:00",
  "2024-05-05 13:00:00",
  "2024-06-02 13:00:00",
  "2024-09-01 13:00:00",
  "2024-10-06 13:00:00",
  "2024-11-03 13:00:00",
  "2024-12-01 13:00:00"
), tz = "Europe/Copenhagen")

upcoming_events <- epi_create_sessions(
  start = upcoming_sessions,
  end = upcoming_sessions + lubridate::hours(2)
)

updated_calendar <- current_sessions |>
  epi_add_sessions(upcoming_events)

updated_calendar |>
  write_ical(here::here("calendar.ics"))

# This takes a bit of time if there are a lot of dates
upcoming_sessions |>
  epi_create_session_issues()
