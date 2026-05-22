# Obesity vs Inactivity Analysis
Analysis of U.S. obesity prevalence vs inactivity prevalence using CDC county-level data (R, ggplot2)

## Objective

The goal of this project was to analyze how adult obesity prevalence varies with inactivity level across U.S. counties and states, and to explore regional differences in the relationship between inactivity and obesity prevalence.

## Tools Used

- R
- dplyr
- ggplot2

## Data

This project uses the CDC PLACES county-level dataset. The analysis focuses on age-adjusted adult obesity prevalence and age-adjusted physical inactivity prevalence for the year 2023.

## Methods

The CDC PLACES county-level dataset was filtered to include only age-adjusted adult obesity prevalence and age-adjusted physical inactivity prevalence for the year 2023.

Duplicate county observations were cleaned using weighted averages based on adult population estimates. The obesity and inactivity datasets were then joined by county and state identifiers using `left_join()` in R.

Scatterplots and linear regression trend lines were created using ggplot2 to visualize the relationship between inactivity and obesity prevalence across U.S. counties. Correlation analysis was also performed to quantify the strength of the relationship.

## Key Findings

- Physical inactivity and obesity prevalence demonstrated a strong positive relationship across U.S. counties (r ≈ 0.745).

- Counties in Southern states tended to cluster at higher inactivity and obesity prevalence levels compared to other regions.

- The regression trend for Southern counties appeared steeper than that of non-Southern counties, suggesting that increases in inactivity may be associated with larger increases in obesity prevalence in Southern counties.

## Visualizations

### Overall Relationship

<p align="center">
  <img alt="obesity_inactivity_relationship" src="https://github.com/user-attachments/assets/bf3ffab0-efe2-43e0-9495-08967d98fb22" width="800" />
</p>

This scatterplot suggests a strong positive relationship between physical inactivity and adult obesity prevalence across U.S. counties.

### Regional Trend Lines

<p align="center">
  <img alt="scatterplot_lm" src="https://github.com/user-attachments/assets/41c04000-80b1-4867-98cf-9cb04da3247a" width="800" />
</p>

This scatterplot suggests that Southern counties tend to demonstrate a steeper positive relationship between physical inactivity and obesity prevalence.

### Regional Distribution

<p align="center">
  <img alt="scatterplot_region" src="https://github.com/user-attachments/assets/c300c45f-bb49-4259-95f4-a9851a6aea90" width="800" />
</p>

This scatterplot shows the distribution of Southern counties within the overall relationship between physical inactivity and adult obesity prevalence across U.S. counties.

## Skills Demonstrated

- Data cleaning and transformation
- Data joining using `left_join()`
- Missing value handling
- Correlation analysis
- Data visualization with ggplot2
- Regression trend analysis

## Limitations

This analysis used observational county-level data and therefore cannot establish causation between physical inactivity and obesity prevalence. Other factors such as diet, socioeconomic status, healthcare access, and environmental conditions may also contribute to obesity prevalence across counties.

Additionally, the analysis focused only on age-adjusted prevalence estimates from 2023 and may not fully capture changes over time or all regional differences.

## Conclusion

This project demonstrated a strong positive relationship between physical inactivity and adult obesity prevalence across U.S. counties. Southern counties generally appeared to cluster at higher inactivity and obesity prevalence levels, and regional trend lines suggested potential differences in the relationship between inactivity and obesity across regions.

Overall, the project demonstrated how R can be used to clean, combine, visualize, and analyze real-world public health data using reproducible analytical workflows.

