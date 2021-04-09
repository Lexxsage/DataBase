--4-1
CREATE TABLE task4_1
(
    id INT,
    a_text VARCHAR(10)
);

CREATE TABLE task4_2
(
    id INT,
    b_text VARCHAR(100)
);

INSERT INTO task4_1 (id, a_text)
VALUES (1, 'java'),
       (2, 'kotlin');

INSERT INTO task4_2 (id, b_text)
VALUES (1, 'python'),
       (3, 'cpp'),
       (1, 'c');

SELECT *
FROM task4_1
         FULL OUTER JOIN task4_2 ON task4_1.id =task4_2.id
WHERE task4_1.id IS NULL
   OR task4_2.id IS NULL;

SELECT *
FROM task4_1
         FULL OUTER JOIN task4_2 ON task4_1.id =task4_2.id;

SELECT *
FROM task4_1
         INNER JOIN task4_2 ON task4_1.id =task4_2.id;

SELECT *
FROM task4_1
         LEFT JOIN task4_2 ON task4_1.id =task4_2.id;

SELECT *
FROM task4_1
         LEFT JOIN task4_2 ON task4_1.id =task4_2.id
WHERE task4_2.id IS NULL;

SELECT *
FROM task4_1
         RIGHT JOIN task4_2 ON task4_1.id =task4_2.id;

SELECT *
FROM task4_1
         RIGHT JOIN task4_2 ON task4_1.id =task4_2.id
WHERE task4_1.id IS NULL;

------- ver2
drop view if exists viewOne, viewTwo;

create view viewOne as select taskid, header, priority from tasks where priority >= 50;

create view viewTwo as select taskid, header, assessment from tasks where  assessment > 60;


select viewOne.taskid, viewOne.header, viewOne.priority, viewTwo.assessment from viewOne inner join viewTwo on viewOne.taskid = viewTwo.taskid;

select * from viewOne full outer join viewTwo on viewOne.taskid = viewTwo.taskid;

select * from viewOne full outer join viewTwo on viewOne.taskid = viewTwo.taskid where viewOne.taskid is null or viewTwo.taskid is null;

select * from viewOne left join viewTwo using (taskid, header);

select * from viewOne left join viewTwo using (taskid, header) where viewOne.taskid is null;

select * from viewOne right join viewTwo using (taskid, header);

select * from viewOne right join viewTwo using (taskid, header) where viewOne.taskid is null;

--4-2
select taskid, header, priority, creator from tasks as out
	where priority = (select max(priority) from tasks as inr where inr.creator = out.creator);

select t.taskid, t.header, t.priority, t.creator from tasks t right outer join
    (select t2.creator, max(t2.priority) priority from tasks t2 group by t2.creator) as t2 using (priority, creator);

--4-3
select login from users
	where exists (select * from tasks where tasks.whoisdoing = users.login and priority > 50);


select distinct tasks.whoisdoing from users, tasks
	where users.login = tasks.whoisdoing and tasks.priority > 50;


select distinct  users.login from users
	inner join (select whoisdoing from tasks where priority > 50) as wsd on wsd.whoisdoing = users.login;

--4-4
(select creator a, whoisdoing b from tasks where creator > whoisdoing) union
	(select whoisdoing a, creator b from tasks where creator < whoisdoing) union
    (select whoisdoing a, creator b from tasks where creator = whoisdoing);

--4-5
--synonym?
select t.header, p.projectName from tasks as t, projects as p;