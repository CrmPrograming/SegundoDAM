CREATE DATABASE bdFutbol;


USE bdFutbol;


CREATE TABLE ligas (codLiga CHAR(5),
                    nomLiga VARCHAR(50),
                    CONSTRAINT pk_codEquipo PRIMARY KEY (codLiga));


CREATE TABLE equipos (codEquipo INTEGER AUTO_INCREMENT,
					  nomEquipo VARCHAR(40),
					  codLiga CHAR(5) DEFAULT 'PND',
					  localidad VARCHAR(60),
					  internacional BIT DEFAULT 0,                      
                      CONSTRAINT pk_codEquipo PRIMARY KEY (codEquipo),
                      CONSTRAINT fk_codLiga FOREIGN KEY (codLiga) REFERENCES ligas(codLiga)                      
					  );
                      
CREATE TABLE fubtbolistas (coddnionie CHAR(9),
						   nombre VARCHAR(50),
						   nacionalidad VARCHAR(40),
                           CONSTRAINT pk_coddnionie PRIMARY KEY (coddnionie));


CREATE TABLE contratos (codcontrato INTEGER AUTO_INCREMENT,
						coddnionie CHAR(9),
						codEquipo INTEGER,
						fechaInicio DATE,
						fechaFin DATE,
						precioanual INTEGER,
						preciorecision INTEGER,
                        CONSTRAINT pk_codcontrato PRIMARY KEY (codcontrato),
                        CONSTRAINT fk_coddnionie FOREIGN KEY (coddnionie) REFERENCES fubtbolistas(coddnionie),
                        CONSTRAINT fk_codEquipo FOREIGN KEY (codEquipo) REFERENCES equipos(codEquipo));




INSERT INTO ligas (codLiga, nomLiga) VALUES ('PRIMM', 'Primera división masculina'),
						 ('SEGDM', 'Segunda división masculina');


INSERT INTO equipos (nomEquipo, codLiga, localidad, internacional) VALUES ('Deportivo Alavés', 'PRIMM', 'Vitoria', 0),
						   ('Athletic Club', 'PRIMM', 'Bilbao', 0),
						   ('Club Atlético de Madrid', 'PRIMM', 'Madrid', 1),
						   ('Fútbol Club Barcelona', 'PRIMM', 'Barcelona', 1),
						   ('Real Betis Balompié', 'PRIMM', 'Sevilla', 0),
						   ('Cádiz Club de Fútbol', 'PRIMM', 'Cádiz', 0),
						   ('Real Madrid Club de Fútbol', 'PRIMM', 'Madrid', 1),
						   ('Valencia Club de Fútbol', 'PRIMM', 'Valencia', 1),
						   ('Real Sociedad de Fútbol', 'PRIMM', 'San Sebastián', 0),
						   ('Villareal Club de Fútbol', 'PRIMM', 'Villareal', 0);


INSERT INTO fubtbolistas (coddnionie, nombre, nacionalidad) VALUES ('12345678A', 'Cristiano Ronaldo', 'Portugal'),
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
								('23456789O', 'Paco Alcácer', 'España');


INSERT INTO contratos (coddnionie, codEquipo, fechaInicio, fechaFin, precioanual, preciorecision) VALUES ('12345678A', 7, '2020/09/22', '2025/10/12', 150000, 200000),
							 ('12345678A', 7, '2025/11/10', '2028/10/26', 167000, 230000),
							 ('90123456B', 7, '2017/11/10', '2025/10/12', 155000, 7341240),
							 ('67890123C', 2, '2017/11/10', '2020/09/22', 155000, 7341240),
							 ('45678901D', 1, '2017/01/05', '2020/09/22', 155000, 5637200),
							 ('45678901D', 2, '2020/09/22', '2024/04/15', 165000, 5637200),
							 ('45678901I', 4, '2010/07/26', '2020/09/22', 185000, 7652100),
							 ('23456789J', 4, '2010/07/26', '2020/09/22', 193000, 6652100),
							 ('23456789O', 10, '2010/07/26', '2020/09/22', 185000, 7652100),
							 ('23456789O', 10, '2020/09/22', '2023/11/26', 185000, 7775600);


-- ###################################

--		     PROCEDIMIENTOS

-- ###################################

-- 1. Crear un procedimiento almacenado que liste todos los contratos de cierto futbolista pasando
-- por parámetro de entrada el dni o nie del futbolista, ordenados por fecha de inicio. Los datos
-- a visualizar serán: Código de contrato, nombre de equipo, nombre de liga, fecha de inicio,
-- fecha de fin, precio anual y precio de recisión del contrato.


DELIMITER //

CREATE PROCEDURE listarContratoFutbolista(IN codigoFutbolista CHAR(9))
BEGIN
	IF (SELECT COUNT(*) FROM contratos WHERE coddnionie = codigoFutbolista) = 0 THEN
		SELECT "No existe contratos para el jugador con el dni dado";
	ELSE
    	SELECT codContrato, nomEquipo, nomLiga, fechaInicio, fechaFin, precioanual, preciorecision
        FROM contratos INNER JOIN equipos ON contratos.codEquipo = equipos.codEquipo
        	INNER JOIN ligas ON equipos.codLiga = ligas.codLiga
        WHERE coddnionie = codigoFutbolista
        ORDER BY fechaInicio;
    END IF;
