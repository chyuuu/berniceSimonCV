timeline_map_edc_ordering <- function(order_protocols) {

  library(dplyr)
  library(tidyr)
  library(stringr)

  order_protocols <- order_protocols %>%
    arrange(EDC_SUBJID, ICF_DATE) %>%
    group_by(EDC_SUBJID) %>%
    # creates sequential ID columns for protocol versions and ICF dates per subject
    mutate(PROTOCOL_VERSION_ID = row_number(), ICF_DATE_ID = row_number()) %>%
    # converts data from long to wide format based on protocol version and ICF date
    pivot_wider(names_from = PROTOCOL_VERSION_ID, values_from = PROTOCOL_VERSION, names_prefix = "PROTOCOL_VERSION_") %>%
    pivot_wider(names_from = ICF_DATE_ID, values_from = ICF_DATE, names_prefix = "ICF_DATE_") %>%
    # collapses multiple protocol versions and ICF dates into single string per subject
    summarise(across(starts_with(c("PROTOCOL_VERSION", "ICF_DATE")), 
                      ~ paste(na.omit(unique(.)), collapse = ", "), .names = "{.col}")) %>%
    ungroup()
  
  # converts wide format back to long format
  long_df <- order_protocols %>%
    pivot_longer(cols = starts_with("PROTOCOL_VERSION"), names_to = "PROTOCOL_VERSION_COL", values_to = "PROTOCOL_VERSION") %>%
    pivot_longer(cols = starts_with("ICF_DATE"), names_to = "ICF_DATE_COL", values_to = "ICF_DATE") %>%
    # retains rows where protocol version and ICF date indices match
    filter(str_extract(PROTOCOL_VERSION_COL, "\\d+$") == str_extract(ICF_DATE_COL, "\\d+$"))
  

  result_df <- long_df %>%
  # checks for instances where if there are multiple consents to the SAME PROTOCOL_VERSION with the DIFFERENT ICF_DATEs, those entries are flagged. no filter is involved and no earlier date is selected as <sponsor> wants us to still retain all these dates for their record (and this doesn't affect collection group assignment/pipeline breaking).

  # ex subject: EDC_SUBJID = 003 from Veeva EDC:
  # subject had 2 rows of PA6 with ICF_DATEs: 09 Mar 2025 and 14 Apr 2025
  # the check will flag both rows with the message below.
    group_by(EDC_SUBJID, PROTOCOL_VERSION) %>%
    mutate(FLAG = ifelse(n_distinct(ICF_DATE) > 1, 
                          "Subject was found to be assigned to multiple, differing ICF_DATEs with the same PROTOCOL_VERSION.", 
                          NA_character_)) %>%
    ungroup() %>%
  # checks for instances where if there are DIFFERENT PROTOCOL_VERSIONs with the SAME ICF_DATEs, flag only the most recent PROTOCOL_VERSION
  # ex subject: EDC_SUBJID = 014 from Veeva EDC 
  # subject was assigned to PA4 and PA7 with ICF_DATE 28 Jul 2023
  # this check will flag the row of PA7 with date of 28 Jul 2023 as it is the most recent PROTOCOL_VERSION
    group_by(EDC_SUBJID, ICF_DATE) %>%
    mutate(FLAG = ifelse(n() > 1 & PROTOCOL_VERSION == max(PROTOCOL_VERSION), 
                          coalesce(FLAG, "") %>% paste0("Subject was assigned to different PROTOCOL_VERSIONs with the SAME ICF_DATE."), 
                          FLAG)) %>%
    # retain only rows with the maximum protocol version per ICF date. this is for subjects that don't have a flag (and we wouldn't want to lose those now would we ;-;)
    filter(PROTOCOL_VERSION == max(PROTOCOL_VERSION)) %>%
    ungroup()
  
  # merge flags back into the dataset and clean up
  final_df <- long_df %>%
    select(EDC_SUBJID, PROTOCOL_VERSION, ICF_DATE) %>%
    left_join(result_df, by = c("EDC_SUBJID", "PROTOCOL_VERSION", "ICF_DATE")) %>%
    # remove rows with missing or empty protocol version and ICF date
    filter(!(is.na(PROTOCOL_VERSION) & is.na(ICF_DATE))) %>%
    filter(!(PROTOCOL_VERSION == "" & ICF_DATE == "")) %>%
    select(EDC_SUBJID, PROTOCOL_VERSION, ICF_DATE, FLAG)
  
  # further filtering to remove duplicate ICF assignments with lower protocol versions
  final_filter <- final_df %>%
  # concatenates EDC_SUBJID and ICF_DATE to new column SUBJ_ICF_CONCAT
    mutate(SUBJ_ICF_CONCAT = paste0(EDC_SUBJID, ICF_DATE)) %>%
    group_by(SUBJ_ICF_CONCAT) %>%
    # counts the # of occurrences the concat of EDC_SUBJID and ICF_DATE occurs (this for the final clean up of the second flag assigned in the result_df function above)
    mutate(SUBJ_ICF_CONCAT_COUNT = n(),
            MAX_PROT_VER = max(PROTOCOL_VERSION, na.rm = TRUE),
            REMOVE_ICF = ifelse(SUBJ_ICF_CONCAT_COUNT > 1 & PROTOCOL_VERSION != MAX_PROT_VER, "REMOVE ROW", NA_character_)) %>%
    ungroup() %>%
    # retain only rows that do not need removal (retain rows of the highest protocol version per ICF date)
    filter(is.na(REMOVE_ICF)) %>%
    # only return the 4 columns listed to the output of the spec
    select(EDC_SUBJID, PROTOCOL_VERSION, ICF_DATE, FLAG)
  
  return(final_filter)
}