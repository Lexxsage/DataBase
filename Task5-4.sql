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
    path     VARCHAR NOT NULL,
    size     INT     NOT NULL,
    created  DATE    NOT NULL,
    written  DATE    NOT NULL,
    modified DATE,
    node_id  INT     NOT NULL,
    FOREIGN KEY (node_id) REFERENCES nodes (id) on delete cascade on update cascade
);

insert into nodes(path)
values ('one'),
       ('two');

insert into files(name,node_id, path, size, created, written, modified)
VALUES ('file1', 1, '/', 1000, '2021-04-20', '2021-04-21' ,null),
       ('dir1', 2, '/', 1000, '2021-04-19', '2021-04-20', '2021-04-21'),
       ('file2', 2, '/dir1', 1000, '2021-04-21', '2021-04-21',null),
       ('dir2', 2, '/dir1', 1000 ,'2021-04-25', '2021-04-26' ,null),
       ('dir3', 1, '/', 1000 ,'2021-04-26', '2021-04-27' ,null);

--functions
--new file

