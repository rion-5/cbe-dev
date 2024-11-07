source("scripts/dbms_dml.R")

# 재학생 정보  (from db)
students_info <- function(terms, status) {
  query <- paste0(
    "select 학과, 학적상태, 국적 ",
    "from 학적대장조회내역 ",
    "where 학기 = ",terms , " and 학적상태 = '",status , "';"
  )
  return(request_quantdb(query))
}

# 취업정보 (from db)
employment_info <- function(year) {
  query <- paste0("select 학과명, 성별, 졸업년월, 출신고교, 외국인학생, 회사명, 
                  부서, 근무지, 평점평균, 입학전형명, 토익점수, 교환유학생여부, 
                  취업구분 
                  from 취업통계졸업생명단 ;"
  )
  return(request_quantdb(query))
}