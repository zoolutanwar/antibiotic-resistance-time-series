library(forecast)

model_results <- readRDS(
  "data/processed/model_results.rds"
)

ts_data <- readRDS(
  "data/processed/resistance_ts.rds"
)

selected_model <- model_results$selected_model

final_fit <- switch(
  selected_model,
  Naive = naive(ts_data, h = 5),
  Drift = rwf(ts_data, h = 5, drift = TRUE),
  ETS = forecast(ets(ts_data), h = 5),
  ARIMA = forecast(
    auto.arima(
      ts_data,
      seasonal = FALSE,
      stepwise = FALSE,
      approximation = FALSE
    ),
    h = 5
  )
)

if (selected_model %in% c("Naive", "Drift")) {
  final_forecast <- final_fit
} else {
  final_forecast <- final_fit
}

forecast_table <- data.frame(
  Year = as.numeric(time(final_forecast$mean)),
  Forecast = as.numeric(final_forecast$mean),
  Lower_80 = as.numeric(final_forecast$lower[, 1]),
  Upper_80 = as.numeric(final_forecast$upper[, 1]),
  Lower_95 = as.numeric(final_forecast$lower[, 2]),
  Upper_95 = as.numeric(final_forecast$upper[, 2])
)

write.csv(
  forecast_table,
  "results/tables/five_year_forecast.csv",
  row.names = FALSE
)

png(
  "results/figures/five_year_forecast.png",
  width = 1100,
  height = 700
)
plot(
  final_forecast,
  main = paste("Five-Year Forecast:", selected_model),
  xlab = "Year",
  ylab = "Resistance (%)"
)
dev.off()
