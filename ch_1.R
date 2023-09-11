library(tidyverse)
library(glue)
library(RSQLite)

#string template
my_name<-'Toy'
age<-34
city<-'BKK'

'Hello,i am toy, i am 34 years, i live in BKK'

glue('Hello,i am {my_name}, i am {age} years, i live in {city}')


d<-'2023-06-17'
class(d)
ymd(d)
myd('07-2023-17')
dmy('1-10-2023')
dmy('1/10\\2023')
dmy('1]10]2023')
dmy('1>10]2023')
dmy('1>Jan]2023')
class(d)

#exact data from date form
year(d)
week(d)
wday(d,label=T)
wday(d,label=T,abbr = F) #add abb to show full name 
month(d,label=T,abbr = F)

#can we +/- date like numerical data
c<-dmy('1>Jan]2023')
c-1

#tidyverse-dplyr
#1 Select 2 filter 3 Arrange 4 Mutate (create naw column) 5 Summerise+group by(Agg in sql)
View(mtcars)#buit-in data frame

select(mtcars,mpg,cyl,disp,hp,am)#1st paameter = data set name after = column name

select(mtcars,mile_per_gallon=mpg)#change column name during create data

#select column by key word 
select(mtcars,starts_with("a"))
select(mtcars,ends_with("p"))
select(mtcars,contains("m"))

#check row name
row.names(mtcars)#traditional function
rownames_to_column(mtcars)#new
rownames_to_column(mtcars,var = "model")#add row name

#create data frame
mtcars_new<-rownames_to_column(mtcars,var = "model")

#filter
filter(mtcars_new,hp>100)
filter(mtcars_new,hp>100,disp>300) #add more conditions 
filter(mtcars_new,hp>100,disp>300&mpg>15) #add more conditions
filter(mtcars_new,hp>100|disp>300)# or operator (Pipe ; |)
#or operator have return data more than and operator
filter(mtcars_new,model=='Mazda RX4')

#regular expression grep grepl
state.name
grep("^A",state.name)
grep("^M",state.name)
grepl("^M",state.name)
filter(mtcars_new,grepl("^M",model))
filter(mtcars_new,grepl("C$",model))#end of word at C

#dplyr use pipe (%>%) simple pipeline in r
mtcars_new %>%
  filter(grepl("C$",model)) %>%
  select(mpg,hp)

#sort data
arrange(mtcars_new,mpg)
arrange(mtcars_new,-mpg)#DESC
arrange(mtcars_new,desc(mpg))#DESC
arrange(mtcars_new,desc(mpg),desc(hp))#sore more one variable

#mutate -> create new column
new_mpg<-mtcars%>%
  select(mpg)%>%
  filter(mpg>20)%>%
  mutate(mpg_2=mpg*2)

#pipline
data%>%
  pipeline1()%>%
  pipeline2()%>%
  pipeline3()

#summarise 
summarise(mtcars,mean(mpg))
summarise(mtcars,avg_mpg=mean(mpg))
mtcars%>%summarise(min(mpg),
                   max(mpg),
                   mean(mpg),
                   sd(mpg),
                   var(mpg))
#group by
mtcars<-mtcars_new
mtcars<-mtcars%>%mutate(am=ifelse(am==0,"Auto","Manual")) #change value
mtcars%>%select(am)
mtcars%>%
  group_by(am)%>%
  summarise(min(mpg),
            max(mpg),
            mean(mpg),
            sd(mpg),
            var(mpg))

#load csv form web or com
link_mtcars='https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv'
df<-read_csv('https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv')
View(df)
df%>%select(model,milePerGallon=mpg)%>%arrange(milePerGallon)
#tibble is enhance Dataframe show type, print only 10 rows, size, print fit screen
#tibble have no row name

#set seed for lock random

df%>%select(model)%>%sample_n(4)#n
set.seed(42)

df%>%select(model)%>%sample_frac(0.4)#%
set.seed(42)

#Count frequency table
df%>%mutate(am=ifelse(am==0,"Auto","Manual"))%>%count(am)%>%mutate(pct=n/sum(n))
df%>%count(am,vs)

#bind_row>stack df
df1<-mtcars%>%filter(hp<300)
df2<-mtcars%>%filter(hp>=80)
df3<-mtcars%>%filter(am=="Auto")
df2<-mtcars%>%filter(mpg>=20)
df1
df2
bind_rows(df1,df2)
df2%>%bind_rows(df3)

library(googlesheets4)
#read form gg sheet
#read_sheet(url,sheet=1)


#bind_column vs join

left_join()#have key to joining
right_join()
inner_join()
full_join()

#join not same id
#df1%>%innebyr join(df2,by=c('id'='std_id))

drop_na()


#_________________________________________________________________________
#2.14hrs 7-Sep-23

#1 Clean missing value
df4<-data.frame(id=1:5,
                classes=c('Data',NA,'UX','Business',NA),
                score=c(2.4,2.5,2.6,3,NA))
df4%>%mutate(classes=replace_na(classes,"wooo!!!"),
             score=replace_na(score,mean(score,na.rm = T)))

library(nycflights13)
View(flights)
glimpse(flights)#preview data frame structure easy to see
flights%>%group_by(month)%>%summarise(n=n())
flights%>%count(month)

#change question form user to scrip
flights%>%filter(year==2013,month==2)%>%group_by(carrier)%>%summarise(n=n())%>%arrange(desc(n))
flights%>%filter(year==2013,month==2)%>%group_by(carrier)%>%summarise(n=n())%>%arrange(desc(n))%>%left_join(airlines,by="carrier")

library(RSQLite)
connection<-dbConnect(SQLite(),"chinook.db")
dbListTables(connection)
dbListFields(connection,"customers")
custo<-dbGetQuery(connection,"select*from customers")

shipping<-data.frame(id=1:3,city=c('NY,BKK,LA'))
dbWriteTable(connection,'shipping',shipping)
dbGetQuery(connection,"select* from shipping")

dbDisconnect(connection)

library(RPostgreSQL)
library(tidyverse)
con<-dbConnect(PostgreSQL(),
               host="rain.db.elephantsql.com",
               port=5432,
               user="iiywasxc",
               password="LlP6Ba3zUJRBSUD6g2rwhSccum4GvM0n",
               dbname="iiywasxc")
dbListConnections(con)
shipping<-data.frame(id=1:3,city=c('NY','BKK','LA'))
dbWriteTable(con,"shipping",shipping)
dbListTables(con)

#HW01 5 questions ask about flights data set
#HW02 create new table and create query 


