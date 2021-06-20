  
  SELECT EMBALAGEM, TAMANHO FROM tabela_de_produtos;
  
  /* Distinct */
  SELECT DISTINCT EMBALAGEM, TAMANHO, SABOR FROM tabela_de_produtos;
  
  SELECT * FROM tabela_de_produtos LIMIT 5;
  
  SELECT * FROM tabela_de_produtos LIMIT 2,3;
  
  /* Order by */
  SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA;
  
  SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA DESC;
  
  SELECT * FROM tabela_de_produtos ORDER BY NOME_DO_PRODUTO;
  
  SELECT * FROM tabela_de_produtos ORDER BY EMBALAGEM DESC, NOME_DO_PRODUTO ASC;
  
  /* Group by */
  SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS LIMITE_TOTAL FROM tabela_de_clientes GROUP BY ESTADO;
  
  SELECT EMBALAGEM, MAX(PRECO_LISTA) AS MAIOR_PRECO FROM tbproduto GROUP BY EMBALAGEM;
  
  SELECT EMBALAGEM, COUNT(*) AS CONTADOR FROM tbproduto GROUP BY EMBALAGEM;
  
  SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes GROUP BY ESTADO, BAIRRO;
  
/* Group by com order by */
SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes
WHERE CIDADE = 'Rio de Janeiro'
GROUP BY ESTADO, BAIRRO
ORDER BY BAIRRO;
  
SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS SOMA_LIMITE FROM tabela_de_clientes
GROUP BY ESTADO;

/* Having */
SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS SOMA_LIMITE FROM tabela_de_clientes
GROUP BY ESTADO HAVING SUM(LIMITE_DE_CREDITO) > 900000;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO,
MIN(PRECO_DE_LISTA) AS MENOR_PRECO FROM tabela_de_produtos
GROUP BY EMBALAGEM HAVING SUM(PRECO_DE_LISTA) <= 80;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO,
MIN(PRECO_DE_LISTA) AS MENOR_PRECO FROM tabela_de_produtos
GROUP BY EMBALAGEM HAVING SUM(PRECO_DE_LISTA) <= 80 AND MAX(PRECO_DE_LISTA) >= 5;

/* Não precisa do Having nesse caso*/
SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO,
MIN(PRECO_DE_LISTA) AS MENOR_PRECO FROM tabela_de_produtos
GROUP BY EMBALAGEM;
  
SELECT CPF, COUNT(*) FROM notas_fiscais
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY CPF
HAVING COUNT(*) > 2000;
 
/* CASE */
SELECT nome, preco_lista,
case
  when preco_lista >=12 then 'PRODUTO CARO'
  when preco_lista >= 7 and preco_lista < 12 then 'PRODUTO EM CONTA'
else 'PRODUTO BARATO'
end as STATUS_PRECO
from tbproduto;

/* CASE com GROUPBY e mais um CASE */
SELECT EMBALAGEM,
CASE 
   WHEN preco_lista >= 12 THEN 'PRODUTO CARO'
   WHEN preco_lista >= 7 AND preco_lista < 12 THEN 'PRODUTO EM CONTA'
   ELSE 'PRODUTO BARATO' 
END AS STATUS_PRECO, AVG(preco_lista) AS PRECO_MEDIO
FROM tbproduto
WHERE sabor = 'Manga'
GROUP BY EMBALAGEM, 
CASE 
   WHEN preco_lista >= 12 THEN 'PRODUTO CARO'
   WHEN preco_lista >= 7 AND preco_lista < 12 THEN 'PRODUTO EM CONTA'
   ELSE 'PRODUTO BARATO' 
END 
ORDER BY EMBALAGEM;

select nome, idade,
case
	when year(data_nascimento) < 1990 then 'VELHO'
    when year(data_nascimento) between 1990 and 1995 then 'JOVENS'
else 'CRIANÇAS' end as 'CLASSIFICAÇÃO'
from tbcliente;

