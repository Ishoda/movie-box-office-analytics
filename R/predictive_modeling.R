# 04_predictive_modeling.R
# Load dataset
getwd()
setwd("C:\\Users\\Ishoda\\Desktop\\TPSM_DataSet")

df <- read.csv("cleaned_movie_data.csv", stringsAsFactors = FALSE)

# Prepare data
df$RatingCategory <- cut(df$Rating, breaks = c(-Inf, 5.9, 7.4, Inf),
                         labels = c("Low", "Medium", "High"))
df$LogRevenue <- log(df$X.Worldwide + 1)

# Simple Linear Regression (expand with more predictors)
model <- lm(LogRevenue ~ Rating, data = df)
summary(model)

# Train-test split example
set.seed(42)
train_index <- sample(1:nrow(df), 0.7 * nrow(df))
train <- df[train_index, ]
test  <- df[-train_index, ]

# Predict and evaluate
predictions <- predict(model, newdata = test)
actual <- test$LogRevenue

# Metrics
r_squared <- summary(model)$r.squared
rmse <- sqrt(mean((predictions - actual)^2, na.rm = TRUE))

cat("R²:", r_squared, "\n")
cat("RMSE:", rmse, "\n")

# Predicted vs Actual Plot
plot(actual, predictions, 
     main = "Predicted vs Actual Log Revenue",
     xlab = "Actual Log Revenue", 
     ylab = "Predicted Log Revenue",
     col = "steelblue", pch = 19)
abline(0, 1, col = "red", lty = 2)   # Perfect prediction line

print("✅ Predictive modeling completed!")

