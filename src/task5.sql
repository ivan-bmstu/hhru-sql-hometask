/*
запрос для получения id и title вакансий, которые собрали больше 5 откликов в первую неделю после публикации
*/

SELECT vacancy.vacancy_id, vacancy.vacancy_name
FROM vacancy
LEFT JOIN response ON vacancy.vacancy_id = response.vacancy_id
WHERE
  response.date_response >= vacancy.date_publication
  AND response.date_response <= vacancy.date_publication + INTERVAL '1 week'
GROUP BY vacancy.vacancy_id
HAVING count(response.response_id) > 5;
