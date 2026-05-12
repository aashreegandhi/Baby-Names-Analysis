# Baby-Names-Analysis  
Tidy Tuesday 2022-03-22 Baby Names Dataset Analysis**
 
This project investigates the evolution of naming conventions. Using over a century of data from the Social Security Administration, we test the theory that American society has transitioned from a "Collective Conformity" model (where most individuals shared a small pool of standard names) to a "Uniqueness" model characterized by phonetic diversity and social distinctiveness.  

Research Question:**   
To what extent has naming concentration declined since 1880, and is this trend driven by a genuine cultural shift toward individualism or simply a byproduct of population growth?  

Analysis Plan:**  
Conformity Indexing: Calculating the "market share" of the Top 10 names by year and sex.  
Phonetic Extraction: Isolating name-ending sounds (last letters) to track linguistic diversity.  
Distributional Analysis: Examining naming frequency to justify the use of log-transformations in statistical modeling.  
Simple Linear Regression: Quantifying the annual rate of naming diversification.  
Adjusted Multiple Regression: Controlling for biological sex and total birth volume to isolate the cultural "Year" effect.  
Entropy Analysis: Modeling the expansion of the American "Phonetic Palette" used in modern naming.  
Sensitivity Testing: Filtering for high-volume names to ensure trends are not driven by data "noise" or rare outliers.  

Key Findings:**  
In 1880, ~41% of males shared a "Top 10" name. By 2017, this concentration dropped below 10%, indicating a statistically significant rise in naming individualism. The adjusted regression model ($M_2$) yielded a significant negative coefficient for the year ($\beta = -0.002, p < .001$), confirming that the shift toward uniqueness persists even when controlling for population growth. There is a significant increase in the diversity of phonetic endings, with a modern preference for "soft" endings (vowels and 'n'). Modern names exhibit significantly shorter "peak popularity" lifespans compared to the "anchor" names of the early 20th century.  

Variable:**  
top10_share: The proportion of total births accounted for by the ten most popular names in a given year.  
total_n: The total number of births recorded for that year/sex (used as a control for population size).  
last_letter: A categorical variable representing the phonetic ending of a name.  
Log-transformation Frequency: Because naming data is highly skewed (long-tail distribution), counts are log-transformed for statistical normality in model diagnostics.  

Dependencies:**  
To run this code, you need R (version 4.0 or higher) and the following packages:
tidyverse   
tidytuesdayR  
broom  
modelr  
scales  

How to Run the Analysis:** 
Open the R script titled babynames_analysis.R.  
Execute Setup: The script uses pacman to handle dependencies and includes an automated GitHub fallback for data loading.  
Run Descriptive Analysis: Section 3 generates histograms to verify distributions and applies log transformations.  
Execute Regression Models: Sections 4 through 7 run the simple, multiple, and sensitivity models.  
View Diagnostics: The end of the script generates a Normal Q-Q Plot of residuals to verify the model’s statistical robustness.  

Results:**  
Descriptive Statistics: Analysis of the distribution confirmed that naming data is highly skewed. Log-transformation successfully normalized the frequency counts for OLS modeling.

Regressions and ANOVA:  
M1: Relationship between Time and Conformity  
A simple linear regression showed that Year significantly predicted the decline of naming concentration ($p < .001$).  

M2: Full Adjusted Model  
Neither birth volume ($p = 0.43$) nor sex alone fully explained the trend. In the adjusted model, Year remained the dominant significant predictor, suggesting that the rise of unique naming is a cultural phenomenon independent of population size.  

Diagnostics:  
Normal Q-Q plots confirmed that residuals were normally distributed. This validates that the "Individualism Hypothesis" is supported by robust, non-biased statistical evidence.
