-- Criar banco de dados db_Biblioteca
CREATE DATABASE db_Biblioteca ON PRIMARY
(NAME = db_Biblioteca,
FILENAME = 'C:\SQL\db_Biblioteca.mdf',
SIZE = 6MB,
MAXSIZE = 15MB,
FILEGROWTH = 10%)
LOG ON (
NAME = db_biblioteca_log,
FILENAME = 'C:\SQL\db_Biblioteca_log.ldf',
SIZE = 1MB, FILEGROWTH = 1MB)
GO

--Alterar o banco de dados em uso
USE db_Biblioteca
GO

CREATE TABLE tbl_autores (
ID_Autor SMALLINT,
Nome_Autor VARCHAR(50),
Sobrenome_Autor VARCHAR(60)
CONSTRAINT pk_ID_Autor PRIMARY KEY (ID_Autor)
);

CREATE TABLE tbl_editoras (
ID_Editora SMALLINT PRIMARY KEY IDENTITY,
Nome_Editora VARCHAR(50)
);

CREATE TABLE tbl_Livro (
ID_Livro SMALLINT PRIMARY KEY IDENTITY(100,1),
Nome_Livro VARCHAR (50) NOT NULL,
ISBN VARCHAR(15) NOT NULL UNIQUE,
ID_Autor SMALLINT NOT NULL,
ID_editora SMALLINT NOT NULL,
Data_Pub DATE NOT NULL,
Preco_Livro MONEY NOT NULL
CONSTRAINT fk_ID_Autor FOREIGN KEY (ID_Autor)
	REFERENCES tbl_autores (ID_autor) ON DELETE CASCADE,
CONSTRAINT fk_id_editora FOREIGN KEY (ID_editora)
	REFERENCES tbl_editoras (ID_editora) ON DELETE CASCADE
);

CREATE TABLE tbl_logon
(
ID_user SMALLINT IDENTITY NOT NULL,
Nome_user VARCHAR(20),
Senha VARCHAR(255)
CONSTRAINT pk_id_user PRIMARY KEY (ID_user)
);

--Inserir dados na tabelas de autores
INSERT INTO tbl_autores (ID_Autor, Nome_Autor, Sobrenome_Autor)
VALUES
(1, 'Daniel', 'Barret'),
(2, 'Gerakd', 'Carter'),
(3, 'Mark', 'Sobell'),
(4, 'William', 'Stanek'),
(5, 'Richard', 'Blum'),
(6, 'Isaac', 'Asimov');

--Inserir dados na tabela de editoras
INSERT INTO tbl_editoras (Nome_Editora)
VALUES
('Prentice Hall'),
('O´Reilly'),
('Microsoft Press'),
('Wiley'),
('Aleph'),
('Ediouro');

--Inserir dados na tabela de livros:
INSERT INTO tbl_Livro
(Nome_Livro, ISBN, Data_Pub, Preco_Livro, ID_Autor, ID_Editora)
VALUES
('SSH, the Secure Shell', '127658789', '20091221', 58.30, 1, 2),
('Eu, Robô', '97885765708', '20141124', 37.90, 6, 5),
('Linux and Shell Scripting', '143856969', '20091221', 68.35, 5, 4),
('Using Samba', '123856789', '20001221', 61.45, 2, 2),
('Fedora and Red Hat Linux', '123346789', '20101101', 62.24, 3, 1),
('Windows Server 2012 Inside Out', '123356789', '20040517', 66.80, 4, 3),
('Microsoft Exchange Server 2010', '123366789', '20001221', 45.30, 4, 3);

--Fazer as Verificar das tabelas
SELECT name FROM db_Biblioteca.sys.tables;
SELECT * FROM tbl_autores;
SELECT * FROM tbl_editoras;
SELECT * FROM tbl_Livro;
SELECT * FROM tbl_logon;
--Testar o BD com uma consulta:
SELECT L.Nome_Livro AS Livro, A.Nome_Autor AS Autor,
E.Nome_Editora As Editora
FROM tbl_Livro AS L
INNER JOIN tbl_autores AS A
	ON L.ID_autor = A.ID_autor
INNER JOIN tbl_editoras AS E
	ON L.ID_editora = E.ID_editora;

-- Criar um procedomento armazenado:
CREATE OR ALTER PROCEDURE sp_consulta_preco
@ID_Livro SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Preco_Livro FROM tbl_Livro
	WHERE ID_Livro = @ID_Livro;
END;
GO

--Testar o procedimento armazenado:
sp_consulta_preco 105;