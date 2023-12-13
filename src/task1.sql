CREATE DATABASE headhunter;

/*
первые две таблицы служебные, они будут содержать
типичные представления для других таблиц
*/

CREATE TABLE response_status(
  response_status_id serial primary key,
  status text not null
);

CREATE TABLE work_experience(
  work_experience_id serial primary key,
  years_experience text not null default 'Без опыта'
);

--для отображения специализаций без if условий разделим спец-ии на группу и подгруппу
CREATE TABLE generalized_specialization(
  gen_spec_id serial primary key,
  spec_name text
);

CREATE TABLE narrow_specialization(
  refined_spec_id serial primary key,
  spec_name text,
  gen_spec_id integer references generalized_specialization(gen_spec_id)
);

CREATE TABLE company (
  company_id serial primary key,
  company_name text not null,
  rating smallint,
  web_page text
);

--адрес по-хорошему тоже как-то структурировать в отдельной таблице
CREATE TABLE vacancy (
  vacancy_id serial primary key,
  vacancy_name text not null,
  work_experience_id smallint references work_experience(work_experience_id) default 0,
  vacancy_description text,
  date_publication date not null default now(),
  company_id integer references company(company_id) not null,
  compensation_from integer,
  compensation_to integer,
  compensation_gross boolean not null default false,
  area_id integer not null references area(area_id)
);

CREATE TABLE response(
  response_id serial primary key,
  status_id integer references response_status(response_status_id),
  vacancy_id integer references vacancy(vacancy_id),
  date_response date not null default now()
);

CREATE TABLE area(
  area_id serial primary key,
  area text default 'Moscow'
);

CREATE TABLE hhuser(
  user_id serial primary key,
  user_name text not null
);

CREATE TABLE resume(
  resume_id serial primary key,
  first_name text not null,
  last_name text not null,
  phone_numb char(12),
  email text not null,
  area_id integer not null references area(area_id),
  title_position text not null default 'джавист',
  narrow_spec_id integer not null references narrow_specialization(refined_spec_id),
  sex char(1) not null CHECK ( sex IN ('м', 'ж') ),
  birthday date not null default now(),
  active boolean not null default true,
  user_id integer not null references hhuser(user_id)
);