/* inner join */
SELECT * FROM tabela_de_vendedores A
INNER JOIN notas_fiscais B
ON A.MATRICULA = B.MATRICULA;

SELECT A.MATRICULA, A.NOME, COUNT(*) FROM
tabela_de_vendedores A
INNER JOIN notas_fiscais B
ON A.MATRICULA = B.MATRICULA
GROUP BY A.MATRICULA, A.NOME;

/* FATURAMENTO ANUAL */
SELECT YEAR(DATA_VENDA), SUM(QUANTIDADE * PRECO) AS FATURAMENTO
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
ON NF.NUMERO = INF.NUMERO
GROUP BY YEAR(DATA_VENDA);

/*  SELECT COM HAVING*/
SELECT CPF, COUNT(*) FROM notas_fiscais
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY CPF
HAVING COUNT(*) > 2000;

/*  MESMO SELECT COM WHERE */
SELECT X.CPF, X.CONTADOR FROM 
(SELECT CPF, COUNT(*) AS CONTADOR FROM notas_fiscais
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY CPF) X WHERE X.CONTADOR > 2000;

/*Podemos aplicar agrupamentos ao resultado da consulta que conecta uma ou mais tabelas:*/
SELECT A.MATRICULA, A.NOME, COUNT(*) FROM
tabela_de_vendedores A
INNER JOIN notas_fiscais B
ON A.MATRICULA = B.MATRICULA
GROUP BY A.MATRICULA, A.NOME;

SELECT COUNT(*) FROM tabela_de_clientes;

/* LEFT JOIN */
SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A
LEFT JOIN notas_fiscais B ON A.CPF = B.CPF;

 /* Podemos simular o FULL JOIN, que não é suportado pelo MYSQL, usando o LEFT JOIN e RIGHT JOIN com UNION. Digite:*/
SELECT tabela_de_vendedores.BAIRRO,
tabela_de_vendedores.NOME, DE_FERIAS,
tabela_de_clientes.BAIRRO,
tabela_de_clientes.NOME  FROM tabela_de_vendedores LEFT JOIN tabela_de_clientes
ON tabela_de_vendedores.BAIRRO = tabela_de_clientes.BAIRRO
UNION
SELECT tabela_de_vendedores.BAIRRO,
tabela_de_vendedores.NOME, DE_FERIAS,
tabela_de_clientes.BAIRRO,
tabela_de_clientes.NOME  FROM tabela_de_vendedores RIGHT JOIN tabela_de_clientes
ON tabela_de_vendedores.BAIRRO = tabela_de_clientes.BAIRRO;

/* As sub-consultas permitem que possa ser feita seleções usando como critérios outras seleções*/
SELECT * FROM tabela_de_clientes WHERE BAIRRO 
IN (SELECT DISTINCT BAIRRO FROM tabela_de_vendedores);

/* Podemos aplicar uma consulta, em vez de sobre uma tabela, sobre outra consulta.*/
SELECT X.EMBALAGEM, X.PRECO_MAXIMO FROM 
(SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAXIMO FROM tabela_de_produtos
GROUP BY EMBALAGEM) X WHERE X.PRECO_MAXIMO >= 10;

/* criar uma view */
CREATE VIEW `VW_MAIORES_EMBALAGENS` AS
SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAXIMO FROM tabela_de_produtos
GROUP BY EMBALAGEM;

SELECT * FROM VW_MAIORES_EMBALAGENS;

/* A consulta: */
SELECT X.EMBALAGEM, X.PRECO_MAXIMO FROM 
(SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAXIMO FROM tabela_de_produtos
GROUP BY EMBALAGEM) X WHERE X.PRECO_MAXIMO >= 10;

/* Pode ser substituída por: */
SELECT X.EMBALAGEM, X.PRECO_MAXIMO FROM 
VW_MAIORES_EMBALAGENS X WHERE X.PRECO_MAXIMO >= 10;

