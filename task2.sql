--2.1
--avg - находит среднее значение
--сначала фильтруем - получаем тот набор кортежей, с которыми будем работать дальше.
--Затем группируем в нужном разрезе.
SELECT tasks.whoisdoing, AVG(tasks.priority) AS avg_priority FROM tasks
GROUP BY tasks.whoisdoing ORDER BY AVG(tasks.priority) DESC LIMIT 3;

--2.2
INSERT INTO Tasks(Project, TaskID, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('РТК', 5680, 'СРОЧНО',55,'New','A.Berkut','V.Belova','2015/03/01','2015/03/04',72, 24),
       ('МВД-Онлайн',36 ,'Нужна еще гос субсидия', 15 ,'Closed','V.Ivanova','A.Berkut','2015/05/13','2016/11/11', 300 , 125);

DROP VIEW  IF EXISTS  CMID;

CREATE VIEW	CMID AS
	SELECT creator, date_part('month', startdate) as month, date_part('year', startdate) as year
	FROM tasks;

SELECT count(creator), month, creator FROM CMID
	WHERE (year = 2015) GROUP BY month, creator;

--2.3
INSERT INTO Tasks(Project, TaskID, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('РТК', 5, 'СРОЧНО',55,'New','A.Berkut','V.Belova','2015/03/01','2015/03/04',24, 72),
       ('МВД-Онлайн',23,'task', 15 ,'Closed','V.Ivanova','A.Berkut','2015/05/13','2016/11/11', 50 , 245),
       ('МВД-Онлайн',13,'task', 15 ,'Closed','A.Berkut','V.Belova','2015/05/13','2016/11/11', 39 , 55);

UPDATE Tasks
Set WhoIsDoing = 'S.Petrova'
where WhoIsDoing is NULL;

INSERT INTO Tasks(Project, TaskID, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('МВД-Онлайн',14,'task', 15 ,'Closed','A.Berkut','A.Kasatkin','2015/05/13','2016/11/11', 39 , 55);

--вложенный
select whoisdoing,
(select sum(assessment - spenttime) from tasks inrmore
	where (assessment - spenttime) > 0 and inrmore.whoisdoing = task.whoisdoing group by inrmore.whoisdoing) as spend_less,
(select -1*sum(assessment - spenttime) from tasks inrless
	where (assessment - spenttime) < 0 and inrless.whoisdoing = task.whoisdoing group by inrless.whoisdoing) as spend_more
from tasks task group by task.whoisdoing;

--без вложения
select whoisdoing,
(sum(assessment - spenttime) + sum(abs(assessment - spenttime)))/2 as spendless,
(sum(spenttime- assessment) + sum(abs(spenttime - assessment)))/2 as spendmore
from tasks group by whoisdoing;

--2.4
--SELECT creator, whoisdoing
--FROM tasks
--GROUP BY creator, whoisdoing;

(select creator cr, whoisdoing wsd from tasks where creator > whoisdoing) union
(select creator cr,  whoisdoing  wsd from tasks where creator < whoisdoing) union
(select creator cr, whoisdoing wsd from tasks where creator = whoisdoing);

--2.5
SELECT login, length(login) FROM users WHERE
length(login) = (SELECT max(length(login)) FROM users);

--2.6
-- pg_column_size(column) - Число байт, необходимых для хранения заданного значения
DROP TABLE IF EXISTS Ch, VCh;
CREATE TABLE VCh
(
  str VARCHAR(30)
);

CREATE TABLE Ch
(
  str CHAR(30)
);
INSERT INTO Ch VALUES ('task2');
INSERT INTO VCh VALUES ('task2');

SELECT pg_column_size(Ch.str) as ch, pg_column_size(VCh.str) as vch
FROM Ch,
     VCh;

--2.7
SELECT login, max(priority)
FROM users,
     tasks
WHERE tasks.whoisdoing = users.login
GROUP BY login;
--group by whoisdoing - лишняя работа, тк уже сделали where

--2.8
UPDATE Tasks
Set assessment= 26
where assessment is NULL;

SELECT whoisdoing, sum(assessment)
FROM tasks
WHERE (assessment >= (SELECT avg(assessment) FROM tasks)) AND (status != 'Closed')
GROUP BY whoisdoing;

SELECT whoisdoing, sum(assessment)
    FROM tasks
	GROUP BY whoisdoing, assessment, status
    HAVING (assessment >= (SELECT avg(assessment) FROM tasks) AND (status != 'Closed'));
--do with having

--2.9

INSERT INTO Tasks(Project, TaskID, Header, Priority, Status,Creator, WhoIsDoing, StartDate, Deadline, Assessment,SpentTime)
VALUES ('РТК', 34, 'СРОЧНО',55,'New','A.Berkut','V.Belova','2015/03/01','2015/03/04',24,null ),
       ('МВД-Онлайн',28,'task', 15 ,'Closed','V.Ivanova','A.Berkut','2015/05/13','2016/11/11', 50 ,null),
       ('МВД-Онлайн',19,'task', 15 ,'Closed','A.Berkut','V.Belova','2015/05/13','2016/11/11', 39 ,null);

DROP VIEW IF EXISTS task9;
create view task9 as
select t9.whoisdoing,
       -- всего задач у каждого
       count(t9.taskid) as all_tasks,

       -- задачи в срок
	(select count(ontime.taskid) from
		(select taskid, whoisdoing from tasks where (assessment - spenttime) > 0)
		as ontime where ontime.whoisdoing = t9.whoisdoing group by ontime.whoisdoing) as on_time,

--задач задержано
	(select count(late.taskid) from
		(select taskid, whoisdoing from tasks where (assessment - spenttime) < 0)
		as late where late.whoisdoing = t9.whoisdoing group by late.whoisdoing) as later,

--нет итогового времени выполнения - мое 1
	(select count(notfinised.taskid) from
		(select taskid, whoisdoing from tasks where spenttime is null)
		as notfinised where notfinised.whoisdoing = t9.whoisdoing group by notfinised.whoisdoing) as not_finised,

-- открыто задач
	(select count(opened.taskid) from
		(select taskid, whoisdoing from tasks where status in ('Reopened', 'New'))
		as opened where opened.whoisdoing = t9.whoisdoing group by opened.whoisdoing) as opened,

-- закрыто задач
	(select count(closed.taskid) from
		(select taskid, whoisdoing from tasks where status = 'Closed')
		as closed where closed.whoisdoing = t9.whoisdoing group by closed.whoisdoing) as closed,

--выполняется задач
	(select count(perf.taskid) from
		(select taskid, whoisdoing from tasks where status = 'Doing')
		as perf where perf.whoisdoing= t9.whoisdoing group by perf.whoisdoing) as performed,

       --суммарное потраченное время
	(select sum(spend.spenttime) from
		(select spenttime, whoisdoing from tasks)
		as spend where spend.whoisdoing = t9.whoisdoing group by spend.whoisdoing) as spended,

       --переработка
	(select sum(spend_more.dif) from
		(select -1*(assessment - spenttime) as dif, whoisdoing from tasks where (assessment- spenttime) < 0)
		as spend_more where spend_more.whoisdoing = t9.whoisdoing group by spend_more.whoisdoing) as hours_over,


--недоработка
	(select sum(spend_less.dif) from
		(select (assessment - spenttime) as dif, whoisdoing from tasks where (assessment- spenttime) > 0)
		as spend_less where spend_less.whoisdoing = t9.whoisdoing group by spend_less.whoisdoing) as hours_less,

-- придумать еще 2-3 самой
-- наименьшие приорирет 2
    (select min(min_priority.priority) from
     (select priority, whoisdoing from tasks)
    as min_priority where min_priority.whoisdoing = t9.whoisdoing group by min_priority.whoisdoing) as min_priority,

--средний приоритет 3
	(select avg(pr.priority) from
		(select priority, t9.whoisdoing from tasks)
		as pr where pr.whoisdoing = t9.whoisdoing group by pr.whoisdoing) as avg_priority,

-- max приорирет 4
    (select max(max_priority.priority) from
     (select priority, whoisdoing from tasks)
    as max_priority where max_priority.whoisdoing = t9.whoisdoing group by max_priority.whoisdoing) as max_priority,

--среднее время выполнения 5
	(select avg(avg_spent.spenttime) from
		(select spenttime,  whoisdoing from tasks where spenttime is not null)
		as avg_spent where avg_spent.whoisdoing = t9.whoisdoing group by avg_spent.whoisdoing) as avg_time

from tasks t9 group by t9.whoisdoing;


--2.10
-- простое объединение
select tasks.header, users.login
from tasks, users
where users.login = tasks.whoisdoing;

-- вложенный подзапрос
select a.header, b.login from
	(select header, whoisdoing from tasks) as a, (select login from users) as b
	where a.whoisdoing = b.login;

-- соотнесенный подзапрос
select tasks.header,
       (select users.login from users where tasks.whoisdoing = users.login)
from tasks;
--tasks.whoisdoing = 'yy' - не соотнесенный запрос
