setwd("C:\\Users\\254da\\Desktop\\İnR")
#fin <- read.csv("P3-Future-500-The-Dataset.csv")
## Import2
fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings = "")
head(fin2,24)
summary(fin)
str(fin)
### Format Düzenleme ------------------------

#--- Revenue ve Expenses sütunlarını character formatından numeric formata dönüştürmeliyiz.
#-- Bu sebeple öncelikle bu sütünlerin içerisinde bulunan "Dollars" "$" "," sembollerini kaldırmak gerek..

#---- Gsub çalışma mantığı  
# gsub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
#      fixed = FALSE, useBytes = FALSE)
# 
# • pattern: string to be matched, supports regular expression
# • replacement: string for replacement
# • x: string or string vector
# • perl: logical. Should perl-compatible regexps be used? Has priority over extended
# • fixed: logical. If TRUE, pattern is a string to be matched as is. Overrides all conflicting arguments
# • useBytes: logical. If TRUE the matching is done byte-by-byte rather than character-by-character

fin$Revenue <- gsub("\\$","", fin$Revenue)
#-- Revenue dan $ işaretini sildik. $ R içerisinde bir çok amaçla kullanıldığından kaçış karakteri olarak \\ kullanılmalı
#- Şimdi virgülleri kaldıralım.

fin$Revenue <- gsub(",","",fin$Revenue)

#-- Revenue sütununda karakterleri kaldırdık. Bunu numeric formata dönğştürebiliriz artık. 

fin$Revenue <- as.numeric(fin$Revenue)

#-- başarılı bir şekilde farklı karakter barındıran bir sütünu temizleyerek numeric formata dönüştürdük
#- Aynı işlemi Growth ve Expenses için de yapmak gerekir.

