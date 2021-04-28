DROP TABLE IF EXISTS _Users, _Tasks, _Projects CASCADE;

CREATE TABLE _Users
(
    Name VARCHAR(32) NOT NULL,
    Surname varchar(32) NOT NULL ,
    Login VARCHAR(32),
    Email VARCHAR(32),
    Department VARCHAR(16) CHECK ( Department in ('Production', 'Support', 'Accounting', 'Administration')),
    City VARCHAR(32),
    PRIMARY KEY (Login)
);

create table _Projects(
    ProjectName VARCHAR(32),
    Description TEXT,
    StartDate DATE NOT NULL ,
    EndDate DATE,
    PRIMARY KEY (ProjectName)
);

create table _Tasks(
    Project VARCHAR(32),
    Header varchar NOT NULL ,
    Priority INT NOT NULL ,
    Description TEXT,
    Status VARCHAR(32) CHECK ( Status in ('New', 'Reopened', 'Doing', 'Closed')) NOT NULL ,
    Assessment INTEGER,
    SpentTime INTEGER,
    Creator VARCHAR(32),
    WhoIsDoing VARCHAR(32),
    TaskID SERIAL,
    StartDate DATE,
    Deadline DATE,
    FOREIGN KEY (Project) REFERENCES Projects(ProjectName),
    FOREIGN KEY (Creator) REFERENCES Users(Login),
    FOREIGN KEY (WhoIsDoing) REFERENCES Users(Login),
    PRIMARY KEY (TaskID)
);

INSERT INTO _Users(Surname,Name, Login, Email, Department, City)
VALUES ('Касаткин','Артём','A.Kasatkin', 'a.kasatkin@gamil.com', 'Administration', NULL),
       ('Петрова', 'София', 'S.Petrova','s.petrova@gmail.com','Accounting', NULL),
       ('Дроздов', 'Федр', 'F.Drozdov','f.drozdov@birds.ru','Production', 'Moscow'),
       ('Иванова', 'Василиса', 'V.Ivanova','v.ivanova@yandex.ru','Accounting', NULL),
       ('Беркут', 'Алексей', 'A.Berkut','a.berkut@berkut.com','Administration','Vladivostok'),
       ('Белова', 'Вера', 'V.Belova','v.belova@gmail.com','Production', 'Moscow'),
       ('Макенрой', 'Алексей', 'A.Makenroi','a.makenroi@yandex.ru','Support','Novosibirsk');

INSERT INTO _Projects(ProjectName, StartDate, EndDate)
VALUES ('РТК','2016/01/31',NULL),
       ('СС.Коннект', '2015/02/23','2016/12/31'),
       ('Демо-Сибирь','2015/05/11','2015/01/31'),
       ('МВД-Онлайн','2015/05/22','2016/01/31'),
       ('Поддержка','2016/06/07',NULL);

INSERT INTO _Tasks(Project, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('РТК', 'СРОЧНО',1,'New','A.Berkut','V.Belova','2016/03/01','2016/03/04',72, 24),
       ('Демо-Сибирь',  'Тестирование',51,'Reopened','A.Kasatkin',NULL,'2016/07/28','2016/08/28', 165 , 135),
       ('Поддержка', 'Очередной вопрос Иванова', 88,'Doing','A.Makenroi','A.Kasatkin','2016/01/01',NULL, 48, NULL),
       ('МВД-Онлайн','Нужна еще гос субсидия', 15 ,'Closed','V.Ivanova','A.Berkut','2016/05/13','2016/11/11', 300 , 125),
       ('СС.Коннект', 'Digital Реклама',66 ,'New','V.Belova','A.Kasatkin','2016/01/03','2016/01/15', 100,50),
       ('Поддержка', 'ДА ОТВЕТЬТЕ ВЫ ИВАНОВУ', 12 ,'New','A.Makenroi','V.Ivanova','2016/01/18','2016/01/19', 24, NULL),
       ('МВД-Онлайн','Отправить отчет', 8,'Closed','A.Berkut','A.Kasatkin','2016/08/09','2016/08/12', 96 , 58),
       ('РТК','Бухгалтерии', 53,'Doing','S.Petrova','V.Ivanova','2015/04/03',NULL , 70, 12),
       ('Демо-Сибирь', 'Командировка Беркуту', 18,'Reopened','A.Makenroi','A.Berkut','2016/10/11','2016/10/16', 50, NULL),
       ('Поддержка', 'Новую фичу хочется...', 36,'Doing','A.Berkut','F.Drozdov','2016/05/05','2016/06/12',400 ,132),
       ('СС.Коннект', 'БАГ НА ПРОДЕ', 1,'New','V.Belova','A.Kasatkin','2016/01/02','2016/01/02', 24, 11),
       ('Демо-Сибирь', 'А зарплата когда?', 56,'Closed','A.Berkut','S.Petrova','2016/09/01', NUll, 35, 4),
       ('МВД-Онлайн', 'Сходите кто-нибудь настройте компы', 33,'Reopened','F.Drozdov',NULL,NULL,'2016/12/12', 200, NULL),
       ('РТК', 'Подготовить смету на конференцию', 23 ,'Doing','V.Ivanova','S.Petrova','2016/04/23','2016/04/30', 145, 69),
       ('СС.Коннект','Хотим еще сервер', 20,'New','A.Berkut','A.Berkut','2016/10/12','2016/12/31', 500 ,432),
       ('Поддержка','Дайте надбавку за возню с Ивановым..', 66,'Closed','V.Belova','S.Petrova','2016/02/20','2016/02/27',70 ,19),
       ('РТК','Надо отметить запуск приложения',1 ,'New','F.Drozdov','A.Berkut',NULL,NULL,NULL,NULL),
       ('Демо-Сибирь','Забыл сказать, у нас завтра встреча с ними',1,'New','F.Drozdov', NULL, '2016/01/02', '2016/01/03', 24, NULL );

select * from _Tasks;

DROP TABLE IF EXISTS TasksHistory CASCADE;

CREATE TABLE TasksHistory (
    Project VARCHAR(32),
    Header varchar NOT NULL ,
    Priority INT NOT NULL ,
    Description TEXT,
    Status VARCHAR(32) CHECK ( Status in ('New', 'Reopened', 'Doing', 'Closed')) NOT NULL ,
    Assessment INTEGER,
    SpentTime INTEGER,
    Creator VARCHAR(32),
    WhoIsDoing VARCHAR(32),
    TaskID SERIAL,
    StartDate DATE,
    Deadline DATE,
)

