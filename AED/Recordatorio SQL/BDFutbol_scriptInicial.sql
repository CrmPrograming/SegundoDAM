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

CREATE DATABASE bdFutbol1
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


-- ###################################

--		     PROCEDIMIENTOS

-- ###################################

-- 1. Crear un procedimiento almacenado que liste todos los contratos de cierto futbolista pasando
-- por par�metro de entrada el dni o nie del futbolista, ordenados por fecha de inicio. Los datos
-- a visualizar ser�n: C�digo de contrato, nombre de equipo, nombre de liga, fecha de inicio,
-- fecha de fin, precio anual y precio de recisi�n del contrato.

CREATE PROCEDURE dbo.listarContratoFutbolista
@coddnionie CHAR(9)
AS
	IF (SELECT COUNT(*) FROM contratos WHERE coddnionie = @coddnionie) = 0
		BEGIN
			PRINT 'No existe contratos para el jugador con el dni dado'
		END
	ELSE
		BEGIN
			SELECT codContrato, nomEquipo, nomLiga, fechaInicio, fechaFin, precioanual, preciorecision
			FROM contratos INNER JOIN equipos ON contratos.codEquipo = equipos.codEquipo
				INNER JOIN ligas ON equipos.codLiga = ligas.codLiga
			WHERE coddnionie = @coddnionie
			ORDER BY fechaInicio
		END	
GO

DECLARE @dnijugador CHAR(9)
SET @dnijugador = '45678901D'

-- Prueba con un jugador con contrato
EXEC listarContratoFutbolista @dnijugador
GO

-- Prueba con un jugador sin contrato
EXEC listarContratoFutbolista '77777777Z'
GO


-- 2. Crear un procedimiento almacenado que inserte un equipo, de modo que se le pase como par�metros
-- todos los datos. Comprobar que el c�digo de liga pasado exista en la tabla ligas. En caso de que no
-- exista la liga que no se inserte.
-- Devolver en un par�metro de salida: 0 si la liga no existe y 1 si la liga existe.
-- Devolver en otro par�metro de salida: 0 si el equipo no se insert� y 1 si la inserci�n fue correcta.

CREATE PROCEDURE dbo.insertarEquipo
@nombre VARCHAR(40), @liga CHAR(5), @localidad VARCHAR(60), @internacional BIT,
@estadoLiga BIT OUTPUT, @estadoInsercion BIT OUTPUT
AS
	SET @estadoLiga = 0
	SET @estadoInsercion = 0

	IF (SELECT COUNT(*) FROM ligas WHERE codLiga = @liga) = 1
		BEGIN
			SET @estadoLiga = 1
			-- Comprobamos si el equipo a insertar ya existe antes de almacenarlo
			IF (SELECT COUNT(*) FROM equipos WHERE nomEquipo = @nombre AND codLiga = @liga AND localidad = @localidad AND internacional = @internacional) = 0
				BEGIN
					SET @estadoInsercion = 1
					INSERT equipos VALUES (@nombre, @liga, @localidad, @internacional)
				END
		END
GO

DECLARE @eExiste INT
DECLARE @iRealizado INT

-- Insertando un equipo nuevo
EXEC insertarEquipo 'Nuevo equipo 1', 'SEGDM', 'Localidad de prueba', 1, @EExiste OUTPUT, @iRealizado OUTPUT
SELECT @eExiste [Existe Liga], @iRealizado [Insert realizado]

-- Insertando un equipo en una liga que no existe
EXEC insertarEquipo 'Nuevo equipo 1', 'FALSA', 'Localidad de prueba', 1, @eExiste OUTPUT, @iRealizado OUTPUT
SELECT @eExiste [Existe Liga], @iRealizado [Insert realizado]

-- Insertando un equipo que ya existe
EXEC insertarEquipo 'Nuevo equipo 1', 'SEGDM', 'Localidad de prueba', 1, @eExiste OUTPUT, @iRealizado OUTPUT
SELECT @eExiste [Existe Liga], @iRealizado [Insert realizado]
GO



-- 3. Crear un procedimiento almacenado que indic�ndole un equipo, precio anual y un precio recisi�n, devuelva
-- dos par�metros. En un par�metro de salida la cantidad de futbolistas en activo (con contrato vigente) que hay
-- en dicho equipo. En otro par�metro de salida la cantidad de futbolistas en activo de dicho equipo con precio
-- anual y de recisi�n menor de los indicados.

CREATE PROCEDURE dbo.futbolistasActivos
@equipo INT, @precio INT, @recision INT,
@activosEquipo INT OUTPUT, @activosPrecioAnual INT OUTPUT
AS
	IF (SELECT COUNT(*) FROM equipos WHERE codEquipo = @equipo) = 0
		BEGIN
			SET @activosEquipo = -1
			SET @activosPrecioAnual = -1
			PRINT 'No existe el equipo indicado'
		END
	ELSE
		BEGIN
			SELECT @activosEquipo = COUNT(*)
			FROM contratos
			WHERE codEquipo = @equipo AND fechaFin > GETDATE()

			SELECT @activosPrecioAnual = COUNT(*)
			FROM contratos
			WHERE codEquipo = @equipo AND fechaFin > GETDATE() AND precioanual < @precio AND preciorecision < @recision
		END
