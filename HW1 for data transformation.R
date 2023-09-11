library(tidyverse)
library(nycflights13)

#screen data on dataset
glimpse(flights)
glimpse(airports)
glimpse(weather)
glimpse(airlines)
glimpse(planes)

#1 What tailnum are biggest and what is manufacturing brands
#        Manufacturer is BOEIG, Tailnum is N670US, Cap of seats are 450.
df_biggest<-planes%>%select(tailnum,manufacturer,seats)%>%arrange(desc(seats))
View(df_biggest)
df_biggest%>%head(5)

#2 how many planes of BOEIG are built after 2000
#        896 planes          
df_Boeig_2000<-planes%>%filter(year>=2000)%>%filter(manufacturer=='BOEING')%>%count('BOEING')
View(df_Boeig_2000)

#3 How longest of distance and what is flight
#        4983 form JFK to HNL by Hawaiian Airlines Inc.
#join table flights airlines
df_flight_airline<-flights%>%full_join(airlines,by='carrier')
#find info
df_flight_airline%>%select(distance,origin,dest,name)%>%arrange(desc(distance))

#4 Top 5 delay carrier
#     1 Envoy Air                   40.9 
#     2 Frontier Airlines Inc.      32   
#     3 Endeavor Air Inc.           11   
#     4 Southwest Airlines Co.      10.2 
#     5 AirTran Airways Corporation  9.25
df_delay<-df_flight_airline%>%head(327,346)%>%group_by(name)%>%summarise(n=mean(arr_delay))%>%arrange(desc(n))
df_delay%>%head(5)

#5 how many airport in tzone "America/New_York"
#     519 airports
airports%>%filter(tzone=="America/New_York")%>%nrow()


