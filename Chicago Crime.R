library(dplyr)
library(DBI)  
library(dbplyr) 
library(odbc) 
library(ggplot2)

odbcListDrivers()

con <- DBI::dbConnect(odbc(), 
                      Driver = "ODBC Driver 17 for SQL Server",
                      Server = "mcobsql.business.nd.edu",
                      UID = "MSBAstudent",
                      PWD = "SQL%database!Mendoza",
                      Port = 3306, 
                      Database = "ChicagoCrime")

# test_date <- "2018-07-31 17:35:00.000"
# stringr::str_extract(test_date, ".*(?=\\s)")
# stringr::str_extract(test_date, "(?<=\\s).*")
# stringr::str_extract(test_date, "(?<=\\s)[0-9]{2}")


# Find peak of crimes in date
date <- "
SELECT CONVERT(date, date) AS Date,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY CONVERT(date, date)
ORDER BY CrimeFreq DESC
"

date_clear <- gsub("\\n|\\s+", " ", date) 

date_q <- dbSendQuery(conn = con, 
                      statement = date_clear)

date_res <- dbFetch(date_q)

date_present <- date_res %>% 
  slice(1:10) #%>% 
  # ggplot(., mapping = aes(Date, CrimeFreq)) +
  # geom_point()


# Find peak of crimes in month
month <- "
SELECT DATEPART(mm, date) AS Month,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(mm, date)
ORDER BY Month 
"

month_clear <- gsub("\\n|\\s+", " ", month)

month_q <- dbSendQuery(conn = con, 
                       statement = month_clear)

month_res <- dbFetch(month_q)

month_res$Month <- month.abb[month_res$Month]

summary(month_res)

ggplot(month_res, 
       mapping = aes(x = factor(Month, levels=unique(Month)), y = CrimeFreq)) +
  geom_point() + 
  geom_hline(yintercept = mean(month_res$CrimeFreq), linetype='dotted', col = 'red')+
  theme_minimal() +
  xlab("Month") +
  ylab("Number of Crimes") +
  theme(axis.title.x = element_text(size = 14), 
        axis.title.y = element_text(size = 14),   
        panel.grid.major.y = element_line(color = "whitesmoke"),
        panel.grid.minor.y = element_line(color = "whitesmoke"),
        panel.grid.major.x = element_line(color = "whitesmoke"),
        panel.grid.minor.x = element_line(color = "whitesmoke"))

# Find peak of crimes in day
day <- "
SELECT DATEPART(dd, date) AS Day,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(dd, date)
ORDER BY CrimeFreq DESC
"

day_clear <- gsub("\\n|\\s+", " ", day)

day_q <- dbSendQuery(conn = con, 
                       statement = day_clear)

day_res <- dbFetch(day_q)


# in Year
year <- "
SELECT DATEPART(yy, date) AS Year,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(yy, date)
ORDER BY CrimeFreq DESC
"
year_clear <- gsub("\\n|\\s+", " ", year)

year_q <- dbSendQuery(conn = con, 
                     statement = year_clear)

year_res <- dbFetch(year_q)

ggplot(year_res, mapping = aes(Year, CrimeFreq)) +
  geom_line()+ geom_point() +
  theme_minimal() +
  xlab("Year") +
  ylab("Number of Crimes") +
  theme(axis.title.x = element_text(size = 14), 
        axis.title.y = element_text(size = 14),   
        panel.grid.major.y = element_line(color = "whitesmoke"),
        panel.grid.minor.y = element_line(color = "whitesmoke"),
        panel.grid.major.x = element_line(color = "whitesmoke"),
        panel.grid.minor.x = element_line(color = "whitesmoke"))


