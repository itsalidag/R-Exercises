data(Oxboys, package = "nlme")
head(Oxboys)

library(ggplot2)
ggplot(Oxboys, aes(age,height, color= Occasion)) + geom_line()+
  geom_point()

ggplot(Oxboys, aes(age,height, group = Subject)) + geom_line()+
  geom_point() # oxboys1
    
ggplot(Oxboys, aes(Occasion, height))+
  geom_boxplot()+
  geom_point(alpha = 0.3, color = Oxboys$Subject) #2

ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot()+
  geom_line(aes(group = Subject), alpha = 0.3, color = "green") #3
