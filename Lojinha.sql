-- Database: Lojinha
-- DROP DATABASE IF EXISTS "Lojinha";

CREATE DATABASE "Lojinha"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
CREATE TABLE Clientes (
	Cod_cli SERIAL Primary Key,
	Nome VARCHAR(255),
	Telefone INT
)
	
CREATE TABLE Pedidos (
	Cod_ped SERIAL Primary Key,
	Data_Compra DATE,
	Valor REAL,
	Cod_cli INT
)
	
CREATE TABLE Itens (
	Cod_it INT,
	Qtd INT,
	Total REAL,
	Cod_ped INT
)

INSERT INTO Clientes (Cod_cli, Nome, Telefone)
VALUES (233, 'Luis', 222),
 		(240, 'Alberto', 333),
 		(250, 'Abelardo', 444)
		
INSERT INTO Pedidos (Cod_ped, Data_Compra, Valor, Cod_cli)
VALUES (1010, '2023/09/19', 700, 233),
 		(1020, '2023/09/20', 350, 240)
		
INSERT INTO Itens (Cod_it, Qtd, Total, Cod_ped)
VALUES (004, 2, 350, 1010),
 		(005, 2, 350, 1010),
		(004, 2, 350, 1020)

SELECT * FROM Clientes, Pedidos

SELECT Clientes.Nome, Clientes.Telefone
FROM Pedidos INNER JOIN Clientes
	  ON Clientes.Cod_cli = Pedidos.Cod_cli
WHERE Pedidos.Cod_ped = 1010
