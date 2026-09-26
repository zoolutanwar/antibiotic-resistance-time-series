library(forecast)

ts_data <- readRDS(
  "data/processed/resistance_ts.rds"
)

n <- length(ts_data)
test_size <- min(5, floor(n / 4))

if (n - test_size < 10) {
  stop("The time series is too short for the selected holdout design.")
}

train <- window(
  ts_data,
  end = time(ts_data)[n - test_size]
)

test <- window(
  ts_data,
  start = time(ts_data)[n - test_size + 1]
)

naive_model <- naive(train, h = test_size)
drift_model <- rwf(train, h = test_size, drift = TRUE)
ets_model <- ets(train)
arima_model <- auto.arima(
  train,
  seasonal = FALSE,
  stepwise = FALSE,
  approximation = FALSE
)

fc_naive <- forecast(naive_model, h = test_size)
fc_drift <- forecast(drift_model, h = test_size)
fc_ets <- forecast(ets_model, h = test_size)
fc_arima <- forecast(arima_model, h = test_size)

accuracy_table <- rbind(
  Naive = accuracy(fc_naive, test)[2, c("MAE", "RMSE")],
  Drift = accuracy(fc_drift, test)[2, c("MAE", "RMSE")],
  ETS = accuracy(fc_ets, test)[2, c("MAE", "RMSE")],
  ARIMA = accuracy(fc_arima, test)[2, c("MAE", "RMSE")]
)

accuracy_table <- data.frame(
  Model = rownames(accuracy_table),
  accuracy_table,
  row.names = NULL
)

write.csv(
  accuracy_table,
  "results/tables/model_accuracy.csv",
  row.names = FALSE
)

model_name <- accuracy_table$Model[
  which.min(accuracy_table$RMSE)
]

write.csv(
  data.frame(Selected_Model = model_name),
  "results/tables/selected_model.csv",
  row.names = FALSE
)

saveRDS(
  list(
    train = train,
    test = test,
    naive = naive_model,
    drift = drift_model,
    ets = ets_model,
    arima = arima_model,
    accuracy = accuracy_table,
    selected_model = model_name
  ),
  "data/processed/model_results.rds"
)
