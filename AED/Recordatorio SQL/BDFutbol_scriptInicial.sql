-- ###################################

--		     BD FUTBOL

-- ###################################

-- autor: César Ravelo Martínez
-- fecha: 22/09/2020


IF DB_ID('bdFutbol') IS NOT NULL
	BEGIN
		DROP DATABASE bdFutbol
	END
GO

CREATE DATABASE bdFutbol
GO

USE bdFutbol
GO

-- Tabla Ligas
IF OBJECT_ID ('dbo.ligas') IS NOT NULL
	BEGIN
		DROP TABLE dbo.ligas
	END
GO

CREATE TABLE ligas (codLiga CHAR(5) CONSTRAINT pk_codLiga PRIMARY KEY,
					nomLiga VARCHAR(50))
GO

-- Tabla Equipos
-- internacional: 0 no compite en competiciones internacionales,
--				  1 sí compite en competiciones internacionales
IF OBJECT_ID ('dbo.equipos') IS NOT NULL
	BEGIN
		DROP TABLE dbo.equipos
	END
GO

CREATE TABLE equipos (codEquipo INTEGER IDENTITY(1, 1) CONSTRAINT pk_codEquipo PRIMARY KEY,
					  nomEquipo VARCHAR(40),
					  codLiga CHAR(5) CONSTRAINT fk_codLiga FOREIGN KEY REFERENCES ligas(codLiga) CONSTRAINT df_codLiga DEFAULT('PDN'),
					  localidad VARCHAR(60),
					  internacional BIT CONSTRAINT df_internacional DEFAULT(0)
					  )
GO

-- Tabla fubtbolistas
IF OBJECT_ID ('dbo.fubtbolistas') IS NOT NULL
	BEGIN
		DROP TABLE dbo.fubtbolistas
	END
GO

CREATE TABLE fubtbolistas (coddnionie CHAR(9) CONSTRAINT pk_coddnionie PRIMARY KEY,
						   nombre VARCHAR(50),
						   nacionalidad VARCHAR(40))
GO

-- Tabla contratos
IF OBJECT_ID ('dbo.contratos') IS NOT NULL
	BEGIN
		DROP TABLE dbo.contratos
	END
GO

CREATE TABLE contratos (codcontrato INTEGER IDENTITY(1, 1) CONSTRAINT pk_codcontrato PRIMARY KEY,
						coddnionie CHAR(9) CONSTRAINT fk_coddnionie FOREIGN KEY REFERENCES fubtbolistas(coddnionie),
						codEquipo INTEGER CONSTRAINT fk_codEquipo FOREIGN KEY REFERENCES equipos(codEquipo),
						fechaInicio DATE,
						fechaFin DATE,
						precioanual INTEGER,
						preciorecision INTEGER)
GO


-- Inserción de datos iniciales
INSERT INTO ligas VALUES ('PRIMM', 'Primera división masculina'),
						 ('SEGDM', 'Segunda división masculina')
GO

INSERT INTO equipos VALUES ('Deportivo Alavés', 'PRIMM', 'Vitoria', 0),
						   ('Athletic Club', 'PRIMM', 'Bilbao', 0),
						   ('Club Atlético de Madrid', 'PRIMM', 'Madrid', 1),
						   ('Fútbol Club Barcelona', 'PRIMM', 'Barcelona', 1),
						   ('Real Betis Balompié', 'PRIMM', 'Sevilla', 0),
						   ('Cádiz Club de Fútbol', 'PRIMM', 'Cádiz', 0),
						   ('Real Madrid Club de Fútbol', 'PRIMM', 'Madrid', 1),
						   ('Valencia Club de Fútbol', 'PRIMM', 'Valencia', 1),
						   ('Real Sociedad de Fútbol', 'PRIMM', 'San Sebastián', 0),
						   ('Villareal Club de Fútbol', 'PRIMM', 'Villareal', 0)
GO

INSERT INTO fubtbolistas VALUES ('12345678A', 'Cristiano Ronaldo', 'Portugal'),
								('90123456B', 'Raúl González', 'España'),
								('67890123C', 'Alfredo Di Stéfano', 'España'),
								('45678901D', 'Carlos Alonso Santillana', 'España'),
								('23456789E', 'Karim Benzema', 'Francia'),
								('01234567F', 'Lionel Messi', 'Argentina'),
								('89012345G', 'Luis Suárez', 'Uruguay'),
								('67890123H', 'Xavi Hernández', 'España'),
								('45678901I', 'Andrés Iniesta', 'España'),
								('23456789J', 'Carles Puyol', 'España'),
								('01234567K', 'Gerónimo Rulli', 'Argentina'),
								('89012345L', 'Pervis Estupiñán', 'Ecuador'),
								('67890123M', 'Takefusa Kubo', 'Japón'),
								('45678901N', 'Carlos Bacca', 'Colombia'),
								('23456789O', 'Paco Alcácer', 'España')
GO

INSERT INTO contratos VALUES ('12345678A', 7, '2020/09/22', '2025/10/12', 150000, 200000),
							 ('12345678A', 7, '2025/11/10', '2028/10/26', 167000, 230000),
							 ('90123456B', 7, '2017/11/10', '2025/10/12', 155000, 7341240),
							 ('67890123C', 2, '2017/11/10', '2020/09/22', 155000, 7341240),
							 ('45678901D', 1, '2017/01/05', '2020/09/22', 155000, 5637200),
							 ('45678901D', 2, '2020/09/22', '2024/04/15', 165000, 5637200),
							 ('45678901I', 4, '2010/07/26', '2020/09/22', 185000, 7652100),
							 ('23456789J', 4, '2010/07/26', '2020/09/22', 193000, 6652100),
							 ('23456789O', 10, '2010/07/26', '2020/09/22', 185000, 7652100),
							 ('23456789O', 10, '2020/09/22', '2023/11/26', 185000, 7775600)
GO