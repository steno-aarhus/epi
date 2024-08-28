
# To prevent accidental sourcing
stop("This script is not meant to be sourced. Run it interactively.")

# install.packages("pak")
pak::pak("steno-aarhus/sdcar")
rstudioapi::restartSession()

# See the `vignettes/articles/epi-group.Rmd` doc on the sdcar package
# repository for details about this code.
library(sdcar)

# Add to calendar ---------------------------------------------------------

# TODO: This section doesn't work as expected.
# This section creates an ical file that will need to be manually uploaded to
# the Google Calendar (that Luke manages right now).
upcoming_sessions <- lubridate::as_datetime(c(
  "2025-01-06 13:00:00",
  "2025-02-03 13:00:00",
  "2025-03-03 13:00:00",
  "2025-03-31 13:00:00",
  "2025-05-05 13:00:00",
  "2025-06-02 13:00:00",
  "2025-09-01 13:00:00",
  "2025-10-06 13:00:00",
  "2025-11-03 13:00:00",
  "2025-12-01 13:00:00"
), tz = "Europe/Copenhagen")

upcoming_events <- epi_create_sessions(
  start = upcoming_sessions,
  end = upcoming_sessions + lubridate::hours(2)
)

upcoming_events |>
  write_ical(here::here("R/new-events.ics"))

# TODO: Convert the below code ical file is on GitHub repo, rather than Google.
# This part doesn't work yet.
# current_sessions <- epi_get_calendar()

# updated_calendar <- current_sessions |>
#   epi_add_sessions(upcoming_events)
#
# updated_calendar |>
#   write_ical(here::here("calendar.ics"))

# Add to GitHub -----------------------------------------------------------

# This takes a bit of time if there are a lot of dates
upcoming_sessions |>
  epi_create_session_issues()
