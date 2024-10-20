source("scripts/dbms_dml.R")

# 재학생 정보  (from db)
students_info <- function() {
  query <- paste0(
    "select 학과, 학적상태, 국적 ",
    "from 학적대장조회내역 ",
    "where 학기 = 202402 and 학적상태 = '재학생';"
  )
  return(request_quantdb(query))
}
