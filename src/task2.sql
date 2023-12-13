INSERT
INTO work_experience(years_experience)
VALUES ('Не имеет значения'),
       ('Нет опыта'),
       ('От 1 года до 3 лет'),
       ('От 3 до 6 лет'),
       ('Более 6 лет');

WITH test_gen_spec(id, title) AS (
  SELECT
    generate_series(1, 30) AS id,
    md5(random()::text)    AS title
)
INSERT
INTO generalized_specialization(gen_spec_id, spec_name)
SELECT id, title
FROM test_gen_spec;

WITH test_area(id, area) AS (
  SELECT
    generate_series(1, 200) AS id,
    md5(random()::text)    AS title
)
INSERT
INTO area(area_id, area)
SELECT id, area
FROM test_area;

WITH test_narrow_spec(id, title, gen_id) AS (
  SELECT
    generate_series(1, 300) AS id,
    md5(random()::text)     AS title,
    random()*29 + 1         AS gen_id
)
INSERT
INTO narrow_specialization(refined_spec_id, spec_name, gen_spec_id)
SELECT id, title, gen_id
FROM test_narrow_spec;

WITH test_hhuser(id, uname) AS (
  SELECT
    generate_series(1, 1000) AS id,
    md5(random()::text)     AS uname
)
INSERT
INTO hhuser(user_id, user_name)
SELECT id, uname
FROM test_hhuser;

INSERT
INTO response_status(status)
VALUES ('Приглашение'),
       ('Резюме просмотрено'),
       ('Компания заблокирована'),
       ('Резюме не просмотрено');

WITH test_company(id, title, rating, web_page) AS (
  SELECT
    generate_series(1, 1000)       AS id,
    md5(random()::text)            AS title,
    random() * 50                    AS gen_id,
    md5(random()::text)            AS web_page
)
INSERT
INTO company(company_id, company_name, rating, web_page)
SELECT id, title, rating, web_page
FROM test_company;

WITH test_vacancy(
  id, sample_text, work_id,
  area_id, date_pub, comp_id,
  salary) AS (
  SELECT
    generate_series(1, 10000)                 AS id,
    md5(random()::text)                       AS sample_text,
    random() * 4 + 1                          AS work_id,
    random() * 199 + 1                        AS area_id,
    '2022-12-12'::date +
     (random() * 365)::int                    AS date_pub,
    random() * 999 + 1                        AS comp_id,
    round((random() * 100000)::int, -3)       AS salary
)
INSERT
INTO vacancy(
  vacancy_id, vacancy_name, work_experience_id,
  vacancy_description, area_id, date_publication,
  company_id, compensation_from, compensation_to,
  compensation_gross)
SELECT
  id, sample_text, work_id,
  sample_text || 'a', area_id, date_pub,
  comp_id, salary, salary + 10000, true
FROM test_vacancy;

WITH test_response(
  id, status_reference_id,
  vacancy_id, date_response) AS (
  SELECT
    generate_series(1, 20000)             AS id,
    random() * 3 + 1                       AS status_reference_id,
    random() * 9999 + 1                    AS vacancy_id,
    '2022-12-12'::date +
      (random() * 365)::int  AS date_pub
)
INSERT
INTO response(response_id, status_id, vacancy_id, date_response)
SELECT
  id, status_reference_id,
  vacancy_id, date_response
FROM test_response;

CREATE TYPE gender as enum('м','ж');

WITH test_resume(
  id, text_sample,
  phone, area_id,
  narrow_spec_id, sex,
  birthday, user_id) AS (
  SELECT
    generate_series(1, 100000)                               AS id,
    md5(random()::text)                                      AS text_sample,
    '+7' || floor((random() * 99999999 + 1000000000))::text  AS phone,
    random() * 199 + 1                                       AS area_id,
    random() * 299 + 1                                       AS narrow_spec_id,
    (ARRAY['м', 'ж'])[floor(random() * 2) + 1]               AS sex,
    '1950-01-01'::date +
    (random() * 365 * 60)::int                               AS birthday,
    random() * 999 + 1                                       AS user_id
)
INSERT
INTO resume(
  resume_id, first_name, last_name,
  phone_numb, email, area_id,
  title_position, narrow_spec_id, sex,
  birthday, active, user_id
)
SELECT
  id, text_sample, text_sample || 'a',
  phone, text_sample || '@hh.com', area_id,
  text_sample || ' title', narrow_spec_id, sex,
  birthday, true, user_id
FROM test_resume;