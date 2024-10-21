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
