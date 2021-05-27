DROP TABLE IF EXISTS files, nodes CASCADE;

CREATE TABLE nodes
(
    id   SERIAL NOT NULL PRIMARY KEY,
    path VARCHAR(100)
);

CREATE TABLE files
(
    id       SERIAL  NOT NULL PRIMARY KEY,
    name     VARCHAR NOT NULL,
    size     INT     NOT NULL,
    create_data  DATE    NOT NULL,
    record_data  DATE    NOT NULL,
    modified_data DATE,
    path_id  INT     NOT NULL,
    FOREIGN KEY (path_id) REFERENCES nodes (id) on delete cascade on update cascade
);

insert into nodes(path)
values ('one'),
       ('two');

insert into files(name, path_id, size, create_data, record_data, modified_data)
VALUES ('file1', 1,  1000, '2021-04-20', '2021-04-21' ,null),
       ('file2', 2, 1000, '2021-04-21', '2021-04-21',null),
       ('file3', 1, 1000 ,'2021-04-26', '2021-04-27' ,null);

--functions
--new
CREATE OR REPLACE FUNCTION add_new(fname varchar(255), fpath_id integer, fsize integer, fcreate date)
returns integer
as $$
begin
INSERT INTO files (name, path_id, size, create_data, record_data, modified_data) VALUES (fname, fpath_id, fsize, fcreate, now()::date, now()::date);
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;
--EXAMPLE:
select add_new('G',2,202,'2021-01-05');  --good one
select add_new(NULL,2,202,'2021-01-05'); --bad one

--delete
CREATE OR REPLACE FUNCTION delete(fname varchar(255))
returns integer
as $$
begin
delete from files where name=fname;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;
--EXAMPLE:
select delete('G'); --good one
select delete(5); --bad one

--change name
CREATE OR REPLACE FUNCTION change_name(fname_new varchar(255), fname_old varchar(255))
returns integer
as $$
begin
if exists(select * from files where name=fname_old) then
update files set name=fname_new, modified_data=now()::date where name=fname_old;
return 0;
else
return 1;
end if;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;
--EXAMPLE:
select change_name('newfile','file1');

--copy
CREATE OR REPLACE FUNCTION copy(fname varchar(255), path_new integer, path_old integer)
returns integer
as $$
begin
if exists(select * from files where path_id=path_old and name=fname) then
insert into files(name, path_id, size, create_data, record_data, modified_data) select a.name, a.path_id, a.size, a.create_data, a.record_data, a.modified_data from files as a where name=fname;
if path_new !=path_old then
update files set path_id=path_new where id=(select max(id) from files);
end if;
else
return 1;
end if;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;

--EXAMPLE:
select copy('file2',1,2);

--move
CREATE OR REPLACE FUNCTION move(new_path_id integer, fname varchar(255), old_path_id integer)
returns integer
as $$
begin
if new_path_id != old_path_id and exists(select * from files where name=fname and path_id=old_path_id) then
update files set path_id=new_path_id, modified_data=now()::date where name=fname and path_id=old_path_id;
else
return 1;
end if;
return 0;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;
--EXAMPLE:
insert into files(name, path_id, size, create_data, record_data, modified_data)
values ('H', 2, 1000, '2021-04-21', '2021-04-21',null);
select move(1,'H',2);

--find
CREATE OR REPLACE FUNCTION find(mymask text, mypath integer, deep integer)
returns table(rid int, rname varchar, rpath_id int)
as $$
begin
if mypath!=deep then
return query select id, name, path_id from files where name ~ mymask;
else
return query select id, name, path_id from files where name ~ mymask and path_id=mypath;
end if;
exception
when others THEN
raise notice 'SQLTATE: %', SQLSTATE;
raise notice 'iIllegal operation: %', SQLERRM;
end;
$$
language plpgsql;
--like '%oo%'
--EXAMPLE:
--когда 2 и 3 аргумент одинаковый - ищем в одном folder, если разные во всей file storage
select find('file',1,2);