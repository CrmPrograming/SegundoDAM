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
