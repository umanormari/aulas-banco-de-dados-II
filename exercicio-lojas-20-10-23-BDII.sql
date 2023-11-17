-- Database: Lojas
-- DROP DATABASE IF EXISTS "Lojas";

CREATE DATABASE "Lojas"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
		
CREATE TABLE vouchers(
	codigo SERIAL UNIQUE PRIMARY KEY,
	desconto REAL
)

CREATE TABLE itens(
	codigo SERIAL PRIMARY KEY,
	nome VARCHAR,
	valor REAL
)

CREATE TABLE pedidos(
	codigo SERIAL PRIMARY KEY,
	cod_cli INT,
	cod_item INT,
	valor REAL,
	FOREIGN KEY(cod_item) REFERENCES itens(codigo)
)

CREATE TABLE clientes (
	codigo SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	telefone INT,
	cod_vch INT,
	FOREIGN KEY(cod_vch) REFERENCES vouchers(codigo)
)

ALTER TABLE pedidos
ADD CONSTRAINT fk_cod_cli
FOREIGN KEY(cod_cli) REFERENCES clientes(codigo)
ON DELETE SET NULL

/*VOUCHER*/
INSERT INTO vouchers(desconto)
VALUES  (100.00)

/*ITENS*/
INSERT INTO itens(nome, valor)
VALUES	('Chapéu', 50.00),
		('Luva', 20.00),
		('Camisa', 60.00),
		('Calça', 100.00),
		('Tenis', 150.00)

/*CLIENTES SEM VOUCHER*/
INSERT INTO clientes(nome, telefone)
VALUES  ('Ana', 1111),
		('Beth', 2222),
		('Carol', 3333),
		('Diana', 4444),
		('Elen', 5555)

/*PEDIDOS*/
INSERT INTO pedidos(cod_cli, cod_item, valor)
VALUES	(5, 1, 700.00),
		(4, 2, 350.00),
		(3, 3, 350.00),
		(2, 4, 350.00),
		(1, 5, 350.00)

SELECT * FROM vouchers 
SELECT * FROM itens
SELECT * FROM clientes
SELECT * FROM pedidos

/*EXERCICIO: Fazer com que cada cliente só possa usar o voucher 1x */
CREATE TABLE vouchers_usados (
  cod_cli INT,
  cod_vch INT,
  PRIMARY KEY (cod_cli, cod_vch),
  FOREIGN KEY (cod_cli) REFERENCES clientes(codigo),
  FOREIGN KEY (cod_vch) REFERENCES vouchers(codigo)
);

/*Primeira tentativa*/
INSERT INTO vouchers_usados (cod_cli, cod_vch)
VALUES (5, 1);

/*Segunda tentativa*/
INSERT INTO vouchers_usados (cod_cli, cod_vch)
VALUES (5, 1);
/*Se tentar usar o voucher 2x, como tentei usar para aplicara o voucher na cliente Elen, o programa acusa error*/
SELECT * FROM vouchers_usados