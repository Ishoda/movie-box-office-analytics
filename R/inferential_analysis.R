# Load dataset
getwd()
setwd("C:\\Users\\Ishoda\\Desktop\\TPSM_DataSet")


# 03_inferential_analysis.R
df <- read.csv("cleaned_movie_data.csv", stringsAsFactors = FALSE)

library(dplyr)

# Rating categories
df$RatingCategory <- cut(df$Rating, 
                         breaks = c(-Inf, 5.9, 7.4, Inf),
                         labels = c("Low", "Medium", "High"))
df$RatingCategory <- as.factor(df$RatingCategory)

# Log transform revenue (recommended for skewed data)
df$LogRevenue <- log(df$X.Worldwide + 1)

# Normality check
hist(df$X.Worldwide, main="Histogram of Raw Revenue", xlab="Revenue", col="lightblue")
qqnorm(df$X.Worldwide); qqline(df$X.Worldwide, col="red")
shapiro.test(df$X.Worldwide)   # Likely non-normal

# Kruskal-Wallis Test
kruskal.test(LogRevenue ~ RatingCategory, data = df)

# Dunn's Post-hoc Test
# 1. Install the package (run this once)
install.packages("dunn.test")
library(dunn.test)
dunn.test(df$LogRevenue, df$RatingCategory, method = "bonferroni")

# Spearman Correlation
df$RatingNumeric <- as.numeric(df$RatingCategory)
cor.test(df$RatingNumeric, df$LogRevenue, method = "spearman")

# Visualizations
boxplot(LogRevenue ~ RatingCategory, data = df,
        main = "Log Revenue by Rating Category",
        xlab = "Rating Category", ylab = "Log Revenue",
        col = c("lightblue", "lightgreen", "lightpink"))

plot(df$RatingNumeric, df$LogRevenue,
     xlab = "Rating Category (Numeric)",
     ylab = "Log Revenue",
     main = "Spearman Correlation: Rating vs LogRevenue",
     col = "blue", pch = 19)
abline(lm(LogRevenue ~ RatingNumeric, data = df), col = "red")

print("✅ Inferential analysis completed!")

