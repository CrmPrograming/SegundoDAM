-- ###################################

--		     BD FUTBOL

-- ###################################

-- autor: C�sar Ravelo Mart�nez
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
--				  1 s� compite en competiciones internacionales
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


-- Inserci�n de datos iniciales
INSERT INTO ligas VALUES ('PRIMM', 'Primera divisi�n masculina'),
						 ('SEGDM', 'Segunda divisi�n masculina')
GO

INSERT INTO equipos VALUES ('Deportivo Alav�s', 'PRIMM', 'Vitoria', 0),
						   ('Athletic Club', 'PRIMM', 'Bilbao', 0),
						   ('Club Atl�tico de Madrid', 'PRIMM', 'Madrid', 1),
						   ('F�tbol Club Barcelona', 'PRIMM', 'Barcelona', 1),
						   ('Real Betis Balompi�', 'PRIMM', 'Sevilla', 0),
						   ('C�diz Club de F�tbol', 'PRIMM', 'C�diz', 0),
						   ('Real Madrid Club de F�tbol', 'PRIMM', 'Madrid', 1),
						   ('Valencia Club de F�tbol', 'PRIMM', 'Valencia', 1),
						   ('Real Sociedad de F�tbol', 'PRIMM', 'San Sebasti�n', 0),
						   ('Villareal Club de F�tbol', 'PRIMM', 'Villareal', 0)
GO

INSERT INTO fubtbolistas VALUES ('12345678A', 'Cristiano Ronaldo', 'Portugal'),
								('90123456B', 'Ra�l Gonz�lez', 'Espa�a'),
								('67890123C', 'Alfredo Di St�fano', 'Espa�a'),
								('45678901D', 'Carlos Alonso Santillana', 'Espa�a'),
								('23456789E', 'Karim Benzema', 'Francia'),
								('01234567F', 'Lionel Messi', 'Argentina'),
								('89012345G', 'Luis Su�rez', 'Uruguay'),
								('67890123H', 'Xavi Hern�ndez', 'Espa�a'),
								('45678901I', 'Andr�s Iniesta', 'Espa�a'),
								('23456789J', 'Carles Puyol', 'Espa�a'),
								('01234567K', 'Ger�nimo Rulli', 'Argentina'),
								('89012345L', 'Pervis Estupi��n', 'Ecuador'),
								('67890123M', 'Takefusa Kubo', 'Jap�n'),
								('45678901N', 'Carlos Bacca', 'Colombia'),
								('23456789O', 'Paco Alc�cer', 'Espa�a')
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