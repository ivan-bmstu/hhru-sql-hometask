WITH vacancy_by_month(
  vacancy_month_count,
  vacancy_month_publicated
  ) AS (
  SELECT
    count(vacancy_id) AS vacancy_month_count,
    EXTRACT(MONTH FROM date_publication) AS vacancy_month_publicated
  FROM vacancy
  GROUP BY vacancy_month_publicated
  ORDER BY vacancy_month_count DESC
),
resume_by_month(
  resume_month_count,
  resume_month_publicated
  ) AS (
  SELECT
    count(resume_id) AS resume_month_count,
    EXTRACT(MONTH FROM date_created) AS resume_month_publicated
  FROM resume
  GROUP BY resume_month_publicated
  ORDER BY resume_month_count DESC
)
SELECT
  vacancy_by_month.vacancy_month_count,
  vacancy_by_month.vacancy_month_publicated,
  resume_by_month.resume_month_count,
  resume_by_month.resume_month_publicated
FROM vacancy_by_month, resume_by_month
LIMIT 1;
--p.s. я бы сделал два разных запроса
-- SELECT
--   count(vacancy_id) AS vacancy_month_count,
--   EXTRACT(MONTH FROM date_publication) AS vacancy_month_publicated
-- FROM vacancy
-- GROUP BY vacancy_month_publicated
-- ORDER BY vacancy_month_count DESC
-- LIMIT 1;
--
-- SELECT
--   count(resume_id) AS resume_month_count,
--   EXTRACT(MONTH FROM date_created) AS resume_month_publicated
-- FROM resume
-- GROUP BY resume_month_publicated
-- ORDER BY resume_month_count DESC
-- LIMIT 1;