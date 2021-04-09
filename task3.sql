--3-1
DROP TABLE IF EXISTS person,person_contact;

CREATE TABLE person (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR (50),
	last_name VARCHAR (50),
	email VARCHAR (50) UNIQUE
);

CREATE TABLE person_contact
(
  id   int PRIMARY KEY,
  phone VARCHAR(32),
  FOREIGN KEY (id) REFERENCES person (id) on delete cascade
);

INSERT INTO person(first_name,last_name,email)
VALUES('anna','baranova','a.baranova@gmail.com'); --ok

INSERT INTO person(first_name,last_name,email)
VALUES('sasha','baranova','s.baranova@gmail.com');
--unique error

INSERT INTO person_contact(id, phone)
VALUES (1, '88005553535'),
       (2, '89833099205');

INSERT INTO person(first_name, id)
VALUES ('kirill', 1);
--error id =1 exists

DELETE
FROM person_contact
WHERE phone LIKE '88005553535';

--without delete cascade - error
delete
from person
where id=2;

UPDATE person
SET id = 11
WHERE id = 1;

--sql level
DROP TABLE IF EXISTS A,B,C;

CREATE TABLE A (
	id int PRIMARY KEY,
	data varchar
);

CREATE TABLE B (
	id int PRIMARY KEY,
	data int CHECK (B.data < 1000),
	aid int REFERENCES A(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
--ON DELETE RESTRICT означает, что если попробовать удалить пользователя,
-- у которого в таблице заказов есть данные, БД не даст этого сделать
--ON UPDATE RESTRICT : the default : if you try to update a company_id in table COMPANY
--the engine will reject the operation if one USER at least links on this company.

CREATE TABLE C (
	id int PRIMARY KEY,
	data varchar,
	aid int REFERENCES A(id) ON DELETE CASCADE ON UPDATE CASCADE
);

--ON UPDATE CASCADE говорит о том, что в случае если кто-то решит изменить ID пользователя,
-- все его заказы получат новый, измененный ID.
--ON DELETE CASCADE, БД сама удалила бы все заказы пользователя при его удалении

INSERT INTO A (id, data) VALUES
(1, 'ооп'),
(2, 'бд'),
(3, 'цис'),
(4, 'тсани'),
(5, 'эвм');

INSERT INTO B (id, data, aid) VALUES
(10, 345, 1),
(20, 289, 2);

INSERT INTO C (id, data, aid) VALUES
(100, 'android', 1),
(200, 'ios', 2);

INSERT INTO A (id, data) VALUES (3, 'матан'); -- error primary key

INSERT INTO B (id, data, aid) VALUES (30, 1099, 3); -- error check

INSERT INTO C (id, data, aid) VALUES (700, 'web', 7); -- error foreign key

UPDATE A SET id = 10 WHERE id = 1; -- error B restrict
--на ключ id=1 все еще есть ссылки в таблице b

INSERT INTO C (id, data, aid) VALUES (400, 'backend', 4);--Ok, add

UPDATE A SET id = 40 WHERE id = 4; -- OK (C cascade), nothing with id=4

DELETE FROM A WHERE id = 1; --error B restrict, на ключ id=1 все еще есть ссылки в таблице b

DELETE FROM A where id = 40; -- OK (C cascade)

UPDATE B SET id = 20 WHERE id = 10; -- error primary key

UPDATE B SET data = 2000 WHERE id = 10; -- error check

--3-2
--one to one
drop table if exists students, student_info;

CREATE TABLE students
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(20),
  surname VARCHAR(20)
);

CREATE TABLE student_info
(
  id INT PRIMARY KEY,
  language varchar(30),
  FOREIGN KEY (id) REFERENCES students(id)
);

insert into students(name,surname)
values ('Alex','Devyatovskaya'),
       ('Oleg', 'Lopuchov'),
       ('Dima', 'Shonin'),
       ('Dima', 'Bogomazov'),
       ('Denis', 'Bakhtenev');

insert into student_info(id, language)
values (1, 'java'),
       (2, 'Kotlin'),
       (3, 'Python'),
       (4, 'JavaScript'),
       (5, 'Kotlin');
--one to many
CREATE TABLE customers
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE orders
(
    order_id SERIAL PRIMARY KEY,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

insert into customers(id, name)
values (1, 'alice'),
       (2, 'bob');

insert into orders(order_id,customer_id)
VALUES (1111, 1),
       (2231, 1),
       (3663, 2),
       (571, 1);

--many to many
CREATE TABLE workers
(
  id SERIAL PRIMARY KEY
);

CREATE TABLE work_place
(
  id SERIAL PRIMARY KEY
);

CREATE TABLE a_b_join
(
  workers_id INT,
  work_place_id INT,
  FOREIGN KEY (workers_id) REFERENCES workers (id),
  FOREIGN KEY (work_place_id ) REFERENCES work_place (id),
  PRIMARY KEY (workers_id, work_place_id )
);

--3-3
drop table if exists Task3;

CREATE TABLE Task3
(
  id_message int PRIMARY KEY ,
  login varchar(30),
  work_place varchar(20),
  name varchar,
  event varchar,
  label varchar,
  message varchar,
  createtime timestamp,
  theme varchar,
  link varchar
);
INSERT INTO Task3(id_message, login, work_place, name, event, label, message, createtime, theme, link)
VALUES (1, 'a.devyatovskaya', 'nsu', 'Alexandra', 'hw4','#hw4', 'Олеееж, я честно завтра скину','2021-03-31 13:23:54', 'recycler_view', 'git_hw4' ),
       (2, 'd.shonin', 'nsu', 'Dmitry', 'office', '#office', 'Я пришел!!!', '2021-03-31 17:53:56', 'office',NULL),
       (3, 'o.pugacheva', 'vki', 'Oksana','office','#office','А я опоздаю', '2021-03-31 17:59:11', 'office', NULL),
       (4, 'o.lopuchov', 'improve group', 'Oleg', 'hw4', '#hw4', 'Саш, жду до вечера пятницы, потом ругаюсь','2021-03-31 18:48:45', 'recycler_view', 'tz4'),
       (5, 'd.bogomazov', 'web group','Dmitry','lections','#some','Скиньте лекцию по активити','20201-03-31 18:56:03','office',NULL),
       (6, 'd.bachtenev', 'vki', 'Denis', 'errors', 'errors', 'Да тут нужен ConstraintLayout, вы че', '2021-03-31 19:03:00', 'lections', 'Constraint_layout'),
       (7, 'm.belyi', 'improve group', 'Max', 'office', '#some', 'А че вам тут Олег рассказывает', '2021-04-01 01:45:34', 'office',NULL),
       (8, 'o.lopuchov', 'improve group', 'Oleg', 'hw5', '#hw5', 'Скинул новую домашку, сделать до пятницы', '2021-04-01 04:23:23', 'activity', 'tz5');
--144
--а group несколько
select login
from Task3
where work_place='group';

--2
delete from Task3
where login = 'd.bachtenev';

update Task3
set event='hw5'
where event='hw4';

--аномалия вставки
create table studentPerformance(
    number serial,
    student varchar(50),
    id_card varchar(4),
    subject varchar(20),
    teacher varchar(50),
    department varchar(25),
    grade int
);
INSERT into studentPerformance(student, id_card, subject, teacher, department, grade)
values ('Petrov.N.N', 4566, 'Physics', 'Borisov.M.A', 'TeorPhysics', 5),
        ('Petrov.N.N', 4566, 'Chemistry', 'Svinolupova.N.A', 'NaturalScience', 4),
       ('Sidorova.T.E', 2730, 'Physics', 'Borisov.M.A', 'TeorPhysics', 5),
        ('Konovalov.K.S', 1289, 'MedicalStaff', 'Givolupova E.N.', 'MedicalScience', 4);
--надо добавить в базу нового преподавателя физики, которого недавно приняли
--Для этого необходимо, чтобы новый преподаватель обязательно оценил хотя бы одного студента.
--Иначе, в таком представлении базы данных, добавить данные будет невозможно.
-- Значит, при добавлении преподавателя, нужно выгадывать несуществующие данные оценивания студента

create table studentInfo(
    number serial PRIMARY KEY,
    student varchar(100),
    id_card varchar(4),
    address varchar(100)
);

--как вылавливать имя и адрес?
INSERT INTO studentInfo(student, id_card, address)
VALUES ('Коновалов Антон Андреевич', '1234', 'ул.Пирогова, д.2, к.4'),
       ('Анастасия Михеева Андреевна','3747','улица Майская, корпус 3, дом 56'),
       ('Беркут Михаил','2889','д.33, Ленинский пр., лит.А'),
       ('Михайловна Катерина Шульц', '7474','пр. Ленинский, д.22');
