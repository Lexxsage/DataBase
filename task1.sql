--1-1
create table Users(
    Name VARCHAR(32) NOT NULL,
    Surname varchar(32) NOT NULL ,
    Login VARCHAR(32),
    Email VARCHAR(32),
    -- accounting - бухгалтерия
    -- Опция CHECK обеспечивает ограничение,  которое позволяет  установить условие, которому должно удовлетворять значение, вводимое в таблицу,  прежде чем оно будет принято.
    Department VARCHAR(16) CHECK ( Department in ('Production', 'Support', 'Accounting', 'Administration')),
    City VARCHAR(32),
    PRIMARY KEY (Login)
    --The PRIMARY KEY constraint uniquely identifies each record in a table. Primary keys must contain UNIQUE values, and cannot contain NULL values
);

create table Projects(
    ProjectName VARCHAR(32),
    Description TEXT,
    StartDate DATE NOT NULL ,
    EndDate DATE,
    PRIMARY KEY (ProjectName)
);

create table Tasks(
    Project VARCHAR(32),
    Header varchar NOT NULL ,
    Priority INT NOT NULL ,
    Description TEXT,
    Status VARCHAR(32) CHECK ( Status in ('New', 'Reopened', 'Doing', 'Closed')) NOT NULL ,
    --int is a data type, but integer is a group of data types – e.g. int , long , short and byte
    Assessment INTEGER,
    SpentTime INTEGER,
    Creator VARCHAR(32),
    WhoIsDoing VARCHAR(32),
    -- id. В PostgreSQL имеется особый тип для таких номеров — SERIAL.
    TaskID SERIAL,
    StartDate DATE,
    Deadline DATE,
    --A FOREIGN KEY is a key used to link two tables together.
    FOREIGN KEY (Project) REFERENCES Projects(ProjectName),
    FOREIGN KEY (Creator) REFERENCES Users(Login),
    FOREIGN KEY (WhoIsDoing) REFERENCES Users(Login),
    PRIMARY KEY (TaskID)
);

--1-2
INSERT INTO Users(Surname,Name, Login, Email, Department, City)
VALUES ('Касаткин','Артём','A.Kasatkin', 'a.kasatkin@gamil.com', 'Administration', NULL),
       ('Петрова', 'София', 'S.Petrova','s.petrova@gmail.com','Accounting', NULL),
       ('Дроздов', 'Федр', 'F.Drozdov','f.drozdov@birds.ru','Production', 'Moscow'),
       ('Иванова', 'Василиса', 'V.Ivanova','v.ivanova@yandex.ru','Accounting', NULL),
       ('Беркут', 'Алексей', 'A.Berkut','a.berkut@berkut.com','Administration','Vladivostok'),
       ('Белова', 'Вера', 'V.Belova','v.belova@gmail.com','Production', 'Moscow'),
       ('Макенрой', 'Алексей', 'A.Makenroi','a.makenroi@yandex.ru','Support','Novosibirsk');

INSERT INTO Projects(ProjectName, StartDate, EndDate)
VALUES ('РТК','2016/01/31',NULL),
       ('СС.Коннект', '2015/02/23','2016/12/31'),
       ('Демо-Сибирь','2015/05/11','2015/01/31'),
       ('МВД-Онлайн','2015/05/22','2016/01/31'),
       ('Поддержка','2016/06/07',NULL);