fin$Growth <- gsub("%","",fin$Growth)
fin$Growth <- as.numeric(fin$Growth)
fin$Expenses <- gsub(" Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",","",fin$Expenses)
fin$Expenses <- as.numeric(fin$Expenses)

#-- Şimdi sütunlarımızın yapısını incelersek öncesinde karakter olan sütünlarımızın numeric olduğunu görürüz.
str(fin)
summary(fin)

### Kayıp veri düzenleme  ------------------------------------------------

# R ile hesaplama yaparken NA ve NAN verileri olduğu durumda bir sonuç döndürmemektedir. Bu sebeple 
# NA ve NAN verileri düzenlemek bir analizin ilk basamaklarından biridir. 
# complate.cases() fonksiyonu, Mantıksal vektör döndürür ve bir durumun tamamlanmış veya tamamlanmamış olduğunu
# basitçe NA verileri oluş olmadığını döndürür. başına ! gelince ise boş durumlar false yerine true döndürür
# bu sayede fin[] içerisine girerek boş değerlerin olduğu verileri elde etmek mümkün olacaktır.

fin[!complete.cases(fin),]

#Ancak burada dikkati çeken, veriyi incelediğimizde karşımıza çıkan boş değerleri bu yöntemle elde edememiş olmamız.
#Bunun sebebi ise her kayıp değerin (Missing Value) NA olarak tanımlanmamış olmasıdır. Bir çok NA olmayıp boş 
# olan dedğer verimizin içerisinde bulunmaktadır ve bu verileri NA olarak göstermek için veriyi import ederken dikkat
#edilmesi gereken bir husus vardır. (import 2. inceleyiniz.)
# İmport işlemini düzenleyerek aynı süreci tekrarladığımızda, NA verilerini düzgün olarak elde edebildik.

### Veride sorgulama yapma ve which() fonksiyonu -------
# verimiz içerisinde bir sorgunun sağlandığı durumları döndürmek oldukça basit şekilde verinin içerisinde sorguyu
#sormak ile sağlanabilir. örneğin çalışan sayısı 45 olan firmaları döndürmek için

fin[fin$Employees==45,]

# ancak bu verinin döndürdüğü sonuçlar içerisinde görülmektedir ki NA verileri barındıran satırlar da gelmektedir. Bunun
#sebebi sorgulamanın her satıra giderek True veya False değeri alması ve False olmayan durumlar döndürmesidir.
#Ancak bir NA değeri ne doğrdu ne de yanlış kabul edilebileceğinden bu veriler de sorgunun sonucunda dönecektir. 
# Bu durumu aşmak için which() fonksiyonu kullanılabilir. which() fonksiyonu içerisine aldığı sorgudan True olan değerleri
# bir vektör olarak döndürür bu sayede veriye bu vektörü sağladığımız durumda sadece TRUE olan değerler yani sorgunun
# Sağlandığı değerleri elde etmek mümkün olacaktır.

fin[which(fin$Employees==45),]

# aynı şekilde NA olan değerleri sorgulamak da mümkün olmayacaktır. Bu bize NA lerden oluşturan bir dataframe döndürecektir.

### is.na() ----

#is.na() fonksiyonu, bir aralıkta verilerin NA olup olmadığını sorgular. Örneğin:
a <- c(1,3,5,NA,2,NA)
is.na(a) # FALSE FALSE FALSE  TRUE FALSE  TRUE olarak döndürür. Buradan anlaşılır ki NA lerin yerini sorgulamak için is.na() kullanıllmalıdır.

fin[is.na(fin$Expenses),] # Expenses sütununda NA değerlerinin olduğu sütunları döndürür.

### Kayıp verilerin silinmesi ----
#önce verimizden back-up alalım
fin_backup <- fin
fin[!is.na(fin$Expenses),] # fin$expenses in NA olmadığı durumları getirir.
fin <- fin[!is.na(fin$Expenses),] # artık verimizde expenses'in NA olduğu değerler yok. 
fin[!complete.cases(fin),]


### Reset index ----
#aradan veriler eksildikçe R dilinde indexleme değişmemekte, sadece eksilenler aradan çıkmaktadır.
#böyle bir durumda ihtiyaç halinde rownames() fonksiyonu ile satır isimleri veri uzunluğu ile değiştirilebilir.
rownames(fin) <- 1:nrow(fin)
fin

### Eksik verileri değiştirmek ----
# eksik verileri belirli bir koşula göre yeni bir değer ile doldurmak mümkün. Bunun için öncelikle NA değerine ulaşmalı
# ve yeni değeri vermeliyiz. BUnun için Eyalet kısaltmalarını dolduralım. Örneğin city adı New york ise Eyalet kısaltması NY olmalı.

fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"
fin[c(10,376),] # koşulu saplayan satırlarda State sütununun NY ile değiştiğini görürüz.

# Benzer bir işlemi San Francisco için de yapalım.

fin[is.na(fin$State)& fin$City == "San Francisco", "State"] <- "CA"
fin[c(81,264),]

# geri kalan eksik verilerimize bakalım
fin[!complete.cases(fin),]

### NA değerlerini Medyan değer ile doldurma ----
# verisetimizde NA verileri tekrar kontrol edelelim.

fin[!complete.cases(fin),]

# Burada Employees sütununu doldurmaya çalışalım. Bunun için medyan değeri kullanacağız. Ayrıca medyan değeri aynı endustri
# üzerinden alarak doğruluk payını arttıracağız. 

# RETAİL endüstrisinin çalışan sayısının medyanını alalım.

median(fin[fin$Industry == "Retail","Employees"]) # NA dödürecektir çünkü R dilinde bir NA tüm sonucu NA döndürür.
#NA değerlerini çıkararak hesaplama yapalım

median(fin[fin$Industry == "Retail","Employees"], na.rm = TRUE) # 28 döndürecektir. Boş olmayan Retail endüstrisinde çalışan medyanı

# bu değeri bir değişkene atayarak boş olan çalışan sayısına uygulayalım.

med_rtl_emp <- median(fin[fin$Industry == "Retail","Employees"], na.rm = TRUE)

fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_rtl_emp

# kontrol edelim:
fin[c(3),] # öncesinde boş olan 3 indeksli satırda artık çalışan sayısı 28.

# bir diğer boş olan Financial Services için medyan değeri girelim.

med_fin_emp <- median(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE) # medyan = 80
fin[is.na(fin$Employees)&fin$Industry=="Financial Services", "Employees"] <- med_fin_emp

#kontrol
fin[c(329),] # öncesinde boş olan 329 indeksli satırda artık çalışan sayısı 80.

fin[!complete.cases(fin),]

# Endustri ismi girilmemiş satırları da sileceğim. İsimden yola çıkılarak doldurulması da mümkün.
fin_backup2 <- fin
fin <- fin[!is.na(fin$Industry),]
# 495 adet satır kaldı elimizde. Kalan boş satırlar ise: 
fin[!complete.cases(fin),] # yılı belli olmayan bir satır. Bunu da doldurmak diğer verilerden yola çıkarak mümkün olmayacaktır

### Görselleştirme ----
library(ggplot2)

p <- ggplot(data = fin, aes(x = Revenue, y = Expenses, color = Industry, size = Growth))+
  geom_point()
p
p + geom_smooth(fill = NA, size = 1.2)

d <- ggplot(data = fin, aes(x = Industry, y=Growth, color = Industry))+
  geom_boxplot(size = 1)
d

d + geom_jitter(alpha = 0.3) + geom_boxplot(size = 1, outlier.colour = NA, alpha = 0.5)
