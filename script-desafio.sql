create table tb_aluno(
    id bigint primary key auto_increment,
    nome varchar(30),
    email varchar(30) UNIQUE,
    idade tinyint
);

create table tb_avaliacao(
    id bigint primary key auto_increment,
    titulo varchar(500),
    descricao varchar(4000)
);

create table tb_cognitive(
    id bigint primary key auto_increment,
    resposta text,
    fk_avaliacao_id bigint,
    fk_aluno_id bigint,
    foreign key (fk_avaliacao_id) references tb_avaliacao(id),
    foreign key (fk_aluno_id) references tb_aluno(id)
);

create table tb_auto_avaliacao(
	id bigint primary key auto_increment,
    nota tinyint,
    fk_cognitive bigint,
	foreign key (fk_cognitive) references tb_cognitive(id)
);


insert tb_aluno (nome, email, idade) values
('naruto', 'naruto@gmail.com', 18),
('sasuke', 'sasuke@gmail.com', 18),
('hinata', 'hinata@gmail.com', 18),
('sakura', 'sakura@gmail.com', 18);

select * from tb_aluno;

insert tb_avaliacao(titulo, descricao) values
 ('criar uma api rest', 'passo1: ..., passo2: ..., passo3:....'),
('criar um schema de banco de dados', 'passo1: ..., passo2: ..., passo3:....'),
('criar uma api rest com kotlin ', 'passo1: ..., passo2: ..., passo3:....'),
('criar uma api com micronaut', 'passo1: ..., passo2: ..., passo3:....'),
('criar uma imagem docker', 'passo1: ..., passo2: ..., passo3:....'),
('criar uma api com elixir', 'passo1: ..., passo2: ..., passo3:....');




insert tb_cognitive(resposta, fk_avaliacao_id, fk_aluno_id) values
("blablabla", 1, 4),
("blablabla", 2, 4),
("blablabla", 3, 4),
("blablabla", 4, 4),
("blablabla", 4, 4),
("blablabla", 5, 4);


insert tb_auto_avaliacao(nota, fk_cognitive) values
(7, 1),
(10, 2),
(8, 3),
(7, 8);

/*Precisamos saber todo mundo que respondeu uma avaliação com um título específico?*/
select distinct A.nome, C.titulo
from tb_avaliacao C
inner join tb_cognitive B on B.fk_avaliacao_id = C.id
inner join tb_aluno A on A.id = B.fk_aluno_id
where C.titulo = "criar uma api rest"
group by A.nome;

select distinct A.nome, C.titulo
from tb_avaliacao C
inner join tb_cognitive B on B.fk_avaliacao_id = C.id
inner join tb_aluno A on A.id = B.fk_aluno_id
where C.titulo = "criar um schema de banco de dados"
group by A.nome;

select A.nome, C.titulo
from tb_avaliacao C
inner join tb_cognitive B on B.fk_avaliacao_id = C.id
inner join tb_aluno A on A.id = B.fk_aluno_id
group by A.nome, C.titulo
order by A.nome desc;


/*Precisamos saber quantas respostas foram dadas por avaliação*/
select C.titulo, COUNT(B.resposta)
from tb_avaliacao C
inner join tb_cognitive B on B.fk_avaliacao_id = C.id
group by C.titulo;


/*Precisamos da nota média da autocorreção por avaliação*/
select  C.titulo, Round(AVG(D.nota),2) as MEDIA
from tb_cognitive B
inner join tb_avaliacao C on C.id = B.fk_avaliacao_id
inner join tb_auto_avaliacao D on D.fk_cognitive = B.id
group by C.titulo;

SELECT C.titulo, Round(AVG(A.nota),2) AS MEDIA
FROM tb_auto_avaliacao A
INNER JOIN tb_cognitive B ON B.id = A.fk_cognitive
INNER JOIN tb_avaliacao C ON C.id = B.fk_avaliacao_id
group by C.titulo;


select * from tb_aluno;
select * from tb_avaliacao;
select * from tb_cognitive where fk_avaliacao_id = 1;
select distinct * from tb_auto_avaliacao;
select distinct Round(AVG(nota),2) from tb_auto_avaliacao where fk_cognitive = 1;
select nota, fk_cognitive from tb_auto_avaliacao;
