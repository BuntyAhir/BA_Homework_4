library(tidyverse)
library(caret)
library(lubridate)

set.seed(77887)

read_tsv("/Users/vidit/Desktop/Sem_3/MSCS 6520/Homework4/hetrec2011-movielens-2k-v2/movies.dat")
movies <- read_tsv("/Users/vidit/Desktop/Sem_3/MSCS 6520/Homework4/hetrec2011-movielens-2k-v2/movies.dat")
head(movies)

read_tsv("/Users/vidit/Desktop/Sem_3/MSCS 6520/Homework4/hetrec2011-movielens-2k-v2/user_ratedmovies.dat")
rating <- read_tsv("/Users/vidit/Desktop/Sem_3/MSCS 6520/Homework4/hetrec2011-movielens-2k-v2/user_ratedmovies.dat")
head(rating)

movies = mutate(movies, movieID = id)

inner_join(rating, movies, key = "movieID")
movie_rating <- inner_join(rating, movies, key = "movieID")
head(movie_rating)

group_by(movie_rating, movieID, title, userID) %>% summarize(count = n(), avg_rating =mean(rating))
average_rating <- group_by(movie_rating, movieID, title, userID) %>% summarize(count = n(), avg_rating = mean(rating))
head(average_rating)

ggplot(data = average_rating, mapping = aes(avg_rating))+geom_histogram(binwidth = 0.5)
ggplot(data = average_rating, mapping = aes(log1p(count)))+geom_density()
ggplot(data = average_rating, mapping = aes(log1p(count), avg_rating))+geom_point()

ggplot(data = average_rating, mapping = aes(avg_rating)) + geom_histogram(binwidth = 0.5)
ggplot(data = average_rating, mapping = aes(count)) + geom_density()
ggplot(data = rating, mapping = aes(rating)) + geom_density()
ggplot(data = average_rating, mapping = aes(avg_rating)) + geom_density()
ggplot(data = average_rating, mapping = aes(movieID)) + geom_density()
ggplot(data = average_rating, mapping = aes(log1p(movieID))) + geom_density()

ggplot(data = average_rating, mapping = aes(log1p(avg_rating))) + geom_density()
ggplot(data = average_rating, mapping = aes(log1p(count))) + geom_density()
ggplot(data = average_rating, mapping = aes(x = log1p(count), y = avg_rating)) + geom_point()
ggplot(data = average_rating, mapping = aes(x = rating, y = avg_rating)) + geom_point()

trainSize = floor(0.8 * nrow(movie_rating))
trainIndex = sample(seq_len(nrow(movie_rating)), size = trainSize)
train <- movie_rating[trainIndex, ]
test <- movie_rating[-trainIndex, ]

#Baseline
overall_avg_rating = mean(train$rating)
mutate(test, overall_avg_rating = overall_avg_rating)
test_preditions <- mutate(test, overall_avg_rating = overall_avg_rating)
postResample(test_preditions$rating, test_preditions$overall_avg_rating)

#Model:- 1
predicted_rating <- group_by(train, movieID, title) %>% summarise(avg_rating = mean(rating))
test_preditions <- inner_join(test, predicted_rating, key = "movieID")
postResample(test_preditions$rating, test_preditions$avg_rating)

#Model:- 2
predicted_rating <- group_by(train, movieID, title) %>% summarise(avg_rating= mean(rating), count = n())
predicted_rating <- filter(predicted_rating, count >= 10)
test_preditions <- inner_join(test, predicted_rating, key = "movieID")
postResample(test_preditions$rating, test_preditions$avg_rating)

#Model:- 3
predicted_rating <- group_by(train, movieID, title) %>% summarise(avg_rating= mean(rating), count = n())
predicted_rating <- filter(predicted_rating, count >= 20)
test_preditions <- inner_join(test, predicted_rating, key = "movieID")
postResample(test_preditions$rating, test_preditions$avg_rating)

#Model :- 4
predicted_rating <- group_by(train, movieID, title) %>% summarise(avg_rating= mean(rating), count = n())
predicted_rating <- filter(predicted_rating, count >= 30)
test_preditions <- inner_join(test, predicted_rating, key = "movieID")
postResample(test_preditions$rating, test_preditions$avg_rating)






