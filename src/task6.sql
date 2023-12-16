/*
Для определения нужного индекса, нужно понять два важных параметра, которые мы будем оптимизировать:
- размер таблицы (для небольшой и почти неизменяемой таблицы индекс скорее всего можно не добавлять)
- как часто будут обращаться с запросами считывания (чем чаще обращаемся, чем больше шансов, что понадобится индекс)
- (менее важный как мне кажется параметр) как часто вносятся данные (если мы скорее только добавляем данные,
    и очеень редко читаем их, то мб индекс и не нужен)

Исходя из схемы, большими таблицами являются: вакансии, резюме, пользователи, компании. Им точно желательно ввести индекс
Возможно рассмотреть условия запроса: чтение идет только по АКТИВНЫМ вакансиям и резюме, по неактивным - только в истории( а это
  уже можно и не быстро показывать) - значит можно попробовать использовать частичный индекс.
*/

--Рассмотрим ниже наиболее распространенные запросы и время их выполнения без индексов

--создадим VIEW для запроса поиска вакансий по условиям
CREATE VIEW search_vacancy_list AS
SELECT
  vacancy.vacancy_id,
  vacancy.vacancy_name,
  CASE WHEN gross THEN compensation_from * 0.87
       ELSE compensation_from
    END                                             AS compensation_from,
  CASE WHEN gross THEN compensation_to * 0.87
       ELSE compensation_to
    END                                             AS compensation_to,
  area.area,
  work_experience.years_experience,
  vacancy.work_experience_id,
  company.company_name,
  company.company_id,
  vacancy.narrow_spec_id,
  vacancy.general_spec_id
FROM vacancy
  INNER JOIN area ON vacancy.area_id = area.area_id
  INNER JOIN work_experience on vacancy.work_experience_id = work_experience.work_experience_id
  INNER JOIN company on vacancy.company_id = company.company_id
WHERE active;

/*
CASE 1 before index
Planning Time: 0.530 ms
Execution Time: 125.970 ms
Real Time: 368 ms
------------------
CASE 1 after index
Planning Time: 0.441 ms
Execution Time: 1.723 ms
Real Time: 78 ms
*/
EXPLAIN ANALYSE
SELECT *
FROM search_vacancy_list
WHERE vacancy_name LIKE '123%';

/*
CASE 2 before index
Planning Time: 0.348 ms
Execution Time: 123.471 ms
Real Time: 356 ms
------------------
CASE 2 after index
Planning Time: 0.591 ms
Execution Time: 1.053 ms
Real Time: 94 ms
*/
EXPLAIN ANALYSE
SELECT *
FROM search_vacancy_list
WHERE
  vacancy_name LIKE '123%'
  AND compensation_to >= 80000;

/*
CASE 3 before index
Planning Time: 0.372 ms
Execution Time: 119.437 ms
Real Time: 355 ms
------------------
CASE 3 after index
Planning Time: 0.453 ms
Execution Time: 0.639 ms
Real Time: 74 ms
*/
EXPLAIN ANALYSE
SELECT *
FROM search_vacancy_list
WHERE
  vacancy_name LIKE '123%'
  AND work_experience_id = 1;

--также может быть очень большой фильтр по поиску
/*
CASE 4 before index
Planning Time: 0.453 ms
Execution Time: 121.563 ms
Real Time: 387 ms
------------------
CASE 4 after index
Planning Time: 0.567 ms
Execution Time: 8.543 ms
Real Time: 69 ms
*/
EXPLAIN ANALYSE
SELECT *
FROM search_vacancy_list
WHERE
    vacancy_name LIKE '12%'
  AND work_experience_id IN (2, 3)
  AND compensation_to > 60000
  AND company_id BETWEEN 100 AND 600;

/* таблица вакансий большая и часто идет поиск по ней --> нужно сделать индексы*/
--индекс для ускорения поиска вакансии по названию
CREATE INDEX vac_name_index ON vacancy(vacancy_name text_pattern_ops); --без параметра text_pattern_ops у меня не использовался индекс
--индекс для ускорения поиска вакансии по вилке зарплаты
CREATE INDEX active_vacancy_compensation_index ON vacancy(compensation_to, compensation_from) WHERE active; -- чаще смотри comp to, поэтому он впереди
--индекс для ускорения поиска вакансии по специализации
CREATE INDEX active_vacancy_specialization_index ON vacancy(narrow_spec_id, general_spec_id) WHERE active;
--индекс для ускорения поиска вакансии по конкретному id
CREATE INDEX vacancy_companyid_index ON vacancy(company_id);
-----------------------------------------------------------
/* таблица резюме большая и часто компании могут вести поиск по ней --> нужно сделать индексы*/
--индекс для ускорения поиска резюме по названию должности
CREATE INDEX active_resume_title_index ON resume(title_position text_pattern_ops) WHERE active;
--индекс для ускорения поиска резюме по специализации
CREATE INDEX active_resume_specialization_index ON resume(narrow_spec_id);
--если нам нужно получить полную информацию о резюме по индексу
CREATE INDEX resume_id_index ON resume(resume_id);
-----------------------------------------------------------
--для быстрого поиска юзера по user_name
CREATE INDEX user_index ON hhuser(user_name text_pattern_ops);
-----------------------------------------------------------
--для быстрого поиска компании по ее названию
CREATE INDEX company_name_index ON company (company_name text_pattern_ops);
