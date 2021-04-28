--5-1
drop table if exists account;

create table account(
    id int PRIMARY KEY,
    name varchar,
    amount int
);

insert into account(id, amount,name)
values (1, 200, 'Alice'),
       (2, 300, 'Bob'),
       (3, 230, 'Alex');
--Th1
--Намерены перевести 100 рублей с первого счета на второй. Для этого она сначала уменьшает первый счет:
BEGIN;
UPDATE account SET amount = amount - 100.00 WHERE id = 1;

--Th2
--одновременно 2 транзакция хочет перевести 10 рублей со второго счета на первый. Она начинает с того, что уменьшает второй счет:
BEGIN;
UPDATE account SET amount = amount - 10.00 WHERE id = 2;

--Th1
--Теперь первая транзакция пытается увеличить второй счет, но обнаруживает, что строка заблокирована.
UPDATE account SET amount = amount + 100.00 WHERE id = 2;

--Th2
--Затем в
-- торая транзакция пытается увеличить первый счет, но тоже блокируется.
UPDATE account SET amount = amount + 10.00 WHERE id = 1;
--DEADLOCK

--5-2
--транзакция
create or replace function transaction()
returns int
language plpgsql as
$$
BEGIN;
UPDATE account SET amount = amount - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE account SET amount = amount + 100.00
    WHERE name = 'Bob';
-- ошибочное действие, нвдо было Alex. забыть Bob и использовать счёт Alex
ROLLBACK TO my_savepoint;
UPDATE account SET amount = amount + 100.00
    WHERE name = 'Alex';
COMMIT;
return 1;
EXCEPTION
    WHEN OTHERS THEN RETURN 0;
end $$;

begin transaction;
UPDATE account SET amount = amount - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE account SET amount = amount + 100.00
    WHERE name = 'Bob';
-- ошибочное действие, нвдо было Alex. забыть Bob и использовать счёт Alex
ROLLBACK TO my_savepoint;
UPDATE account SET amount = amount + 100.00
    WHERE name = 'Alex';
commit;
end;
--зацикливание
CREATE FUNCTION scan_rows(int[]) RETURNS void AS $$
DECLARE
  x int[];
BEGIN
  FOREACH x SLICE 1 IN ARRAY $1
  LOOP
    RAISE NOTICE 'row = %', x;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT scan_rows(ARRAY[[1,2,3],[4,5,6],[7,8,9],[10,11,12]]);

--рекурсия
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
CREATE TABLE IF NOT EXISTS orders
(
    id serial primary key,
    event VARCHAR(30),
    time  TIMESTAMP not null
);

INSERT INTO orders(event, time)
VALUES ('some1', '2021-04-18 13:23:01'),
       ('some2', '2021-04-18 15:12:56'),
       ('any1', '2021-04-19 18:56:18'),
       ('any2', '2021-04-20 4:23:37'),
       ('tk1', '2021-04-020 10:45:31'),
       ('tk1_2', '2021-04-21 17:24:23'),
       ('tk2', '2021-04-21 19:09:20');


create or replace function find_dates(in dateone timestamp, in datetwo timestamp)
returns setof date
language plpgsql
as $$
    declare
	    time timestamp;
	begin
		for time in select orders.time from orders where orders.time between dateone and datetwo
	    loop
			return next time;
		end loop;
	return;
end $$;

select find_dates('2021-04-19', '2021-04-21');