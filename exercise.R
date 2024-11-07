library(tidyverse)
library(showtext)

showtext_auto()

source('./scripts/data_loading.R')
students_info <- students_info(202402,'재학생')

students_dept <- students_info %>%
  group_by(학과, 국적) %>%
  summarise(학생수 = n(), .groups = 'drop')

# students_foreigner <- students_info %>%
#   group_by(학과, 국적) %>%
#   summarise( 학생수 = n(), .groups = 'drop') %>%
#   filter(국적 != '대한민국') %>%
#   arrange(학과, desc(학생수)) 

# #스택형 막대그래프
# ggplot(students_foreigner, aes(x=학과, y=학생수, fill=국적)) +
#   geom_bar(stat = "identity")+
#   labs(title = "학과별 국적 학생수", x = "학과", y = "학생수") +
#   theme_minimal()
# 
# #군집형 막대그래프
# ggplot(students_foreigner, aes(x=학과, y=학생수, fill=국적)) +
#   geom_bar(stat = "identity", position = "dodge")


# 필요한 패키지 로드
library(ggplot2)
library(gridExtra)

# y축의 최대값을 확인하여 동일하게 설정
max_y <- max(students_dept$학생수)

# 국적의 범주를 고정
all_nationalities <- unique(students_dept$국적)

p1 <- ggplot(students_dept %>% filter(학과 == '경제학부'), aes(x = 국적, y = 학생수)) +   
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  ylim(0, max_y) +
  scale_x_discrete(limits = all_nationalities) +  # 동일한 x축 범주 사용
  ggtitle("경제학부 국적별 학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))  # x축 레이블 기울이기

p2 <- ggplot(students_dept %>% filter(학과 == '경영학부'), aes(x = 국적, y = 학생수)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  scale_x_discrete(limits = all_nationalities) +  # 동일한 x축 범주 사용
  ylim(0, max_y) +
  ggtitle("경영학부 국적별 학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))  # x축 레이블 기울이기

p3 <- ggplot(students_dept %>% filter(학과 == '보험계리학과'), aes(x = 국적, y = 학생수)) +   
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  scale_x_discrete(limits = all_nationalities) +  # 동일한 x축 범주 사용
  ylim(0, max_y) +
  ggtitle("보험계리학과 국적별 학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))  # x축 레이블 기울이기

p4 <- ggplot(students_dept %>% filter(학과 == '회계세무학과'), aes(x = 국적, y = 학생수)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = 학생수), vjust = -0.5, size = 3) +  # Add student count on top of bars
  scale_x_discrete(limits = all_nationalities) +  # 동일한 x축 범주 사용
  ylim(0, max_y) +
  ggtitle("회계세무학과 국적별 학생수") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))  # x축 레이블 기울이기

grid.arrange(p1, p2, p3, p4, nrow = 2, ncol =2)