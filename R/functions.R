read_ical <- function(ics) {
  read_lines(ics) %>%
    # annoyingly have to do this processing because calendar::ic_read() doesn't work well
    str_c(collapse = "\n\n") %>%
    str_replace_all("\n ", " ") %>%
    str_split("\n\n") %>%
    unlist() %>%
    ic_list() %>%
    map_dfr(ic_vector) %>%
    mutate(across(matches("VALUE=DATE"), as_date)) %>%
    mutate(across(matches("^(DTSTART|DTEND)$"), as_datetime)) %>%
    mutate(
      DTSTART = with_tz(ymd_hms(DTSTART), "Europe/Copenhagen"),
      DTEND = with_tz(ymd_hms(DTEND), "Europe/Copenhagen")
    ) %>%
    arrange(DTSTART)
}