/* CONCAT */
SELECT NOME, CONCAT(ENDERECO_1, BAIRRO, ',  ', CIDADE, '-', ESTADO) AS ENDERECO
FROM tabela_de_clientes;

SELECT NOME, ENDERECO_1, BAIRRO, CIDADE, ESTADO
FROM tabela_de_clientes;

SELECT CURDATE();

SELECT CURRENT_DATE();

SELECT current_timestamp();

SELECT DAY(current_timestamp()) AS DIA;

SELECT YEAR(current_timestamp()) AS ANO;

SELECT MONTH(current_timestamp()) AS MES;

SELECT MONTHNAME(current_timestamp()) AS MES;

/* QUANTOS DIAS JÁ VIVI */
SELECT DATEDIFF(CURRENT_TIMESTAMP(), '1994-02-14');

SELECT DISTINCT DATA_VENDA,
DAYNAME(DATA_VENDA) AS DIA, 
MONTHNAME(DATA_VENDA) AS MES,
YEAR(DATA_VENDA) AS ANO FROM notas_fiscais;

/*IDADE CLIENTES*/
SELECT NOME, TIMESTAMPDIFF (YEAR, DATA_DE_NASCIMENTO, CURDATE()) AS IDADE
FROM tabela_de_clientes;

/*Na tabela de notas fiscais temos o valor do imposto. Já na tabela de itens temos a quantidade e o faturamento. Calcule o valor do imposto pago no ano de 2016 arredondando para o menor inteiro.*/
SELECT YEAR(DATA_VENDA), FLOOR(SUM(IMPOSTO * (QUANTIDADE * PRECO)))
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY YEAR(DATA_VENDA);

/* TRIM */
SELECT LTRIM('    OLÁ') AS RESULTADO;

SELECT RTRIM('OLÁ     ') AS RESULTADO;

SELECT TRIM('    OLÁ    ') AS RESULTADO;

/* CONCAT */
SELECT CONCAT('OLÁ', ' ', 'TUDO BEM','?') AS RESULTADO;

/* CASE UPPER E LOWER */
SELECT UPPER('olá, tudo bem?') AS RESULTADO;

SELECT LOWER('OLÁ, TUDO BEM?') AS RESULTADO;

/* SUBSTRING */
SELECT SUBSTRING('OLÁ, TUDO BEM?', 6) AS RESULTADO;

SELECT SUBSTRING('OLÁ, TUDO BEM?', 6, 4) AS RESULTADO;

/* CONCAT */
SELECT CONCAT(NOME, ' (', CPF, ') ') AS RESULTADO FROM tabela_de_clientes;

/* DATE */ 
SELECT CURDATE();

SELECT CURRENT_TIME();

SELECT CURRENT_TIME();

SELECT CURRENT_TIMESTAMP() AS DIA_HOJE
, DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 DAY) AS RESULTADO;

SELECT DISTINCT DATA_VENDA,
DAYNAME(DATA_VENDA) AS DIA, MONTHNAME(DATA_VENDA) AS MES
, YEAR(DATA_VENDA) AS ANO FROM notas_fiscais;

SELECT (23+((25-2)/2)*45) AS RESULTADO;

SELECT CEILING(12.33333232323) AS RESULTADO;

SELECT ROUND(12.7777232323) AS RESULTADO;

SELECT FLOOR(12.7777232323) AS RESULTADO;

SELECT RAND() AS RESULTADO;

SELECT NUMERO, QUANTIDADE, PRECO, QUANTIDADE * PRECO AS FATURAMENTO
FROM itens_notas_fiscais;

 SELECT NUMERO, QUANTIDADE, PRECO, ROUND(QUANTIDADE * PRECO, 2) AS FATURAMENTO
 FROM itens_notas_fiscais;
 
 SELECT CURRENT_TIMESTAMP() AS RESULTADO;
 
 SELECT CONCAT('O dia de hoje é : ', CURRENT_TIMESTAMP()) AS RESULTADO;
 
 SELECT CONCAT('O dia de hoje é : ',

DATE_FORMAT(CURRENT_TIMESTAMP(),'%W, %d/%m/%Y - %U') ) AS RESULTADO;

