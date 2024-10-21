# main.R
library(tidyverse)
# library(tidyr)
library(showtext)

# 한글 폰트 추가 (예: Noto Sans KR)
font_add_google("Noto Sans KR", "notosanskr")
showtext_auto()


# 데이터 로드
source("scripts/data_loading.R")
# source("scripts/data_preprocessing.R")
# source("scripts/analysis.R")

st_info <- as_tibble(students_info(202402,'재학생'))

# 학과별, 국적별 학생 수 집계
st_foreigner <- st_info %>%
  group_by(학과, 국적) %>%
  summarise(학생수 = n(), .groups = "drop") %>% filter(학과 == '경영학부' & 국적 != '대한민국') %>% select(국적, 학생수)

st_foreigner_for_barplot <- st_info %>%
  group_by(학과, 국적) %>%
  summarise(학생수 = n(), .groups = "drop") %>% filter(학과 == '경영학부' & 국적 != '대한민국') %>% select(국적, 학생수)  %>%
  pivot_wider(names_from = 국적, values_from = 학생수, values_fill = 0)

# 결과 출력
print(st_foreigner)

# barplot 출력
barplot(as.matrix(st_foreigner_for_barplot),
        cex.axis = 0.9, cex.names=0.7,
        xlab='Nationality', ylab='Number of students')

library(ggplot2)

# Assuming 'st_foreigner' is a data frame with columns 'Nationality' and 'Number_of_students'
ggplot(st_foreigner, aes(x = 국적, y = 학생수)) +
  geom_bar(stat = "identity", fill = "skyblue") + 
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  labs(x = "Nationality", y = "Number of students") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
        axis.text = element_text(size = 9),
        axis.title = element_text(size = 11))



