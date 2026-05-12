install.packages("pacman")
pacman::p_load(tidyverse, tidytuesdayR, broom, modelr, scales, viridis)

raw_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2022/2022-03-22/babynames.csv')

# Analysis 1: Conformity Index
conformity_df <- raw_data %>%
  group_by(year, sex) %>%
  mutate(rank = min_rank(desc(prop))) %>%
  filter(rank <= 10) %>%
  summarize(top10_share = sum(prop), total_n = sum(n), .groups = "drop")

plot_area <- ggplot(conformity_df, aes(x = year, y = top10_share, fill = sex)) +
  geom_area(alpha = 0.7) +
  facet_wrap(~sex) +
  scale_y_continuous(labels = percent) +
  labs(title = "The Shrinking Influence of Traditional Names", 
       y = "Top 10 Market Share", fill = "Sex") +
  theme_minimal()
print(plot_area)
ggsave("analysis_plots/02_conformity_area.png", plot_area, width = 8, height = 6)

# Analysis 2: Phonetic Feature Extraction
df_clean <- raw_data %>%
  mutate(last_letter = str_sub(name, -1))

# Analysis 3: Skewness Analysis
plot_skew <- ggplot(df_clean %>% filter(year == 2017), aes(x = n)) +
  geom_histogram(fill = "steelblue", bins = 40) +
  scale_x_log10() +
  labs(title = "Log-Normal Distribution of Naming Frequency (2017)", 
       subtitle = "Justifying the use of Log-transformations for linear modeling",
       x = "Count (Log Scale)", y = "Frequency") +
  theme_minimal()

print(plot_skew)
ggsave("analysis_plots/01_distribution_skew.png", plot_skew, width = 8, height = 6)

# Analysis 4: Simple Linear Regression 
m1_conformity <- lm(top10_share ~ year, data = conformity_df)
print(summary(m1_conformity))

# Analysis 5: Adjusted Multiple Regression 
m2_adjusted <- lm(top10_share ~ year + sex + total_n, data = conformity_df)
print(summary(m2_adjusted))
plot_neutral <- raw_data %>%
  group_by(year, name) %>%
  summarize(m_ratio = sum(n[sex=="M"])/sum(n), total = sum(n), .groups = "drop") %>%
  filter(total > 500, year %in% c(1880, 1950, 2017)) %>%
  ggplot(aes(x = m_ratio, fill = as.factor(year))) +
  geom_density(alpha = 0.4) +
  labs(title = "Evolution of Gendered Ratios", 
       subtitle = "Ratios closer to 0.5 indicate gender-neutral naming",
       fill = "Year", x = "Gender Ratio (0=F, 1=M)") +
  theme_minimal()
print(plot_neutral)
ggsave("analysis_plots/03_gender_neutrality.png", plot_neutral, width = 8, height = 6)

# Analysis 6: Phonetic Entropy 
entropy_df <- df_clean %>%
  group_by(year) %>%
  summarize(unique_endings = n_distinct(last_letter))

m3_entropy <- lm(unique_endings ~ year, data = entropy_df)
print(summary(m3_entropy))

plot_phone <- df_clean %>%
  group_by(year, last_letter) %>%
  summarize(count = sum(n), .groups = "drop") %>%
  filter(last_letter %in% c("a", "n", "y", "e", "r")) %>%
  ggplot(aes(x = year, y = count, color = last_letter)) +
  geom_line(size = 1) +
  labs(title = "Phonetic Evolution of Name Endings", 
       y = "Total Births", color = "Last Letter") +
  theme_minimal()
print(plot_phone)
ggsave("analysis_plots/04_phonetic_trends.png", plot_phone, width = 8, height = 6)

# Analysis 7: Sensitivity Analysis
m4_sensitivity <- df_clean %>%
  filter(n > 100) %>%
  group_by(year) %>%
  summarize(diversity_score = n_distinct(name)) %>%
  lm(diversity_score ~ year, data = .)

print(summary(m4_sensitivity))

plot_long <- raw_data %>%
  group_by(name, sex) %>%
  filter(prop >= quantile(prop, 0.99)) %>%
  summarize(years_at_peak = n(), start_year = min(year), .groups = "drop") %>%
  ggplot(aes(x = start_year, y = years_at_peak)) +
  geom_point(alpha = 0.1, color = "darkgreen") +
  geom_smooth(method = "loess", color = "red", se = FALSE) + 
  labs(title = "Cultural Velocity", 
       subtitle = "Shrinking peak-popularity lifespans over time",
       x = "Year Name First Became Popular", y = "Years at Peak") +
  theme_minimal()
print(plot_long)
ggsave("analysis_plots/05_cultural_velocity.png", plot_long, width = 8, height = 6)

plot_qq <- ggplot(m1_conformity, aes(sample = .resid)) +
  stat_qq(color = "steelblue") +
  stat_qq_line(color = "red") +
  labs(title = "Model Diagnostic: Normal Q-Q Plot of Residuals") +
  theme_minimal()

print(plot_qq)
ggsave("analysis_plots/06_diagnostic_qq.png", plot_qq, width = 8, height = 6)

print("All analyses complete. Plots have been printed and saved to 'analysis_plots/' folder.")
