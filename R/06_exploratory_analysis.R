library(ggplot2)

eu_avg <- read.csv(
  "data/processed/eu_annual_resistance.csv",
  stringsAsFactors = FALSE
)

eu_avg$Time <- as.numeric(eu_avg$Time)
eu_avg$EU_Mean <- as.numeric(eu_avg$EU_Mean)
eu_avg$EU_SD <- as.numeric(eu_avg$EU_SD)
eu_avg$Countries <- as.numeric(eu_avg$Countries)

p_mean <- ggplot(
  eu_avg,
  aes(x = Time, y = EU_Mean)
) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  labs(
    title = "EU Average E. coli Resistance to Third-Generation Cephalosporins",
    x = "Year",
    y = "Resistance (%)"
  ) +
  theme_minimal()

p_sd <- ggplot(
  eu_avg,
  aes(x = Time, y = EU_SD)
) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  labs(
    title = "Cross-Country Variation in E. coli Resistance",
    x = "Year",
    y = "Standard deviation (%)"
  ) +
  theme_minimal()

p_coverage <- ggplot(
  eu_avg,
  aes(x = Time, y = Countries)
) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  labs(
    title = "Country Coverage by Year",
    x = "Year",
    y = "Contributing observations"
  ) +
  theme_minimal()

ggsave(
  "results/figures/eu_resistance_trend.png",
  p_mean,
  width = 9,
  height = 5.5,
  dpi = 300
)

ggsave(
  "results/figures/eu_resistance_sd.png",
  p_sd,
  width = 9,
  height = 5.5,
  dpi = 300
)

ggsave(
  "results/figures/country_coverage_by_year.png",
  p_coverage,
  width = 9,
  height = 5.5,
  dpi = 300
)
