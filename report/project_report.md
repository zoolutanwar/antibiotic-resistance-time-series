# Project Report

## Title

**Time-Series Analysis of Antimicrobial Resistance in *Escherichia coli***

## 1. Background

Antimicrobial resistance is a major public-health concern because increasing resistance can reduce the effectiveness of commonly used antimicrobial treatments. Surveillance systems provide repeated observations over time, making time-series methods suitable for studying temporal patterns and forecasting future resistance levels.

## 2. Aim

The aim of this project is to analyse the temporal behaviour of antimicrobial resistance in *Escherichia coli* to third-generation cephalosporins using European surveillance data and to develop statistical models for describing and forecasting the resulting annual resistance series.

## 3. Data preparation

The ECDC surveillance dataset was imported into R. The variables required for the analysis were selected and converted to appropriate numeric formats.

Country and year were retained as the geographic and temporal identifiers, while the resistance percentage was used as the response variable.

## 4. Missing-value analysis

Missing resistance observations were quantified by country and by year before aggregation.

Because the data have a temporal structure within countries, internal missing observations can be estimated using country-specific linear interpolation. Leading and trailing missing observations are not automatically extrapolated.

The imputation results are stored in:

`results/tables/imputation_summary.csv`

## 5. European aggregation

An annual European mean was calculated from the contributing country observations. The annual standard deviation and number of contributing observations were also retained.

$$
\bar{Y}_t = \frac{1}{N_t}\sum_{i=1}^{N_t}Y_{it}
$$

## 6. Exploratory analysis

The project produces three main exploratory figures:

- annual mean resistance;
- annual cross-country standard deviation;
- annual country coverage.

The trend figure is stored in:

`results/figures/eu_resistance_trend.png`

## 7. Statistical modelling

The modelling stage evaluates benchmark and time-series models using a chronological train-test split.

The candidate models are:

- Naive
- Drift
- Exponential Smoothing
- ARIMA

Models are compared using out-of-sample MAE and RMSE.

## 8. Diagnostics

The selected model is examined using residual diagnostics and the Ljung-Box test. The purpose is to assess whether the remaining residual structure is consistent with an adequate forecasting model.

## 9. Forecasting

After model comparison, the selected approach is refitted using the full annual series. Five-year forecasts are generated with 80% and 95% prediction intervals.

## 10. Future extension

The next stage will integrate antibiotic-consumption data and examine contemporaneous and lagged relationships between consumption and resistance.

A possible dynamic specification is:

$$
Resistance_t =
\beta_0 +
\beta_1 Consumption_t +
\beta_2 Consumption_{t-1} +
u_t
$$

The final specification will depend on stationarity, autocorrelation, lag structure and diagnostic results.

## 11. Limitations

The analysis is subject to variation in country participation, missing observations and the assumptions introduced by imputation. Equal-weight aggregation also means that countries contribute equally to the annual mean regardless of population size or surveillance volume. Forecasts become increasingly uncertain as the forecast horizon increases.
