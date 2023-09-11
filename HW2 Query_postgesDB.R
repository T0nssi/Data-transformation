#connect Github
library(usethis)
use_git()
use_github()
library(tidyverse)
library(RPostgreSQL)

#Connect DB
PostDB <- dbDriver("PostgreSQL")
Conn<-dbConnect(PostDB,
          user='iiywasxc',
          password='LlP6Ba3zUJRBSUD6g2rwhSccum4GvM0n',
          host='rain.db.elephantsql.com',
          port=,
          dbname='iiywasxc')
#Check Table in DB
dbListTables(Conn)

#Create DB
df_cars<-mtcars
dbWriteTable(Conn,"mtcars",df_cars)

#Check data
dbGetQuery(Conn,"SELECT * FROM mtcars")

#Query
#1. Top 5 hp of Auto car and Hp is higher 200hp : Duster 360/Cadillac Fleetwood/Lincoln Continental/Chrysler Imperial/Camaro Z28
dbGetQuery(Conn,"SELECT * FROM mtcars WHERE hp>=200 AND am = 'Auto' ORDER BY hp ")

#2. what car has minimum weight? : Lotus Europa
dbGetQuery(Conn,"SELECT model,wt FROM mtcars ORDER BY wt ")







