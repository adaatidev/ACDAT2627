USE ad2627_ada_atienza;

CREATE TABLE Persona(
	dni			VARCHAR(15)	PRIMARY KEY,
	nombre		VARCHAR(50),
    apellido	VARCHAR(50),
    edad		INT
);

DROP TABLE Persona;