# =========================================
# U.S. Adult Obesity Analysis (CDC PLACES)

# Relationship Between Physical Inactivity and Obesity Across U.S. Counties
# =========================================

# 1. Load packages
library(tidyverse)
library(janitor)

# 2. Import data
places <- read_csv(file.choose())

# 3. Search for variable
unique(places$Measure)

# 4. Clean and filter data
# Keep only age-adjusted adult obesity prevalence for 2023
obesity_data <- places %>% 
  filter(Measure == "Obesity among adults",
         Data_Value_Type == "Age-adjusted prevalence",
         Year == 2023) %>% 
  select(Year, StateAbbr, StateDesc, LocationName,
         Measure, Data_Value, TotalPop18plus) %>% 
  rename(obesity_prev_percentage = Data_Value)

obesity_data %>% 
  distinct() %>% 
  count(LocationName, StateDesc) %>% 
  filter(n > 1)

obesity_data <- obesity_data %>%
  group_by(LocationName, StateDesc) %>%
  mutate(obesity_prev_percentage = weighted.mean(obesity_prev_percentage, TotalPop18plus, na.rm = TRUE),
         TotalPop18plus = mean(TotalPop18plus, na.rm = TRUE)) %>% 
  ungroup() %>% 
  distinct(LocationName, StateDesc, .keep_all = TRUE)

clean_obesity_data <- obesity_data %>% 
  select(LocationName, StateDesc, obesity_prev_percentage) %>% 
  rename(Obesity = obesity_prev_percentage)
  

# 5. Clean and filter data
# Keep only age-adjusted adult inactivity prevalence for 2023
inactivity_data <- places %>% 
  filter(Measure == "No leisure-time physical activity among adults",
         Data_Value_Type == "Age-adjusted prevalence",
         Year == 2023) %>% 
  select(Year, StateAbbr, StateDesc, LocationName,
         Measure, Data_Value, TotalPop18plus) %>% 
  rename(inactivity_prev_percentage = Data_Value)

inactivity_data %>% 
  distinct() %>% 
  count(LocationName, StateDesc) %>%
  filter(n > 1)

inactivity_data <- inactivity_data %>% 
  group_by(LocationName, StateDesc) %>% 
  mutate(inactivity_prev_percentage = weighted.mean(inactivity_prev_percentage, TotalPop18plus, na.rm = TRUE),
         TotalPop18plus = mean(TotalPop18plus, na.rm = TRUE)) %>% 
  ungroup() %>% 
  distinct(LocationName, StateDesc, .keep_all = TRUE)

clean_inactivity_data <- inactivity_data %>% 
  select(LocationName, StateDesc, inactivity_prev_percentage) %>% 
  rename(Inactivity = inactivity_prev_percentage)


# 6. Join both datasets
combined_data <- left_join(
  clean_obesity_data, clean_inactivity_data, by = c("LocationName", "StateDesc")
)

# 7. Analyze combined data and check for/remove missing values
summary(combined_data)
sum(is.na(combined_data$Obesity))
sum(is.na(combined_data$Inactivity))

combined_data %>%
  filter(is.na(Obesity) | is.na(Inactivity))

combined_data <- combined_data %>%
  filter(!is.na(Obesity),
         !is.na(Inactivity))

# 8. Plot Obesity vs Inactivity
ob_vs_inac_scatterplot <- ggplot(combined_data, aes(x = Inactivity,
                          y = Obesity)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Relationship Between Physical Inactivity and Adult Obesity Across U.S. Counties",
       x = "Physical Inactivity Prevalence (%)",
       y= "Adult Obesity Prevalence (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  annotate("text",
           x = 15,
           y = 45,
           label = paste0("r =", round(correlation, 3)))

# 9. Add a region column to make the plot look nicer
combined_data <- combined_data %>% 
  mutate(Region = case_when(
    StateDesc %in% c("Alabama", "Mississippi", "Georgia", "Louisiana") ~ "South",
    TRUE ~ "Other"
    ))

count(combined_data, Region)

# 10. Calculate correlation and add to plot
correlation <- cor(combined_data$Inactivity,
    combined_data$Obesity)

# 11. Create a plot on the South vs other
scatterplot_lm <- ggplot(combined_data, aes(x = Inactivity,
                          y = Obesity,
                          color = Region)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Relationship Between Physical Inactivity and Adult Obesity Across U.S. Counties",
       x = "Physical Inactivity Prevalence (%)",
       y= "Adult Obesity Prevalence (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# 12. Create a plot on how the South affects trend
scatterplot_region <- ggplot(combined_data, aes(x = Inactivity,
                          y = Obesity,
                          color = Region)) +
  geom_point(alpha = 0.4) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "black") +
  labs(title = "Relationship Between Physical Inactivity and Adult Obesity Across U.S. Counties",
       x = "Physical Inactivity Prevalence (%)",
       y= "Adult Obesity Prevalence (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  annotate("text",
           x = 15,
           y = 45,
           label = paste0("r =", round(correlation, 3)))


# 13. Save plots using ggsave
ggsave("obesity_inactivity_relationship.png",
       plot = ob_vs_inac_scatterplot,
       width = 10,
       height = 6)

ggsave("scatterplot_lm.png",
       plot = scatterplot_lm,
       width = 10,
       height = 6)

ggsave("scatterplot_region.png",
       plot = scatterplot_region,
       width = 10,
       height = 6)
