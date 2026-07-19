# Load dataset
getwd()
setwd("C:\\Users\\Ishoda\\Desktop\\TPSM_DataSet")


library(dplyr)
library(ggplot2)

df <- read.csv("cleaned_movie_data.csv")

# Rating categories
df$RatingCategory <- cut(
  df$Rating,
  breaks=c(-Inf,5.9,7.4,Inf),
  labels=c("Low","Medium","High")
)

# Summary
rating_cat_summary <- df %>%
  group_by(RatingCategory) %>%
  summarise(
    avg_revenue=mean(X.Worldwide,na.rm=TRUE),
    median_revenue=median(X.Worldwide,na.rm=TRUE),
    count_movies=n()
  )

print(rating_cat_summary)

# Revenue boxplot
boxplot(
  X.Worldwide~RatingCategory,
  data=df,
  main="Revenue Distribution by Rating Category",
  xlab="Rating Category",
  ylab="Worldwide Revenue",
  col="lightblue"
)

# Average Revenue
ggplot(
  rating_cat_summary,
  aes(RatingCategory,
      avg_revenue,
      fill=RatingCategory)
)+
  geom_bar(stat="identity")+
  labs(
    title="Average Worldwide Revenue by Rating Category",
    x="Rating Category",
    y="Average Revenue"
  )

# Hit vs Flop
df$HitFlop <- ifelse(
  df$X.Worldwide>100000000,
  "Hit",
  "Flop"
)

ggplot(df,
       aes(RatingCategory,
           fill=HitFlop))+
  geom_bar(position="dodge")+
  labs(
    title="Hit vs Flop by Rating Category",
    x="Rating Category",
    y="Movie Count"
  )

# Pie Chart
rating_counts <- table(df$RatingCategory)

pie(
  rating_counts,
  labels=paste(
    names(rating_counts),
    "(",
    rating_counts,
    ")",
    sep=""
  ),
  main="Distribution of Movies by Rating Group",
  col=c("red","orange","green")
)

