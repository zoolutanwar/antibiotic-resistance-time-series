# Time-Series Analysis of Antimicrobial Resistance in *Escherichia coli*

## Project overview

This project analyses the annual behaviour of antimicrobial resistance in *Escherichia coli* using European surveillance data from the European Centre for Disease Prevention and Control (ECDC).

The current analysis focuses on resistance to third-generation cephalosporins and follows a time-series workflow:

1. Data import and validation
2. Selection of the study population and variables
3. Missing-value assessment
4. Country-level temporal imputation
5. Annual European aggregation
6. Exploratory time-series analysis
7. Stationarity assessment
8. Time-series model fitting
9. Residual diagnostics
10. Out-of-sample model comparison
11. Forecast generation

A later extension will combine resistance with antibiotic-consumption data to investigate contemporaneous and lagged associations.

## Research questions

### Primary question

How has resistance in *E. coli* to third-generation cephalosporins changed over time in the European surveillance data?

### Modelling question

Which time-series model provides an adequate description of the annual resistance series and useful forecasts?

### Extension question

Is antibiotic consumption associated with subsequent antimicrobial resistance, and does the association depend on time lags?

## Dataset

The project uses:

`ECDC_surveillance_data_Antimicrobial_resistance.csv`

The analysis uses the following fields:

| Field | Role |
|---|---|
| `RegionName` | Country/region |
| `Time` | Observation year |
| `NumValue` | Resistance percentage |
| `HealthTopic` | Surveillance topic |
| `Population` | Organism/population |
| `Indicator` | Resistance indicator |

The raw ECDC CSV is placed in `data/raw/`.

## Data preparation

The selected country-year observations are converted to numeric form, ordered chronologically within country, and checked for missing resistance values.

Missing observations are not removed automatically from the raw working series. The missingness pattern is first quantified by country and year.

For internal gaps in a country's time series, linear interpolation is used as the initial imputation method. Interpolation is performed separately for each country so that values from one country are never used to construct another country's observations. Leading and trailing missing values remain missing because interpolation cannot estimate them without observations on both sides.

The imputation stage records the number of values that were estimated and the number of missing values that remain.

## European aggregation

For each year, the annual arithmetic mean across available country observations is calculated:

$$
\bar{Y}_t = \frac{1}{N_t}\sum_{i=1}^{N_t}Y_{it}
$$

where \(Y_{it}\) is the resistance percentage for country \(i\) in year \(t\), and \(N_t\) is the number of contributing country observations.

Annual standard deviation and the number of contributing country observations are retained alongside the mean.

## Exploratory analysis

The exploratory stage produces:

- annual mean resistance;
- annual cross-country standard deviation;
- annual country coverage;
- the resistance time-series plot.

The observed direction of the series is treated as a descriptive result. Formal inference is reserved for the subsequent statistical modelling stage.

## Time-series modelling

The modelling stage evaluates:

- naive benchmark;
- drift benchmark;
- exponential smoothing;
- ARIMA.

Stationarity is assessed using the Augmented Dickey-Fuller test together with ACF and PACF plots. Model residuals are examined using residual plots and the Ljung-Box test.

For forecasting, the final observations are held out as a test set. Models are compared using out-of-sample MAE and RMSE rather than selecting a model only from in-sample fit.

The full dataset is then used to refit the selected modelling approach before producing the final forecast.

## Antibiotic-consumption extension

A subsequent stage will combine the resistance series with an appropriately matched antibiotic-consumption series.

A possible dynamic specification is:

$$
Resistance_t =
\beta_0 +
\beta_1 Consumption_t +
\beta_2 Consumption_{t-1} +
u_t
$$

where \(Consumption_{t-1}\) represents consumption in the preceding year.

The final model will be determined after checking stationarity, autocorrelation, lag structure and residual behaviour. The analysis will distinguish association from causation.

## Repository structure

```text
antibiotic-resistance-time-series/
├── data/
│   ├── raw/
│   └── processed/
├── R/
│   ├── 01_data_import_exploration.R
│   ├── 02_data_preprocessing.R
│   ├── 03_missing_value_analysis.R
│   ├── 04_missing_value_imputation.R
│   ├── 05_eu_aggregation.R
│   ├── 06_exploratory_analysis.R
│   ├── 07_stationarity_analysis.R
│   ├── 08_time_series_models.R
│   ├── 09_model_diagnostics.R
│   └── 10_forecasting.R
├── results/
│   ├── figures/
│   └── tables/
├── report/
├── .gitignore
├── LICENSE
└── README.md
```

## Reproducibility

Run the R scripts in numerical order from the repository root.

Required packages:

```r
install.packages(c(
  "dplyr",
  "ggplot2",
  "zoo",
  "tseries",
  "forecast"
))
```

The raw dataset is intentionally kept separate from generated outputs. The scripts create processed datasets, tables and figures under `data/processed/` and `results/`.

## Current status

The repository is structured to contain the complete analysis pipeline. The numerical results produced by the repository should always be regenerated from the ECDC data rather than manually entered into the documentation.

## Limitations

- Country participation varies across years.
- Missingness may not be completely random.
- Equal-weight annual means give each contributing country the same weight.
- Imputation introduces estimated rather than observed values.
- Forecast uncertainty increases with forecast horizon.
- Aggregate time-series association does not establish a causal relationship.
