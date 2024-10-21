# main.R
library(tidyverse)
# library(tidyr)
library(showtext)

# 한글 폰트 추가 (예: Noto Sans KR)
# 아래는 한 번만 실행(font_add_google)
# font_add_google("Noto Sans KR", "notosanskr")
showtext_auto()

# 데이터 로드
source("scripts/data_loading.R")
# source("scripts/data_preprocessing.R")
# source("scripts/analysis.R")

st_info <- as_tibble(students_info(202402,'재학생'))

# 학과별, 국적별 학생 수 집계
st_foreigner <- st_info %>%
  group_by(학과, 국적) %>%
  summarise(학생수 = n(), .groups = "drop") %>% 
  filter(학과 == '경영학부' & 국적 != '대한민국') %>% 
  select(국적, 학생수) %>%
  arrange(desc(학생수))  # 학생수를 기준으로 내림차순 정렬

# 국적을 학생수에 따라 정렬된 팩터로 변환
st_foreigner <- st_foreigner %>%
  mutate(국적 = factor(국적, levels = 국적))



# st_foreigner_for_barplot <- st_info %>%
#   group_by(학과, 국적) %>%
#   summarise(학생수 = n(), .groups = "drop") %>% filter(학과 == '경영학부' & 국적 != '대한민국') %>% select(국적, 학생수)  %>%
#   arrange(desc(학생수))  %>% # 학생수를 기준으로 내림차순 정렬 
#   pivot_wider(names_from = 국적, values_from = 학생수, values_fill = 0)

# 결과 출력
print(st_foreigner)

# # barplot 출력
# barplot(as.matrix(st_foreigner_for_barplot),
#         ylim = c(0,300),
#         col = "skyblue",
#         cex.axis = 0.9, cex.names=0.7,
#         xlab ='Nationality', ylab='Number of students',
#         main = '경영대 국적별 외국인 학생수' )
# 
# # 막대 위에 값 표기
# text(x = bar, y = st_foreigner_for_barplot[1,], label = st_foreigner_for_barplot[1,], pos = 3, cex = 0.8, col = "red")



library(ggplot2)

# Assuming 'st_foreigner' is a data frame with columns 'Nationality' and 'Number_of_students'
ggplot(st_foreigner, aes(x = 국적, y = 학생수)) +
  geom_bar(stat = "identity", fill = "skyblue") + 
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  labs(x = "Nationality", y = "Number of students") +
  theme_minimal(base_size = 14) +  # 깔끔한 테마 적용
  theme(axis.text.x = element_text(angle = 15, hjust = 1),  # Rotate x-axis labels
        axis.text = element_text(size = 9),
        axis.title = element_text(size = 11),
        panel.grid.major = element_blank(),  # 주 격자선 제거
        panel.grid.minor = element_blank(),  # 부 격자선 제거
        panel.background = element_rect(fill = "white", color = NA),  # 배경을 흰색으로 설정
        # axis.line.x = element_line(color = "black"),  # x축 선 추가
        # axis.line.y = element_line(color = "gray")  # y축 선 추가
  )


  
st_dp <- st_info %>%
  group_by(학과, 국적) %>%
  summarise(학생수 = n(), .groups = "drop") %>%
  arrange(desc(학생수))

# 스택형 막대그래프
ggplot(st_dp, aes(x = 학과, y = 학생수, fill = 국적)) +
  geom_bar(stat = "identity") +
  labs(title = "학과별 국적 학생수", x = "학과", y = "학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # x축 레이블 기울이기


# 군집형 막대그래프
ggplot(st_dp, aes(x = 학과, y = 학생수, fill = 국적)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "학과별 국적 학생수", x = "학과", y = "학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # x축 레이블 기울이기


