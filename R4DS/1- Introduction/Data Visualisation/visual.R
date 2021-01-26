library(tidyverse)

ggplot(mpg)
str(mpg)

ggplot(data = mpg) +
  geom_point(mapping = aes(x=hwy, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x=class, y = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy, color = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy, size = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy, alpha = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy, shape = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy), color = "blue")


?geom_point
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy, color = cyl<7))


## FACETS ----

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) + 
  geom_smooth(mapping= aes(displ,hwy, color = drv),
              show.legend = FALSE)

ggplot(data= mpg)+
  geom_point(aes(displ,hwy, color = drv))+
  geom_smooth(aes(displ,hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

ggplot(data = diamonds, aes(x = cut))+
  geom_bar(aes(fill = clarity))

# identity:
ggplot(data = diamonds, aes(x = cut))+
  geom_bar(aes(fill = clarity), position = "identity")

#dodge
ggplot(data = diamonds, aes(x = cut))+
  geom_bar(aes(fill = clarity), position = "dodge")

#fill : 

ggplot(data = diamonds, aes(x = cut))+
  geom_bar(aes(fill = clarity), position = "fill")

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
