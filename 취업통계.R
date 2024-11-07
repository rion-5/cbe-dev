#취업통계.R
library(tidyverse)
library(showtext)
library(dplyr)
showtext_auto()

# 데이터 가져오기
source("./scripts/data_loading.R")
em_info <- as_tibble(employment_info())
em_info <- em_info %>%
  rename(
    major = 학과명,
    gender = 성별,
    graduation_date = 졸업년월,
    high_school = 출신고교,
    foreign_student = 외국인학생,
    company_name = 회사명,
    department = 부서,
    workplace = 근무지,
    GPA = 평점평균,
    admission_type = 입학전형명,
    TOEIC_score = 토익점수,
    exchange_student = 교환유학생여부,
    employment_type = 취업구분
  )
# 데이터 전처리
em_info$foreign_student <- ifelse(em_info$foreign_student == '예',1,0)

# '취업구분'을 기반으로 '취업여부' 컬럼 생성
em_info$employment_status <- ifelse(em_info$employment_type %in% c('기타', '미상', '선택'), 0, 1)

em_gpa_toeic <- em_info %>%
  select(c(major,GPA,TOEIC_score,employment_status )) %>%
  filter(!is.na(TOEIC_score ))

# 데이터 분할: 70%는 훈련, 30%는 테스트
set.seed(123)  # 재현성을 위해 시드 설정
trainIndex <- caret::createDataPartition(em_gpa_toeic$employment_status, p = 0.7, list = FALSE)
trainData <- em_gpa_toeic[trainIndex, ]
testData <- em_gpa_toeic[-trainIndex, ]

# 로지스틱 회귀 모델 학습
model <- glm(employment_status ~ GPA + TOEIC_score, data = trainData, family = binomial)

# 모델 요약 보기
summary(model)

# 예측
predicted <- predict(model, newdata = testData, type = "response")
predicted_class <- ifelse(predicted > 0.5, 1, 0)

# 모델 평가
caret::confusionMatrix(as.factor(predicted_class), as.factor(testData$employment_status))


# 상관계수 계산
correlation <- cor(em_info$GPA, em_info$TOEIC_score, use = "complete.obs")
correlation

# 산점도 생성
library(ggplot2)
ggplot(em_info, aes(x = GPA, y = TOEIC_score)) +
  geom_point(color = "blue") +                 # 산점도를 파란색 점으로 표시
  geom_smooth(method = "lm", color = "red") +  # 회귀선 추가
  labs(title = "평점평균과 토익점수의 산점도",
       x = "GPA",
       y = "TOEIC_score") +
  theme_minimal() 
