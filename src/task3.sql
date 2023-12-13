SELECT
  area_id AS area_id,
  AVG(compensation_from) AS avg_compensation_from,
  AVG(compensation_to) AS avg_compensation_from,
  AVG(compensation_from + compensation_to) AS avg_compensation_sum_from_and_to
FROM vacancy
GROUP BY area_id
ORDER BY area_id ASC;