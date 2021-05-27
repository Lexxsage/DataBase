DROP TABLE IF EXISTS _Users, _Tasks, _Projects, history CASCADE;

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

drop table if exists history cascade;

CREATE TABLE history
(
    histoperation char(1) not null,
    stamp timestamp not null,
    myuser varchar not null,
    task_id integer not null,
    priority integer not null,
    assessment integer not null,
    SpentTime integer not null,
    description text,
    whoisdoing varchar ,
    creator varchar,
    header varchar(255) not null,
    project varchar,
    status VARCHAR(255) not null,
    start_data date NOT NULL,
    deadline date,
    primary key(stamp, task_id)
);

-------------
--UPDATE HISTORY
drop function if exists update_history();
create or replace function update_history()
returns trigger as $thistory$
begin
if (TG_OP = 'UPDATE') then
insert into history select 'U', now(), user, old.taskid , old.priority, old.assessment, old.SpentTime , old.description, old.whoisdoing , old.Creator, old.Header, old.Project, old.Status, old.StartDate, old.Deadline;
elsif (TG_OP = 'DELETE') then
insert into history select 'D', now(), user, old.taskid , old.priority, old.assessment, old.SpentTime , old.description, old.whoisdoing , old.Creator, old.Header, old.Project, old.Status, old.StartDate, old.Deadline;
end if;
return null;
end;
$thistory$
language plpgsql;

create trigger thistory
after UPDATE or DELETE on _Tasks
for each row execute procedure update_history();

update _tasks
set priority = 14
where header = 'Тестирование';

--CHECK OF UPDATE HISTORY
drop function if exists view_update_history();
create or replace function view_update_history()
returns table(operation char, hstamp timestamp, hmyuser text, htask_id integer, hpriority integer , hassessment integer, hSpentTime integer, hdescription text, hwhoisdoing varchar, hcreator varchar, hheader varchar(255), hproject varchar, hstatus VARCHAR(255), hstart_data date)
as
$$
begin
return query select histoperation ,stamp, myuser, task_id , priority , assessment , SpentTime , description , whoisdoing , creator , header , project, status , start_data from history as h where h.histoperation = 'U';
return;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

select operation , hstamp, hmyuser, htask_id , hpriority , hassessment , hSpentTime , hdescription , hwhoisdoing , hcreator , hheader , hproject, hstatus , hstart_data
 from view_update_history();

--CHECK OF TASK UPDATE HISTORY
create or replace function view_update_history(task integer)
returns table(operation char, stamp timestamp, myuser text, task_id integer, priority integer , valuation integer, expenses integer, description text, polzdo_id integer, polzcreator_id integer, header varchar(255), project_id integer, state VARCHAR(255), start_data date)
as
$$
begin
return query select * from history as h where h.histoperation = 'U' and h.task_id=task;
if not found then
raise exception 'Task did not update: %.', $1;
end if;
return;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

select * from view_update_history();

--ROLLBACK ON UPDATED TASK
create or replace function rollback_task(task int, t timestamp)
returns integer
as
$$
begin
update tasks set (priority, assessment, spenttime, description, whoisdoing , creator, header, project, status, startdate) = (select h.priority, h.assessment, h.SpentTime, h.description, h.whoisdoing, h.creator, h.header, h.project, h.status, h.start_data from history as h where h.stamp=t and h.task_id=task) where taskid=task;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

--DELETE OF TASKS========
create or replace function delete_task(task int)
returns integer
as
$$
begin
if (task>(select max(taskid) from tasks)) then
raise exception 'Task does not exist: %.', $1;
else
delete from tasks where taskid=task;
end if;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

--HISTORY OF DELETED TASKS
create or replace function view_delete_history()
returns table(operation char, stamp timestamp, myuser text, task_id integer, priority integer , valuation integer, expenses integer, description text, polzdo_id integer, polzcreator_id integer, header varchar(255), project_id integer, state VARCHAR(255), start_data date)
as
$$
begin
return query select * from history as h where h.histoperation = 'D';
return;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

--ROLLBACK ON DELETED TASK========

create or replace function rollback_deleted_task(task int)
returns integer
as
$$
begin
if (task in (select task_id from view_delete_history())) then
insert into tasks (priority, assessment, SpentTime, description, whoisdoing, creator, header, project, status, startdate) select h.priority, h.assessment, h.SpentTime, h.description, h.whoisdoing, h.creator, h.header, h.project, h.status, h.start_data from history as h where h.task_id=task and h.histoperation='D';
delete from history where task_id=task and histoperation='D';
else
raise exception 'This task was not deleted: %.', $1;
end if;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

