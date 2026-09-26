library(dplyr)
library(zoo)

ecoli <- read.csv(
  "data/processed/ecoli_selected.csv",
  stringsAsFactors = FALSE
)

ecoli$Time <- as.numeric(ecoli$Time)
ecoli$NumValue <- as.numeric(ecoli$NumValue)

ecoli_imputed <- ecoli %>%
  arrange(RegionName, Time) %>%
  group_by(RegionName) %>%
  mutate(
    NumValue_Imputed = na.approx(
      NumValue,
      x = Time,
      na.rm = FALSE
    )
  ) %>%
  ungroup() %>%
  mutate(
    Imputed = is.na(NumValue) & !is.na(NumValue_Imputed),
    NumValue_Final = NumValue_Imputed
  )

imputation_summary <- data.frame(
  Missing_Before = sum(is.na(ecoli_imputed$NumValue)),
  Values_Imputed = sum(ecoli_imputed$Imputed),
  Missing_After = sum(is.na(ecoli_imputed$NumValue_Final))
)

write.csv(
  imputation_summary,
  "results/tables/imputation_summary.csv",
  row.names = FALSE
)

write.csv(
  ecoli_imputed,
  "data/processed/ecoli_imputed.csv",
  row.names = FALSE
)
