# dynamic filtering
filter_latest_date <- function(df) {
    # identify columns that end with "_DATE"
    date_cols <- names(df)[grepl("_DATE$", names(df))]

    # convert all detected date columns to Date type (if not already)
    df[date_cols] <- lapply(df[date_cols], as.Date)

    # find the latest date column based on max values # nolint: indentation_linter.
    latest_date_col <- date_cols[which.max(sapply(df[date_cols], max, na.rm = TRUE))] # nolint: line_length_linter.

    # filter for the latest date for each subject
    df_latest <- df %>%
        dplyr::group_by(EDC_SUBJID) %>%
        dplyr::filter(.data[[latest_date_col]] == max(.data[[latest_date_col]], na.rm = TRUE)) %>%
        dplyr::ungroup()

    return(df_latest)
}
