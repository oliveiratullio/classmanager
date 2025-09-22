DROP TABLE IF EXISTS class_schedule CASCADE;
DROP TABLE IF EXISTS class CASCADE;
DROP TABLE IF EXISTS subject_prerequisite CASCADE;
DROP TABLE IF EXISTS subject CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS building CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS title CASCADE;
DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE title (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE professor (
  id            SERIAL PRIMARY KEY,
  name          TEXT NOT NULL,
  department_id INT REFERENCES department(id),
  title_id      INT REFERENCES title(id)
);

CREATE TABLE building (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE room (
  id          SERIAL PRIMARY KEY,
  building_id INT REFERENCES building(id),
  name        TEXT NOT NULL
);

CREATE TABLE subject (
  id            SERIAL PRIMARY KEY,
  code          TEXT NOT NULL UNIQUE,
  name          TEXT NOT NULL,
  professor_id  INT REFERENCES professor(id),
  department_id INT REFERENCES department(id)
);

CREATE TABLE subject_prerequisite (
  id              SERIAL PRIMARY KEY,
  subject_id      INT NOT NULL REFERENCES subject(id),
  prerequisite_id INT NOT NULL REFERENCES subject(id)
);

CREATE TABLE class (
  id         SERIAL PRIMARY KEY,
  subject_id INT NOT NULL REFERENCES subject(id),
  year       INT NOT NULL,
  semester   INT NOT NULL,
  code       TEXT NOT NULL
);

CREATE TABLE class_schedule (
  id          SERIAL PRIMARY KEY,
  class_id    INT NOT NULL REFERENCES class(id),
  room_id     INT NOT NULL REFERENCES room(id),
  day_of_week INT NOT NULL,           -- 1..7 (ajuste seu padrão)
  start_time  TIME NOT NULL,
  end_time    TIME NOT NULL,
  CHECK (end_time > start_time)
);

CREATE INDEX idx_cs_room_day ON class_schedule(room_id, day_of_week, start_time);
CREATE INDEX idx_sub_prof     ON subject(professor_id);
