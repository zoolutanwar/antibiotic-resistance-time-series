library(forecast)

model_results <- readRDS(
  "data/processed/model_results.rds"
)

selected_model <- model_results$selected_model

fit <- switch(
  selected_model,
  Naive = model_results$naive,
  Drift = model_results$drift,
  ETS = model_results$ets,
  ARIMA = model_results$arima
)

residuals_selected <- residuals(fit)

png(
  "results/figures/selected_model_residuals.png",
  width = 1000,
  height = 700
)
checkresiduals(fit)
dev.off()

lb <- Box.test(
  residuals_selected,
  lag = min(10, floor(length(residuals_selected) / 3)),
  type = "Ljung-Box"
)

diagnostics <- data.frame(
  Model = selected_model,
  Ljung_Box_Statistic = unname(lb$statistic),
  Ljung_Box_P_Value = lb$p.value
)

write.csv(
  diagnostics,
  "results/tables/model_diagnostics.csv",
  row.names = FALSE
)