SELECT SUBSTRING(CONVERT(23.3, CHAR),1,1) AS RESULTADO;


/* Relatório vendas validas 2016 */
SELECT X.CPF, X.NOME, X.MES_ANO, X.QUANTIDADE_VENDAS, X.QUANTIDADE_LIMITE,
CASE WHEN (X.QUANTIDADE_LIMITE - X.QUANTIDADE_VENDAS) < 0 THEN 'INVÁLIDA'
ELSE 'VÁLIDA' END AS STATUS_VENDA, (1 - (X.QUANTIDADE_LIMITE/X.QUANTIDADE_VENDAS)) * 100 AS PERCENTUAL
FROM (SELECT NF.CPF, TC.NOME, DATE_FORMAT(NF.DATA_VENDA, '%Y-%m') AS MES_ANO
, SUM(INF.QUANTIDADE) AS QUANTIDADE_VENDAS 
, MAX(TC.VOLUME_DE_COMPRA) AS QUANTIDADE_LIMITE FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
ON NF.NUMERO = INF.NUMERO
INNER JOIN tabela_de_clientes TC 
ON TC.CPF = NF.CPF
GROUP BY NF.CPF, TC.NOME, DATE_FORMAT(NF.DATA_VENDA, '%Y-%m')) X
WHERE (X.QUANTIDADE_LIMITE - X.QUANTIDADE_VENDAS) < 0;

/* Relatório acompanhamento vendas 2016 */
SELECT * FROM 
tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO;

SELECT TP.SABOR, NF.DATA_VENDA, INF.QUANTIDADE FROM 
tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO;

/*RELATÓRIO QUANTIDADE VENDIDA POR SABORES ANO 2016 */
SELECT TP.SABOR, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE
FROM tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY TP.SABOR, YEAR(NF.DATA_VENDA)
ORDER BY SUM(INF.QUANTIDADE) DESC;

SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE
FROM tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
ORDER BY SUM(INF.QUANTIDADE) DESC;

SELECT VENDA_SABOR.SABOR, VENDA_SABOR.ANO, VENDA_SABOR.QUANTIDADE,
ROUND((VENDA_SABOR.QUANTIDADE/VENDA_TOTAL.QUANTIDADE) * 100, 2) AS PARTICIPACAO FROM
(SELECT TP.SABOR, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE FROM
tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY TP.SABOR, YEAR(NF.DATA_VENDA)) AS VENDA_SABOR
INNER JOIN
(SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE FROM
tabela_de_produtos TP
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY YEAR(NF.DATA_VENDA)) AS VENDA_TOTAL
ON VENDA_SABOR.ANO = VENDA_TOTAL.ANO
ORDER BY VENDA_SABOR.QUANTIDADE DESC;


/*RELATÓRIO RANK VENDAS POR TAMANHO */
SELECT VENDA_TAMANHO.TAMANHO, VENDA_TAMANHO.ANO, VENDA_TAMANHO.QUANTIDADE,
ROUND((VENDA_TAMANHO.QUANTIDADE/VENDA_TOTAL.QUANTIDADE) * 100, 2) AS PARTICIPACAO FROM 
(SELECT TP.TAMANHO, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE FROM 
tabela_de_produtos TP 
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY TP.TAMANHO, YEAR(NF.DATA_VENDA)) AS VENDA_TAMANHO
INNER JOIN 
(SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE FROM 
tabela_de_produtos TP 
INNER JOIN itens_notas_fiscais INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN notas_fiscais NF ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY YEAR(NF.DATA_VENDA)) AS VENDA_TOTAL
ON VENDA_TAMANHO.ANO = VENDA_TOTAL.ANO
ORDER BY VENDA_TAMANHO.QUANTIDADE DESC;