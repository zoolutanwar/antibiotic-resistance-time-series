library(tseries)

eu_avg <- read.csv(
  "data/processed/eu_annual_resistance.csv",
  stringsAsFactors = FALSE
)

eu_avg <- eu_avg[!is.na(eu_avg$EU_Mean), ]

ts_data <- ts(
  eu_avg$EU_Mean,
  start = min(eu_avg$Time),
  frequency = 1
)

adf_level <- adf.test(ts_data)

acf_png <- "results/figures/acf_level.png"
png(acf_png, width = 900, height = 600)
acf(ts_data, main = "ACF of Annual Resistance Series")
dev.off()

pacf_png <- "results/figures/pacf_level.png"
png(pacf_png, width = 900, height = 600)
pacf(ts_data, main = "PACF of Annual Resistance Series")
dev.off()

difference_needed <- FALSE
adf_difference <- NULL

if (adf_level$p.value > 0.05) {
  difference_needed <- TRUE
  differenced <- diff(ts_data)
  adf_difference <- adf.test(differenced)

  png(
    "results/figures/acf_first_difference.png",
    width = 900,
    height = 600
  )
  acf(differenced, main = "ACF of First-Differenced Series")
  dev.off()

  png(
    "results/figures/pacf_first_difference.png",
    width = 900,
    height = 600
  )
  pacf(differenced, main = "PACF of First-Differenced Series")
  dev.off()
}

stationarity_summary <- data.frame(
  ADF_Level_Statistic = unname(adf_level$statistic),
  ADF_Level_P_Value = adf_level$p.value,
  First_Difference_Checked = difference_needed,
  ADF_Difference_Statistic = if (!is.null(adf_difference)) unname(adf_difference$statistic) else NA_real_,
  ADF_Difference_P_Value = if (!is.null(adf_difference)) adf_difference$p.value else NA_real_
)

write.csv(
  stationarity_summary,
  "results/tables/stationarity_summary.csv",
  row.names = FALSE
)

saveRDS(
  ts_data,
  "data/processed/resistance_ts.rds"
)
