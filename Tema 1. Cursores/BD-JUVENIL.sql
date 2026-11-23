CREATE DATABASE JUVENIL
USE JUVENIL

CREATE TABLE SOCIOS (
DNI				VARCHAR(10)	NOT NULL,
Nombre			VARCHAR(20)	NOT NULL,
Direccion		VARCHAR(20),
Penalizaciones	NUMERIC(2)	DEFAULT 0,

CONSTRAINT pk_socios PRIMARY KEY (DNI)
);

CREATE TABLE LIBROS (
RefLibro		VARCHAR(10)	NOT NULL,
Nombre			VARCHAR(30) NOT NULL,
Autor			VARCHAR(20)	NOT NULL,
Genero			VARCHAR(10),
AnoPublicacion	INT,
Editorial		VARCHAR(10),

CONSTRAINT pk_libros PRIMARY KEY (RefLibro)
);

CREATE TABLE PRESTAMOS (
DNI				VARCHAR(10)	NOT NULL,
RefLibro		VARCHAR(10)	NOT NULL,
FechaPrestamo	DATE		NOT NULL,
Duracion		NUMERIC(2)	DEFAULT 24,

CONSTRAINT pk_prestamos PRIMARY KEY (FechaPrestamo),
CONSTRAINT fk_prestamos_socios FOREIGN KEY (DNI) REFERENCES SOCIOS (DNI),
CONSTRAINT fk_prestamos_libros FOREIGN KEY (RefLibro) REFERENCES LIBROS (RefLibro)
);


INSERT INTO socios VALUES ('111-A', 'David',   'Sevilla Este', 2);
INSERT INTO socios VALUES ('222-B', 'Mariano', 'Los Remedios', 3);
INSERT INTO socios (DNI, Nombre, Direccion) VALUES ('333-C', 'Raul',    'Triana'      );
INSERT INTO socios (DNI, Nombre, Direccion) VALUES ('444-D', 'Rocio',   'La Oliva'    );
INSERT INTO socios VALUES ('555-E', 'Marilo',  'Triana',       2);
INSERT INTO socios VALUES ('666-F', 'Benjamin','Montequinto',  5);
INSERT INTO socios (DNI, Nombre, Direccion) VALUES ('777-G', 'Carlos',  'Los Remedios');
INSERT INTO socios VALUES ('888-H', 'Manolo',  'Montequinto',  2);

INSERT INTO libros VALUES('E-1', 'El valor de educar', 'Savater',    'Ensayo', 1994, 'Alfaguara');
INSERT INTO libros VALUES('N-1', 'El Quijote',         'Cervantes',  'Novela', 1602, 'Anagrama');
INSERT INTO libros VALUES('E-2', 'La Republica',       'Platón',     'Ensayo', -230, 'Anagrama');
INSERT INTO libros VALUES('N-2', 'Tombuctu',           'Auster',     'Novela', 1998, 'Planeta');
INSERT INTO libros VALUES('N-3', 'Todos los nombres',  'Saramago',   'Novela', 1995, 'Planeta');
INSERT INTO libros VALUES('E-3', 'Etica para Amador',  'Savater',    'Ensayo', 1991, 'Alfaguara');
INSERT INTO libros VALUES('P-1', 'Rimas y Leyendas',   'Becquer',    'Poesia', 1837, 'Anagrama');
INSERT INTO libros VALUES('P-2', 'Las flores del mal', 'Baudelaire', 'Poesia', 1853, 'Anagrama');
INSERT INTO libros VALUES('P-3', 'El fulgor',          'Valente',    'Poesia', 1998, 'Alfaguara');
INSERT INTO libros VALUES('N-4', 'Lolita',             'Nabokov',    'Novela', 1965, 'Planeta');
INSERT INTO libros VALUES('C-1', 'En salvaje compañia','Rivas',      'Cuento', 2001, 'Alfaguara');

INSERT INTO prestamos VALUES('111-A','E-1', '17/12/00',24);
INSERT INTO prestamos VALUES('333-C','C-1', '15/12/01',48);
INSERT INTO prestamos VALUES('111-A','N-1', '17/12/01',24);
INSERT INTO prestamos VALUES('444-D','E-1', '17/12/01',48);
--INSERT INTO prestamos VALUES('111-A','C-2', '17/12/01',72);
INSERT INTO prestamos (DNI, RefLibro, FechaPrestamo) VALUES('777-G','N-1', '07/12/01');
INSERT INTO prestamos VALUES('111-A','N-1', '16/12/01',48);