library(tidyverse)

ggplot(data = diamonds, aes(x= cut))+
  geom_bar()

diamonds %>%
  count(cut)

ggplot(diamonds, mapping = aes(x= carat))+
  geom_histogram(binwidth = 0.5)


diamonds %>%
  count(cut_width(carat, 0.5))

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(smaller)+
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)


ggplot(smaller, aes(x = price))+
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(mpg, aes(x = reorder(class, hwy, FUN = median), y = hwy))+
  geom_boxplot()

ggplot(data = mpg)+
  geom_boxplot(mapping = aes(x = reorder(class,hwy, FUN = median),
                             y = hwy))+
  coord_flip()

ggplot(diamonds, aes(x = cut, y = color))+
  geom_count()


diamonds %>%
  count(color, cut) %>%
  ggplot(aes(x = cut, y=color))+
    geom_tile(aes(fill = n))+
    coord_flip()


# bin2d vs hexbin ----

ggplot(diamonds)+
  geom_bin2d(aes(x =carat, y = price))

ggplot(diamonds)+
  geom_hex(aes(x = carat, y = price))
