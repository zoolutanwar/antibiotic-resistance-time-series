library(dplyr)

ecoli <- read.csv(
  "data/processed/ecoli_imputed.csv",
  stringsAsFactors = FALSE
)

ecoli$Time <- as.numeric(ecoli$Time)
ecoli$NumValue_Final <- as.numeric(ecoli$NumValue_Final)

eu_avg <- ecoli %>%
  group_by(Time) %>%
  summarise(
    EU_Mean = mean(NumValue_Final, na.rm = TRUE),
    EU_SD = sd(NumValue_Final, na.rm = TRUE),
    Countries = sum(!is.na(NumValue_Final)),
    .groups = "drop"
  ) %>%
  arrange(Time)

eu_avg$EU_Mean[is.nan(eu_avg$EU_Mean)] <- NA_real_
eu_avg$EU_SD[is.nan(eu_avg$EU_SD)] <- NA_real_

write.csv(
  eu_avg,
  "data/processed/eu_annual_resistance.csv",
  row.names = FALSE
)

write.csv(
  eu_avg,
  "results/tables/eu_annual_resistance.csv",
  row.names = FALSE
)

print(eu_avg)
