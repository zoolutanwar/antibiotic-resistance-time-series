library(dplyr)

data <- read.csv(
  "data/processed/imported_data.csv",
  stringsAsFactors = FALSE
)

ecoli <- data %>%
  filter(
    grepl("Escherichia coli", Population, ignore.case = TRUE)
  ) %>%
  select(
    RegionName,
    Time,
    NumValue,
    Indicator,
    HealthTopic,
    Population
  ) %>%
  mutate(
    Time = as.numeric(Time),
    NumValue = as.numeric(NumValue)
  ) %>%
  arrange(RegionName, Time)

if (nrow(ecoli) == 0) {
  stop("No Escherichia coli observations were found.")
}

write.csv(
  ecoli,
  "data/processed/ecoli_selected.csv",
  row.names = FALSE
)

cat("Selected observations:", nrow(ecoli), "\n")
cat("Countries/regions:", length(unique(ecoli$RegionName)), "\n")
cat("Missing resistance values:", sum(is.na(ecoli$NumValue)), "\n")
