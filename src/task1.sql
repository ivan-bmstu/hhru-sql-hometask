--спроектируем БД hh.ru
-- CREATE DATABASE headhunter;
-- \c headhunter;
--^^^^ не совсем понимаю как из скрипта переключить БД

-------------------------------
/*
первые две таблицы служебные, они будут содержать
типичные представления для других таблиц
*/

CREATE TABLE response_status(
  response_status_id SERIAL PRIMARY KEY,
  status TEXT NOT NULL
);

CREATE TABLE work_experience(
  work_experience_id SERIAL PRIMARY KEY,
  years_experience TEXT NOT NULL DEFAULT 'Без опыта'
);

--для отображения специализаций без if условий разделим спец-ии на группу и подгруппу
CREATE TABLE generalized_specialization(
  gen_spec_id SERIAL PRIMARY KEY,
  spec_name TEXT
);

CREATE TABLE narrow_specialization(
  narrow_spec_id SERIAL PRIMARY KEY,
  spec_name TEXT,
  gen_spec_id INTEGER REFERENCES generalized_specialization(gen_spec_id)
);

CREATE TABLE company (
  company_id SERIAL PRIMARY KEY,
  company_name TEXT NOT NULL,
  rating SMALLINT,
  web_page TEXT
);

CREATE TABLE area(
  area_id SERIAL PRIMARY KEY,
  area TEXT DEFAULT 'Moscow'
);

--адрес по-хорошему тоже как-то структурировать в отдельной таблице
CREATE TABLE vacancy (
  vacancy_id SERIAL PRIMARY KEY,
  vacancy_name TEXT NOT NULL,
  work_experience_id SMALLINT REFERENCES work_experience(work_experience_id) default 0,
  vacancy_description TEXT,
  date_publication DATE NOT NULL DEFAULT now(),
  company_id INTEGER REFERENCES company(company_id) NOT NULL,
  compensation_from INTEGER,
  compensation_to INTEGER,
  narrow_spec_id INTEGER REFERENCES narrow_specialization(narrow_spec_id),
  general_spec_id INTEGER REFERENCES generalized_specialization(gen_spec_id),
  area_id INTEGER NOT NULL REFERENCES area(area_id),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  gross BOOLEAN NOT NULL
);

CREATE TABLE hhuser(
  user_id SERIAL PRIMARY KEY,
  user_name TEXT NOT NULL,
  full_name TEXT
);

CREATE TABLE response(
  response_id SERIAL PRIMARY KEY,
  status_id INTEGER REFERENCES response_status(response_status_id),
  vacancy_id INTEGER REFERENCES vacancy(vacancy_id),
  user_id INTEGER REFERENCES hhuser(user_id) NOT NULL,
  date_response DATE NOT NULL DEFAULT now()
);

CREATE TYPE gender AS ENUM ('м', 'ж');

CREATE TABLE resume(
  resume_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  phone_numb CHAR(12),
  email TEXT NOT NULL,
  area_id INTEGER NOT NULL REFERENCES area(area_id),
  title_position TEXT,
  narrow_spec_id INTEGER NOT NULL REFERENCES narrow_specialization(narrow_spec_id),
  sex gender,
  date_created DATE NOT NULL DEFAULT now(),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  user_id INTEGER NOT NULL REFERENCES hhuser(user_id)
);
