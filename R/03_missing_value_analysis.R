library(dplyr)
library(ggplot2)

ecoli <- read.csv(
  "data/processed/ecoli_selected.csv",
  stringsAsFactors = FALSE
)

ecoli$Time <- as.numeric(ecoli$Time)
ecoli$NumValue <- as.numeric(ecoli$NumValue)

missing_by_country <- ecoli %>%
  group_by(RegionName) %>%
  summarise(
    Missing = sum(is.na(NumValue)),
    Total = n(),
    Missing_Percentage = 100 * Missing / Total,
    .groups = "drop"
  )

missing_by_year <- ecoli %>%
  group_by(Time) %>%
  summarise(
    Missing = sum(is.na(NumValue)),
    Total = n(),
    Missing_Percentage = 100 * Missing / Total,
    .groups = "drop"
  )

missing_summary <- data.frame(
  Total_Observations = nrow(ecoli),
  Missing_Observations = sum(is.na(ecoli$NumValue)),
  Missing_Percentage = 100 * sum(is.na(ecoli$NumValue)) / nrow(ecoli)
)

write.csv(
  missing_summary,
  "results/tables/missing_summary.csv",
  row.names = FALSE
)

write.csv(
  missing_by_country,
  "results/tables/missing_by_country.csv",
  row.names = FALSE
)

write.csv(
  missing_by_year,
  "results/tables/missing_by_year.csv",
  row.names = FALSE
)

p <- ggplot(
  missing_by_year,
  aes(x = Time, y = Missing)
) +
  geom_col() +
  labs(
    title = "Missing Resistance Observations by Year",
    x = "Year",
    y = "Missing observations"
  ) +
  theme_minimal()

ggsave(
  "results/figures/missing_values_by_year.png",
  p,
  width = 9,
  height = 5,
  dpi = 300
)
