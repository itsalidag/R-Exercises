## Meydan okuma ----
# Character: Machine name
# Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
# Logical: Has utilisation ever fallen below 90%? TRUE / FALSE
# Vector: All hours where utilisation is unknown (NA’s)
# Dataframe: For this machine
# Plot: For all machines

# çalışma dizinimi belirliyorum
setwd("D:\\İnR\\R-Exercises\\2-Lists in R")

# Verisetini import etmek ----

util <- read.csv("P3-Machine-Utilization.csv")
head(util,20) # veri ön inceleme
str(util) # yapı
summary(util) # veriseti özeti

# veride idle sütunu makinenin çalışmadığı zamanın oranını verir, bunu çalıştığı zamana
# çevirmek için 1 den çıkaralım

util$Utilisation <- 1- util$Percent.Idle
head(util,20)

## Tarih verileri kullanmak ----
# verimiz içerisinde bir tarih sütunu yer aldığından, bu kolona tarih şeklinde
# davranmak en başarılı sonucu verecektir. Bunun için Universersal bir takvim zamanı
# vardır ve buna R dili içerisinde POSIXct ile ulaşılabilir.

?POSIXct

# verimizde zaman sütununu POSIX time formatına dönüştürelim. Bu işlem yapmamıza olanak sağlar.

util$POSIXtime <- as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")
head(util,20)

# şimdi eski kullanılmayacak timestamp sütununu silelim.
util$Timestamp <- NULL

# Yeni zaman sütununu başa almak için:

util <- util[c(4,1,2,3)]
head(util,20)

## Meydan okuma birinci kısım ----
# Character: Machine name
# Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
# Logical: Has utilisation ever fallen below 90%? TRUE / FALSE
# istenen girdilerin bulunduğu bir liste hazırlayalım.

#RL1 makinesi için
mac_name <- "RL1"
util_rl1 <- util[util$Machine == "RL1",]
nrow(util_rl1) # RL1 için 720 kaydımız var bunlardan min max ve mean değerlerini bulalım

rl1_util_stats <- c(min(util_rl1$Utilisation, na.rm = T),
                    mean(util_rl1$Utilisation, na.rm = T),
                    max(util_rl1$Utilisation, na.rm = T))

# yüzde doksanın altında kapasite ile çalışıp çalışmadığını mantıksal olarak elde etmemiz gerekiyor.

util_rl1$Utilisation < 0.90 # yüzde doksanın altında olanları true döndürür. veya ; 

which(util_rl1$Utilisation < .90) # utilisationun yüzde doksanın altında olduğu indexleri döndürür. 

# sorgumuz herhangi bir değerde yüzde doksanın altına düşüp düşmediği olduğundan which fonksiyonunun sonucunun
# 0 dan büyük olması True döndürmelidir. 

length(which(util_rl1$Utilisation < .90)) # 27 döndürür
length(which(util_rl1$Utilisation < .90)) > 0 # True döndürür.

rl1_logic <- length(which(util_rl1$Utilisation < .90)) > 0

rl1_list <- list(mac_name, rl1_util_stats, rl1_logic)
rl1_list # istenilen değerleri listemizde döndürdük. 

# Liste elemanlarını isimlendirmek ----
# iki farklı yol ile listelerin elemanlarına isim vermek mümkün. Bunun için verimi yedekliyorum

rl1_list2 <- rl1_list
# birinci yol: 

names(rl1_list) # NULL döndürür çünkü isim yok. aynı şekilde fonksiyona indexlere göre isim atayabiliriz.
names(rl1_list) <- c("Machine", "Stats", "LowTreshold")
rl1_list # isimlerin listeye işlendiğini görürüz.

# ikinci yol: bir sözlük yazarcasına isimleri key değerleri value şeklinde atayabiliriz.

rl1_list2 <- list(Machine = mac_name, Stats=rl1_util_stats, LowTreshold=rl1_logic) 
rl1_list2 # isimlerin listeye işlendiğini görürürz.


# Eksik verilerin saatlarini girmek ---- 
# verimizde makinaya ait verinin işlenmediği NA verilerinden bir listeyi makine verimize ekleyelim.

nas <- util_rl1[is.na(util_rl1$Utilisation),]
POSIXna <- nas$POSIXtime  
POSIXna # makinanın çalışmadığı saat ve tarih. verimizde ekleyelim.

rl1_list$Lockdown <- POSIXna
rl1_list

# ham veriyi ekleme ---- 
# meydan okumanın sondan önceki basamağı elde ettiğimiz verilerin kaynağı olan dataframe i veriye eklemektir. 
# eklemek için:

rl1_list$data <- util_rl1
summary(rl1_list)

# veriden spesifik noktaya erişmek ----
rl1_list$Stats[1]
rl1_list[[2]][1]

# Listeden altliste oluşturmak. ----
# listeden belirli indexleri seçerek bunu yeni bir değişkene atamak mümkün. 

mch_stats <- rl1_list[c("Machine", "Stats")]
mch_stats # Makine adı ve stats ı döndüren yeni bir listemiz oldu.

# Zaman Serisi Grafiği ----
# zamana göre makinenin kullanım kapasitesini gösteren bir grafik hazırlayacağız. 
# ggplot2 kütüphanesi kullanarak. 

library(ggplot2)

p <- ggplot(data = util, aes(x = POSIXtime, y = Utilisation))+
  geom_line(aes(color = Machine),size = 1)+
  facet_grid(Machine~.)+
  geom_hline(yintercept = 0.90, size = 1, color = "gray", linetype = 3)
p

# her makineyi farklı renkle gösterdik fakat yine de anlaşılabilir değil.
# faced grid kullanalım 

p

# 