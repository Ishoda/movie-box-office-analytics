# Load dataset
getwd()
setwd("C:\\Users\\Ishoda\\Desktop\\TPSM_DataSet")

df <- read.csv("box_office_data(2000-2024).csv", stringsAsFactors = FALSE)

# Inspect dataset
head(df)
str(df)

# Missing values
colSums(is.na(df))
df <- na.omit(df)

# Remove duplicates
df <- df[!duplicated(df), ]


# Function to clean numeric columns
clean_numeric <- function(x){
  as.numeric(gsub(",", "", x))
}

df$X.Worldwide <- clean_numeric(df$X.Worldwide)
df$X.Domestic  <- clean_numeric(df$X.Domestic)
df$Domestic..  <- clean_numeric(df$Domestic..)
df$X.Foreign   <- clean_numeric(df$X.Foreign)
df$Foreign..   <- clean_numeric(df$Foreign..)

# Convert categorical variables
df$Release.Group        <- as.factor(df$Release.Group)
df$Genres               <- as.factor(df$Genres)
df$Rating               <- as.factor(df$Rating)
df$Original_Language    <- as.factor(df$Original_Language)
df$Production_Countries <- as.factor(df$Production_Countries)

# Outlier inspection
boxplot(df$X.Worldwide)
summary(df$X.Worldwide)

Q1 <- quantile(df$X.Worldwide,0.25,na.rm=TRUE)
Q3 <- quantile(df$X.Worldwide,0.75,na.rm=TRUE)
IQR <- Q3-Q1

lower_bound <- Q1-1.5*IQR
upper_bound <- Q3+1.5*IQR

outliers <- df$X.Worldwide[
  df$X.Worldwide < lower_bound |
    df$X.Worldwide > upper_bound
]

length(outliers)

# Feature Engineering
df$Era <- ifelse(df$Year < 2010,"Pre-2010",
                 ifelse(df$Year <= 2015,"2010-2015","Post-2015"))

df$HitFlop <- ifelse(df$X.Worldwide > 100000000,"Hit","Flop")

# Save cleaned dataset
write.csv(df,"cleaned_box_office_data.csv",row.names=FALSE)

# Load cleaned dataset
df <- read.csv("cleaned_box_office_data.csv",
               stringsAsFactors=FALSE)

# Clean Rating
df$Rating <- gsub("/10","",df$Rating)
df$Rating <- as.numeric(df$Rating)

write.csv(df,"cleaned_movie_data.csv",row.names=FALSE)

