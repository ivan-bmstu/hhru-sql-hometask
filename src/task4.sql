/*
запрос для получения месяца с наибольшим количеством вакансий и месяца с наибольшим количеством резюме
*/

WITH vacancy_by_month_year(
  vacancy_month_count,
  vacancy_publicated
  ) AS (
  SELECT
    count(vacancy_id)                      AS vacancy_month_count,
    date_trunc('month', date_publication)  AS vacancy_date_publicated
  FROM vacancy
  GROUP BY vacancy_date_publicated
  ORDER BY vacancy_month_count DESC
),
resume_by_month_year(
  resume_month_count,
  resume_publicated
  ) AS (
  SELECT
    count(resume_id)                    AS resume_month_count,
    date_trunc('month', date_created)   AS resume_date_publicated
  FROM resume
  GROUP BY resume_date_publicated
  ORDER BY resume_month_count DESC
)
SELECT
  to_char(vacancy_by_month_year.vacancy_publicated, 'yyyy-mm')   AS month_publication_of_max_vacancy,
  vacancy_by_month_year.vacancy_month_count                      AS vacancy_count,
  to_char(resume_by_month_year.resume_publicated, 'yyyy-mm')     AS month_publication_of_max_resume,
  resume_by_month_year.resume_month_count                        AS resume_count
FROM vacancy_by_month_year, resume_by_month_year
LIMIT 1;
--p.s. я бы сделал два разных запроса
