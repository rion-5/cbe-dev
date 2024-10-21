library(tidyverse)
library(showtext)

showtext.auto()

source('./scripts/data_loading.R')

students_info <- students_info(202402,'재학생')

students_foreigner <- students_info %>%
  group_by(학과, 국적) %>%
  summarise( 학생수 = n(), .groups = 'drop') %>%
  filter(국적 != '대한민국') %>%
  arrange(학과, desc(학생수)) 

ggplot(students_foreigner, aes(x=학과, y=학생수, fill=국적)) +
  geom_bar(stat = "identity")+
  labs(title = "학과별 국적 학생수", x = "학과", y = "학생수") +
  theme_minimal()