GO

DECLARE @activos INT
DECLARE @activosPrecio INT

--Prueba para equipo no existente

EXEC futbolistasActivos 77, 10000, 10000, @activos OUTPUT, @activosPrecio OUTPUT
SELECT @activos 'Total de jugadores activos en el equipo', @activosPrecio 'Total de jugadores activos con criterio dado'

-- Prueba para equipo existente

EXEC futbolistasActivos 7, 8230000, 9000000, @activos OUTPUT, @activosPrecio OUTPUT
SELECT @activos 'Total de jugadores activos en el equipo', @activosPrecio 'Total de jugadores activos con criterio dado'
GO


-- 4. Crear una funci�n que d�ndole un dni o nie de un futbolista nos devuelva en n�mero de meses total que ha estado en equipos.

CREATE FUNCTION fnTotalMeses(@dni CHAR(9))
RETURNS INT
AS
	BEGIN
		RETURN (SELECT SUM(DATEDIFF(MONTH, fechaInicio, fechaFin))
				FROM contratos 
				WHERE coddnionie = @dni
				GROUP BY coddnionie)
	END
GO

SELECT dbo.fnTotalMeses('23456789O') [Total meses]
GO



-- 5. Hacer una funci�n que devuelva los nombres de los equipos que pertenecen a una determinada liga que le pasamos el nombre
-- por par�metro de entrada, si la liga no existe deber� aparecer liga no existe.

CREATE FUNCTION fnEquiposLiga(@liga VARCHAR(50))
RETURNS @tablaResults TABLE (nombres VARCHAR(40) NOT NULL)
AS
	BEGIN
		IF (SELECT COUNT(*) FROM ligas WHERE nomLiga = @liga) = 0
			BEGIN
				INSERT @tablaResults VALUES ('Liga no existe')
			END
		ELSE
			BEGIN
				INSERT @tablaResults SELECT nomEquipo 
									 FROM equipos
									 WHERE codLiga = (SELECT codLiga FROM ligas WHERE nomLiga = @liga)
			END
		RETURN
	END
GO

-- Liga no existente
SELECT * FROM dbo.fnEquiposLiga('Liga Falsa')

-- Liga existente
SELECT * FROM dbo.fnEquiposLiga('Primera divisi�n masculina')
GO


-- 6. Hacer una funci�n en la que visualicemos los datos de los jugadores extranjeros que pertenezcan a un equipo cuyo
-- nombre pasamos por par�metro.

CREATE FUNCTION fnJugadoresExtranjeros(@equipo VARCHAR(40))
RETURNS TABLE
AS
	RETURN (SELECT *
			FROM fubtbolistas
			WHERE nacionalidad <> 'Espa�a' 
				AND coddnionie IN 
				(SELECT coddnionie 
				FROM contratos 
				WHERE codEquipo = (SELECT codEquipo
								   FROM equipos
								   WHERE nomEquipo = @equipo)))
GO

SELECT * FROM dbo.fnJugadoresExtranjeros('Real Madrid Club de F�tbol')
GO



-- 7. Hacer una funci�n que nos devuelva por cada futbolista su nombre y en cuantos equipos a tenido contrato entre
-- dos fechas determinadas.

CREATE FUNCTION fnContratosFutbolistas(@fechaInicial DATE, @fechaFinal DATE)
RETURNS @resultados TABLE (nombre VARCHAR(50), totalEquipos INT)
AS
	BEGIN
		INSERT @resultados SELECT nombre, COUNT(*)
							FROM fubtbolistas
								INNER JOIN contratos ON fubtbolistas.coddnionie = contratos.coddnionie
							WHERE fechaInicio > @fechaInicial AND fechaFin < @fechaFinal
							GROUP BY nombre
		RETURN
	END
GO

SELECT * FROM dbo.fnContratosFutbolistas('2000/01/01', '2030/12/20')
GO



-- 8. Hacer una funci�n escalar que nos devuelva el precioanual mas alto que se le ha pagado a un futbolista,
-- con el nombre de equipo y a�o pasado por par�metro.


CREATE FUNCTION fnMejorPrecioAnual(@equipo VARCHAR(40), @fecha INT)
RETURNS INT
AS
	BEGIN
		RETURN (SELECT MAX(precioanual)
				FROM contratos
				WHERE YEAR(fechaInicio) = @fecha OR YEAR(fechaFin) = @fecha 
					AND codEquipo =	(SELECT codEquipo FROM equipos WHERE nomEquipo = @equipo))
	END
GO

SELECT dbo.fnMejorPrecioAnual('F�tbol Club Barcelona', 2020)

GO