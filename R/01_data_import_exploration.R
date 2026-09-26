library(dplyr)

data <- read.csv(
  "data/raw/ECDC_surveillance_data_Antimicrobial_resistance.csv",
  stringsAsFactors = FALSE
)

required_columns <- c(
  "RegionName", "Time", "NumValue",
  "Indicator", "HealthTopic", "Population"
)

missing_columns <- setdiff(required_columns, names(data))

if (length(missing_columns) > 0) {
  stop(
    paste(
      "Required columns are missing:",
      paste(missing_columns, collapse = ", ")
    )
  )
}

data$Time <- as.numeric(data$Time)
data$NumValue <- as.numeric(data$NumValue)

cat("Rows:", nrow(data), "\n")
cat("Columns:", ncol(data), "\n")
cat("Year range:", min(data$Time, na.rm = TRUE), "-", max(data$Time, na.rm = TRUE), "\n")
cat("Regions:", length(unique(data$RegionName)), "\n")

print(sort(unique(data$Time)))
print(unique(data$Indicator))
print(unique(data$HealthTopic))
print(unique(data$Population))

write.csv(
  data,
  "data/processed/imported_data.csv",
  row.names = FALSE
)
