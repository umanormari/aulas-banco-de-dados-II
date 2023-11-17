-- Database: auditoria_trigger

-- DROP DATABASE IF EXISTS auditoria_trigger;

CREATE DATABASE auditoria_trigger
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
CREATE TABLE clientes (
	codigo SERIAL,
	nome VARCHAR,
	telefone INT,
	limite_compra REAL,
	PRIMARY KEy(codigo)
);
  
CREATE TABLE pedido (
	codigo SERIAL,
	cod_cli INT,
	data_pedido DATE,
	valor REAL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(cod_cli) REFERENCES clientes(codigo) ON DELETE SET NULL
);

CREATE TABLE itens (
	codigo SERIAL,
	cod_ped INT,
	qtd INT,
	subtotal REAL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(cod_ped) REFERENCES pedido(codigo) ON DELETE SET NULL
);

SELECT * FROM clientes
SELECT * FROM pedido
SELECT * FROM itens

/* Criando tabela de auditoria dos clientes e função trigger*/
CREATE TABLE clientes_audit (
    operacao VARCHAR NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    user_id VARCHAR NOT NULL,
    codigo INT,
    nome VARCHAR,
    telefone INT,
    limite_compra REAL
);

CREATE OR REPLACE FUNCTION clientes_audit_data() RETURNS TRIGGER  
AS  
$clientes_audit$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO clientes_audit SELECT 'D', NOW(), USER, OLD.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO clientes_audit SELECT 'U', NOW(), USER, NEW.*;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO clientes_audit SELECT 'I', NOW(), USER, NEW.*;
    END IF;
    RETURN NULL;
END;
$clientes_audit$ 
LANGUAGE plpgsql;

CREATE TRIGGER clientes_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON clientes
FOR EACH ROW 
EXECUTE FUNCTION clientes_audit_data();

/* Criando tabela de auditoria dos pedidos e função trigger*/
CREATE TABLE pedido_audit (
	operacao VARCHAR NOT NULL,
	data_hora TIMESTAMP NOT NULL,
	user_id VARCHAR NOT NULL,
	codigo INT,
	cod_cli INT,
	data_pedido DATE,
	valor REAL
);

create or replace function pedido_audit_data() returns trigger  
                 as  
                 $pedido_audit$
                 begin
                 if (TG_OP = 'DELETE') THEN
                 	insert into pedido_audit SELECT 'D', now(), user, OLD.*;
                 elsif (TG_OP = 'UPDATE') THEN
                 	insert into pedido_audit SELECT 'U', now(), user, NEW.*;
                 elsif (TG_OP = 'INSERT') THEN
                 	insert into pedido_audit SELECT 'I', now(), user, NEW.*;
                 end if;
                 return null;
                 end;
                 $pedido_audit$ 
                 language plpgsql;

create trigger pedido_audit_trigger
                  after insert or update or delete on pedido
                  for each row 
                  execute procedure pedido_audit_data();
				  
/* Criando tabela de auditoria dos itens e função trigger*/
CREATE TABLE itens_audit (
    operacao VARCHAR NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    user_id VARCHAR NOT NULL,
    codigo INT,
    cod_ped INT,
    qtd INT,
    subtotal REAL
);

CREATE OR REPLACE FUNCTION itens_audit_data() RETURNS TRIGGER  
AS  
$itens_audit$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO itens_audit SELECT 'D', NOW(), USER, OLD.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO itens_audit SELECT 'U', NOW(), USER, NEW.*;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO itens_audit SELECT 'I', NOW(), USER, NEW.*;
    END IF;
    RETURN NULL;
END;
$itens_audit$ 
LANGUAGE plpgsql;

CREATE TRIGGER itens_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON itens
FOR EACH ROW 
EXECUTE FUNCTION itens_audit_data();




/* Atualizando informações nas tabelas*/
INSERT INTO clientes (codigo, nome, telefone, limite_compra)
VALUES (1, 'Mariana', 0012345678, 50),
		(2, 'Abner', 0023456789, 25),
		(3, 'Wandinha', 0034567891, 10)
		
INSERT INTO pedido (codigo, cod_cli, data_pedido, valor)
VALUES (1, 1, '05/10/2023', 2000),
		(2, 1, '06/10/2023', 1000),
		(3, 2, '07/10/2023', 200),
		(4, 2, '08/10/2023', 100), 
		(5, 3, '09/10/2023', 20),
		(6, 3, '10/10/2023', 10)
		
INSERT INTO itens (codigo, cod_ped, qtd, subtotal)
VALUES  (1, 1, 2, 500.00),
				(2, 1, 2, 300.00),
				(3, 2, 3, 200.00),
				(4, 2, 1, 150.00),
				(5, 3, 1, 50.00),
				(6, 3, 1, 50.00),
				(7, 4, 2, 300.00),
				(8, 4, 1, 50.00),
				(9, 5, 2, 180.00),
				(10, 5, 1, 120.00),
				(11, 6, 3, 250.00),
				(12, 6, 1, 120.00)

UPDATE pedido
SET data_pedido = '11/10/2023'
WHERE codigo = 4;

UPDATE pedido
SET data_pedido = '05/05/2023'
WHERE codigo = 2;

DELETE FROM pedido
WHERE cod_cli = 2;

SELECT * FROM clientes_audit
SELECT * FROM pedido_audit
SELECT * FROM itens_audit