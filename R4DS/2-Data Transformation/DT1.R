library(nycflights13)
library(tidyverse)

## FILTER() ----
# filter ile verilerimizi belirli bir koşula göre filtrelememizi ve bu veriyi kaydetmemizi sağlar. örneğin ilk ayın ilk günü yapılan uçuşları bulmak için : 

jan1 <- filter(flights, month == 1, day == 1)
jan1 # month değeri 1 e ve gün değeri 1 e eşit olan bir alt veriseti oluşturup jan1 e kaydettik.

# filter kullanırken karşılaştırma operatörleri kullanılmalıdır. = ile eşit olan değerleri bulmak mümkün değildir.
# == (eşittir) != (eşit değildir) <,> (küçüktür, büyüktür) <=,>= (küçük eşit, büyük eşit)

# mantıksal operatör ile bir çok farklı durumu veya bir durumu en azından karşılayan değerleri elde etmek mümkün
# & (and-ve) | (or, veya) !(not-değil) kullanarak filtremizin eşleşme aralığını arttırabilir & azaltabiliriz.

filter(flights, month == 11 | month == 12)  # month 11 olanları veya month 12 olanları filtrele

# bu işlemi month == (11|12) şeklinde de yapabilirdik. sonuç aynı olacaktır.
# benzer bir işlemi yapmanın en alışılagelmiş yolu ise %in% kulllanmaktır. x %in% y ifadesi x in y deki değerleri true yaptığı durumları döndürecektir. 

filter(flights, month %in% c(11,12) & carrier %in% c("B6","AA","DL"))

# Find all flights that
# Had an arrival delay of two or more hours
# Flew to Houston (IAH or HOU)
# Were operated by United, American, or Delta
# Departed in summer (July, August, and September)
# Arrived more than two hours late, but didn’t leave late
# Were delayed by at least an hour, but made up over 30 minutes in flight
# Departed between midnight and 6am (inclusive)  

exercise <- filter(flights, arr_delay>=2 & dest %in% c("IAH", "HOU"))
ex2<- exercise %>%
  filter(month %in% c(7,8,9))%>%
  filter(arr_delay>2 & dep_delay <=0)
    
ex2
?between()


# Select ----

select(flights, year,month,day)

select(flights,)

select(flights, contains("TIME"))

subset <- select(flights,
                 year:day,
                 ends_with("delay"),
                 distance,
                 air_time)

# Mutate ----
                 
  
mutate(subset,
       gain = arr_delay - dep_delay,
       speed = distance/air_time*60)


# group_By -----

by_day <- group_by(flights, year,month,day)
by_day
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)
by_dest

add_two <- function(x){
  print(x+2)
}
add_two(188)


if (10>12){
  print("okey")
  
}else{
  print("none")
}



alan <- function(x,y){
  a <- "alan = "
  print(paste(a,x*y))
}
alan(4,4)
