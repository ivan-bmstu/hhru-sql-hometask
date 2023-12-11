/*
запрос для получения средних значений по регионам (area_id) следующих величин:
compensation_from, compensation_to, среднее_арифметическое_from_и_to
*/

WITH vacancy_allgross_compensation(
  comp_from,
  comp_to,
  date_pub,
  area_id) AS (
  SELECT
    CASE WHEN gross THEN compensation_from * 0.87
      ELSE compensation_from
    END                                             AS comp_from,
    CASE WHEN gross THEN compensation_to * 0.87
         ELSE compensation_to
      END                                           AS comp_to,
    date_publication                                AS date_pub,
    area_id                                         AS area_id
  FROM vacancy
)
SELECT
  area_id                       AS area_id,
  AVG(comp_from)                AS avg_compensation_from,
  AVG(comp_to)                  AS avg_compensation_from,
  AVG(comp_from + comp_to)      AS avg_compensation_sum_from_and_to
FROM vacancy_allgross_compensation
GROUP BY area_id
ORDER BY area_id ASC;