END;
//
DELIMITER ;

SET @dnijugador = '45678901D';

-- Prueba con un jugador con contrato
CALL listarContratoFutbolista(@dnijugador);

-- Prueba con un jugador sin contrato
CALL listarContratoFutbolista('77777777Z');


-- 2. Crear un procedimiento almacenado que inserte un equipo, de modo que se le pase como parámetros
-- todos los datos. Comprobar que el código de liga pasado exista en la tabla ligas. En caso de que no
-- exista la liga que no se inserte.
-- Devolver en un parámetro de salida: 0 si la liga no existe y 1 si la liga existe.
-- Devolver en otro parámetro de salida: 0 si el equipo no se insertó y 1 si la inserción fue correcta.

DELIMITER //
CREATE PROCEDURE insertarEquipo(pNombre VARCHAR(40), pLiga CHAR(5), pLocalidad VARCHAR(60), pInternacional BIT, OUT oEstadoLiga BIT, OUT oEstadoInsercion BIT)
BEGIN
	SET oEstadoLiga = 0;
	SET oEstadoInsercion = 0;

	IF (SELECT COUNT(*) FROM ligas WHERE codLiga = pLiga) = 1 THEN
		SET oEstadoLiga = 1;
		-- Comprobamos si el equipo a insertar ya existe antes de almacenarlo
		IF (SELECT COUNT(*) FROM equipos WHERE nomEquipo = pNombre AND codLiga = pLiga AND localidad = pLocalidad AND internacional = pInternacional) = 0 THEN
			SET oEstadoInsercion = 1;
			INSERT equipos VALUES (NULL, pNombre, pLiga, pLocalidad, pInternacional);
		END IF;
	END IF;
END;
//
DELIMITER ;

-- Insertando un equipo nuevo
CALL insertarEquipo('Nuevo equipo 1', 'SEGDM', 'Localidad de prueba', 1, @EExiste, @iRealizado);
SELECT @eExiste AS `Existe Liga`, @iRealizado AS `Insert realizado`;

-- Insertando un equipo en una liga que no existe
CALL insertarEquipo('Nuevo equipo 1', 'FALSA', 'Localidad de prueba', 1, @eExiste, @iRealizado);
SELECT @eExiste AS `Existe Liga`, @iRealizado AS `Insert realizado`;

-- Insertando un equipo que ya existe
CALL insertarEquipo('Nuevo equipo 1', 'SEGDM', 'Localidad de prueba', 1, @eExiste, @iRealizado);
SELECT @eExiste AS `Existe Liga`, @iRealizado AS `Insert realizado`;


-- 3. Crear un procedimiento almacenado que indicándole un equipo, precio anual y un precio recisión, devuelva
-- dos parámetros. En un parámetro de salida la cantidad de futbolistas en activo (con contrato vigente) que hay
-- en dicho equipo. En otro parámetro de salida la cantidad de futbolistas en activo de dicho equipo con precio
-- anual y de recisión menor de los indicados.

DELIMITER //

CREATE PROCEDURE futbolistasActivos(pEquipo INT, pPrecio INT, pRecis INT, OUT oActivosEquipo INT, OUT oActivosPrecioAnual INT)
BEGIN
	IF (SELECT COUNT(*) FROM equipos WHERE codEquipo = pEquipo) = 0 THEN
		SET oActivosEquipo = -1;
		SET oActivosPrecioAnual = -1;
		SELECT "No existe el equipo indicado";
	ELSE
		SELECT COUNT(*) INTO oActivosEquipo
		FROM contratos
		WHERE codEquipo = pEquipo AND fechaFin > NOW();

		SELECT COUNT(*) INTO oActivosPrecioAnual
		FROM contratos
		WHERE codEquipo = pEquipo AND fechaFin > NOW() AND precioanual < pPrecio AND preciorecision < pRecis;
	END IF;
END;
//
DELIMITER ;

-- Prueba para equipo no existente

CALL futbolistasActivos(77, 10000, 10000, @activos, @activosPrecio);
SELECT @activos AS `Total de jugadores activos en el equipo`, @activosPrecio `Total de jugadores activos con criterio dado`;

-- Prueba para equipo existente

CALL futbolistasActivos(7, 8230000, 9000000, @activos, @activosPrecio);
SELECT @activos AS `Total de jugadores activos en el equipo`, @activosPrecio AS `Total de jugadores activos con criterio dado`;


-- 4. Crear una función que dándole un dni o nie de un futbolista nos devuelva en número de meses total que ha estado en equipos.

DELIMITER //

CREATE FUNCTION fnTotalMeses(pDni CHAR(9))
RETURNS INT
BEGIN
	RETURN (SELECT SUM(TIMESTAMPDIFF(MONTH, fechaInicio, fechaFin))
			FROM contratos 
			WHERE coddnionie = pDni);
END;
//
DELIMITER ;

