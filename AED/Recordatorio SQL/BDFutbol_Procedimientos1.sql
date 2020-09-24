-- ###################################

--		 BD FUTBOL PROCEDIMIENTOS

-- ###################################

-- autor: César Ravelo Martínez
-- fecha: 22/09/2020

USE bdFutbol
GO

-- 1. Crear un procedimiento almacenado que liste todos los contratos de cierto futbolista pasando
-- por parámetro de entrada el dni o nie del futbolista, ordenados por fecha de inicio. Los datos
-- a visualizar serán: Código de contrato, nombre de equipo, nombre de liga, fecha de inicio,
-- fecha de fin, precio anual y precio de recisión del contrato.

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


-- 2. Crear un procedimiento almacenado que inserte un equipo, de modo que se le pase como parámetros
-- todos los datos. Comprobar que el código de liga pasado exista en la tabla ligas. En caso de que no
-- exista la liga que no se inserte.
-- Devolver en un parámetro de salida: 0 si la liga no existe y 1 si la liga existe.
-- Devolver en otro parámetro de salida: 0 si el equipo no se insertó y 1 si la inserción fue correcta.

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
SELECT @eExiste [Existe Equipo], @iRealizado [Insert realizado]

-- Insertando un equipo en una liga que no existe
EXEC insertarEquipo 'Nuevo equipo 1', 'FALSA', 'Localidad de prueba', 1, @eExiste OUTPUT, @iRealizado OUTPUT
SELECT @eExiste [Existe Equipo], @iRealizado [Insert realizado]

-- Insertando un equipo que ya existe
EXEC insertarEquipo 'Nuevo equipo 1', 'SEGDM', 'Localidad de prueba', 1, @eExiste OUTPUT, @iRealizado OUTPUT
SELECT @eExiste [Existe Equipo], @iRealizado [Insert realizado]
GO



-- 3. Crear un procedimiento almacenado que indicándole un equipo, precio anual y un precio recisión, devuelva
-- dos parámetros. En un parámetro de salida la cantidad de futbolistas en activo (con contrato vigente) que hay
-- en dicho equipo. En otro parámetro de salida la cantidad de futbolistas en activo de dicho equipo con precio
-- anual y de recisión menor de los indicados.

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