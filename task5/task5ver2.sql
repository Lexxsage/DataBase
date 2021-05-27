--5-2-1
create table task5(
    name varchar,
    count int,
    cost int
);

begin;
insert into task5 (name,count,cost) values ('new1',1,1);
SAVEPOINT my_save;
insert into task5 (name,count,cost) values ('new2',2,2);
ROLLBACK to savepoint my_save;
end;

--5-2-2
create table number
(
    id1 serial primary key
);

drop function if exists delete1();

create function delete1() returns trigger as
$$
begin
    delete from number where id1 = old.id1;
    return old;
end;
$$
    language plpgsql;

drop trigger if exists trigger1 on number;

create trigger trigger1
    before delete
    on number
    for each row
execute procedure delete1();

insert into number
values (1);

delete
from number
where id1 = 1;

select *
from number;

--5-2-3
create or replace function recursive(ct int, pr int)
returns table (counter int, product int)
language plpgsql
as $$
begin
    return query select ct, pr;
    if ct < 10 then
        return query select * from recursive(ct+ 1, pr * (ct+ 1));
    end if;
end $$;

select *  from recursive (1, 1);


--5-3
create table sales(
    id serial primary key,
    object varchar(30),
    date_of_sale date
);

insert into sales(object, date_of_sale)
VALUES ('SMTH1', '2021-01-20'),
       ('SMTH2', '2021-10-01'),
       ('SMTH3', '2021-02-13'),
       ('SMTH4', '2021-11-07'),
       ('SMTH5', '2021-06-02'),
       ('SMTH6', '2021-08-19');

insert into sales(object, date_of_sale)
VALUES ('SMTH7', '2021-11-07'),
       ('SMTH8', '2021-06-02');

create index data_index on sales (date_of_sale);

create or replace function find_dates(min date, max date)
returns setof date
as $$
declare
res date;
begin
loop
select date_of_sale into res from orders where date_of_sale>min and date_of_sale<max order by date_of_sale limit 1;
if (res is null) then
exit;
end if;
return next res;
min:=res;
end loop;
end;
$$
language plpgsql;

select find_dates('2021-04-18', '2021-08-21');