SELECT fnTotalMeses('23456789O') AS `Total meses`;


-- 5. Hacer una función que devuelva los nombres de los equipos que pertenecen a una determinada liga que le pasamos el nombre
-- por parámetro de entrada, si la liga no existe deberá aparecer liga no existe.

DELIMITER //
CREATE PROCEDURE equiposLiga(pLiga VARCHAR(50))
BEGIN
	IF (SELECT COUNT(*) FROM ligas WHERE nomLiga = pLiga) = 0 THEN
		SELECT 'Liga no existe';
	ELSE
		SELECT nomEquipo 
		FROM equipos
		WHERE codLiga = (SELECT codLiga FROM ligas WHERE nomLiga = pLiga);
	END IF;
END;
//
DELIMITER ;

-- Liga no existente
CALL equiposLiga('Liga Falsa');

-- Liga existente
CALL equiposLiga('Primera división masculina');


-- 6. Hacer una función en la que visualicemos los datos de los jugadores extranjeros que pertenezcan a un equipo cuyo
-- nombre pasamos por parámetro.

DELIMITER //
CREATE PROCEDURE jugadoresExtranjeros(pEquipo VARCHAR(40))
BEGIN

	SELECT *
    FROM fubtbolistas
	WHERE nacionalidad <> 'España' AND coddnionie IN (SELECT coddnionie 
													  FROM contratos 
													  WHERE codEquipo = (SELECT codEquipo
								   										 FROM equipos
								   										 WHERE nomEquipo = pEquipo));
END;
//
DELIMITER ;

CALL jugadoresExtranjeros('Real Madrid Club de Fútbol');



-- 7. Hacer una función que nos devuelva por cada futbolista su nombre y en cuantos equipos a tenido contrato entre
-- dos fechas determinadas.

DELIMITER //
CREATE PROCEDURE contratosFutbolistas(pFechaInicial DATE, pFechaFinal DATE)
BEGIN
	SELECT nombre, COUNT(DISTINCT contratos.codEquipo) AS `Total`
	FROM fubtbolistas
		INNER JOIN contratos ON fubtbolistas.coddnionie = contratos.coddnionie
	WHERE fechaInicio >= pFechaInicial AND fechaFin <= pFechaFinal
	GROUP BY nombre;
	
END;
//
DELIMITER ;

CALL contratosFutbolistas('2000/01/01', '2030/12/20');


-- 8. Hacer una función escalar que nos devuelva el precioanual mas alto que se le ha pagado a un futbolista,
-- con el nombre de equipo y año pasado por parámetro.


DELIMITER //
CREATE FUNCTION fnMejorPrecioAnual(pEquipo VARCHAR(40), pFecha INT)
RETURNS INT
BEGIN
	RETURN (SELECT MAX(precioanual)
			FROM contratos
			WHERE YEAR(fechaInicio) = pFecha OR YEAR(fechaFin) = pFecha 
				AND codEquipo =	(SELECT codEquipo FROM equipos WHERE nomEquipo = pEquipo));
END;
//
DELIMITER ;

SELECT fnMejorPrecioAnual('Fútbol Club Barcelona', 2020);


-- 9. Hacer un Trigger que en la tabla contratos al insertar o modificar el precio de recisión no permita que
-- sea menor que el precio anual.

DELIMITER //
CREATE TRIGGER trI_precioMenorAnual BEFORE INSERT
ON contratos FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM contratos WHERE NEW.preciorecision < NEW.precioanual) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se permiten precios de recisión menores al precio anual';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trU_precioMenorAnual BEFORE UPDATE
ON contratos FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM contratos WHERE NEW.preciorecision < NEW.precioanual) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se permiten precios de recisión menores al precio anual';
    END IF;
END;
//
DELIMITER ;

UPDATE contratos SET preciorecision = 1 WHERE codcontrato = 1;


-- 10. Hacer un Trigger que si en la tabla contratos que al insertar o modificar ponemos la fecha inicio
-- posterior a la fecha fin que las intercambie. 

DELIMITER //
CREATE TRIGGER trI_FechaInicioPosterior
BEFORE INSERT ON contratos
FOR EACH ROW
BEGIN
	IF (NEW.fechaInicio > NEW.fechaFin) THEN    	
        SET @auxiliar = NEW.fechaInicio;
        SET NEW.fechaInicio = NEW.fechaFin;
        SET NEW.fechaFin = @auxiliar;
    END IF;
END;
//
DELIMITER ;

SELECT * FROM contratos;
INSERT contratos VALUES (NULL, '45678901D', 1, '2025-10-01', '2021-08-03', 77777, 99999);
SELECT * FROM contratos;


-- 11. Hacer un Trigger que no permita eliminar ninguna liga.

DELIMITER //
CREATE TRIGGER tr_ImpedirBorrarLiga
BEFORE DELETE
ON ligas
FOR EACH ROW
BEGIN	
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No está permitido borrar ligas';
END;
//
DELIMITER ;

-- Intentamos borrar liga
SELECT * FROM ligas;
DELETE FROM ligas WHERE codLiga = 'SEGDM';
SELECT * FROM ligas;