INSERT INTO Tasks(Project, TaskID, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('РТК', 10020, 'СРОЧНО',1,'New','A.Berkut','V.Belova','2016/03/01','2016/03/04',72, 24),
       ('Демо-Сибирь', 1123, 'Тестирование',51,'Reopened','A.Kasatkin',NULL,'2016/07/28','2016/08/28', 165 , 135),
       ('Поддержка', 11111, 'Очередной вопрос Иванова', 88,'Doing','A.Makenroi','A.Kasatkin','2016/01/01',NULL, 48, NULL),
       ('МВД-Онлайн',3456 ,'Нужна еще гос субсидия', 15 ,'Closed','V.Ivanova','A.Berkut','2016/05/13','2016/11/11', 300 , 125),
       ('СС.Коннект', 2237, 'Digital Реклама',66 ,'New','V.Belova','A.Kasatkin','2016/01/03','2016/01/15', 100,50),
       ('Поддержка', 11112, 'ДА ОТВЕТЬТЕ ВЫ ИВАНОВУ', 12 ,'New','A.Makenroi','V.Ivanova','2016/01/18','2016/01/19', 24, NULL),
       ('МВД-Онлайн', 3477, 'Отправить отчет', 8,'Closed','A.Berkut','A.Kasatkin','2016/08/09','2016/08/12', 96 , 58),
       ('РТК',10345 ,'Бухгалтерии', 53,'Doing','S.Petrova','V.Ivanova','2015/04/03',NULL , 70, 12),
       ('Демо-Сибирь', 22309, 'Командировка Беркуту', 18,'Reopened','A.Makenroi','A.Berkut','2016/10/11','2016/10/16', 50, NULL),
       ('Поддержка', 34445, 'Новую фичу хочется...', 36,'Doing','A.Berkut','F.Drozdov','2016/05/05','2016/06/12',400 ,132),
       ('СС.Коннект', 11232, 'БАГ НА ПРОДЕ', 1,'New','V.Belova','A.Kasatkin','2016/01/02','2016/01/02', 24, 11),
       ('Демо-Сибирь', 300303, 'А зарплата когда?', 56,'Closed','A.Berkut','S.Petrova','2016/09/01', NUll, 35, 4),
       ('МВД-Онлайн',12887 , 'Сходите кто-нибудь настройте компы', 33,'Reopened','F.Drozdov',NULL,NULL,'2016/12/12', 200, NULL),
       ('РТК',26748 ,'Подготовить смету на конференцию', 23 ,'Doing','V.Ivanova','S.Petrova','2016/04/23','2016/04/30', 145, 69),
       ('СС.Коннект', 19490,'Хотим еще сервер', 20,'New','A.Berkut','A.Berkut','2016/10/12','2016/12/31', 500 ,432),
       ('Поддержка', 12, 'Дайте надбавку за возню с Ивановым..', 66,'Closed','V.Belova','S.Petrova','2016/02/20','2016/02/27',70 ,19),
       ('РТК', 3499,'Надо отметить запуск приложения',1 ,'New','F.Drozdov','A.Berkut',NULL,NULL,NULL,NULL),
       ('Демо-Сибирь', 389, 'Забыл сказать, у нас завтра встреча с ними',1,'New','F.Drozdov', NULL, '2016/01/02', '2016/01/03', 24, NULL );
--1-3a
SELECT *
FROM Tasks;

TABLE Tasks;

--1-3b
SELECT Name,Department
FROM Users;

--1-3c
SELECT Login,Email
FROM Users;

--1-3d
SELECT *
FROM Tasks
Where Priority>50;

--1-3e
SELECT DISTINCT WhoIsDoing
--оманда DISTINCT позволяет выбирать только уникальные значения из базы данных,отсеивает дубли
FROM Tasks
WHERE WhoIsDoing IS NOT NULL;

--1-3f
SELECT Creator
FROM Tasks
UNION
SELECT WhoIsDoing
From Tasks;

--1-3k
SELECT *
FROM Tasks
Where (Creator != 'S.Petrova')
    AND (WhoIsDoing IN('V.Ivanova','F.Drozdov','A.Berkut'));

--1-4
SELECT *
FROM Tasks
WHERE (WhoIsDoing = 'A.Kasatkin')
    AND (StartDate BETWEEN '2016/01/01' AND '2016/01/03');

--1-5
SELECT t.TaskID, t.Header, U.department
FROM Tasks t,
     Users U
WHERE t.WhoIsDoing = 'S.Petrova'
  AND t.creator = U.login
  AND U.department IN ('Production', 'Accounting', 'Administration');

--1-6-2
SELECT Header
FROM Tasks
Where WhoIsDoing is NULL;

--1-6-3
UPDATE Tasks
Set WhoIsDoing = 'S.Petrova'
where WhoIsDoing is NULL;

--1-7
DROP TABLE IF EXISTS Tasks2;

CREATE TABLE tasks2 AS
SELECT *
FROM Tasks;

--1-8
SELECT *
FROM users
WHERE Name NOT LIKE '%а'
    AND Surname NOT LIKE '%а'
    AND Login LIKE '%r%'
    AND Login LIKE 'F%';









