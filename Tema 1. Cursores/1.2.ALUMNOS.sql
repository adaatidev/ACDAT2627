USE ALUMNOSMATRICULADOS
GO

--	Función auxiliar para sacar el código de una asignatura
CREATE OR ALTER FUNCTION CodigoAsignatura (@Asignatura VARCHAR(25))
RETURNS INT
AS
BEGIN
	DECLARE @CodigoAsignatura INT;

	SELECT @CodigoAsignatura = COD
	FROM ASIGNATURAS
	WHERE NOMBRE = @Asignatura;

	RETURN @CodigoAsignatura;
END;
GO

--	Función auxiliar para sacar el DNI de un alumno
CREATE OR ALTER FUNCTION DNIAlumno (@Alumno VARCHAR(30))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @DNI VARCHAR(10);

	SELECT @DNI = DNI
	FROM ALUMNOS
	WHERE APENOM = @Alumno;

	RETURN @DNI;
END;
GO

--	Procedimiento que recibe una asignatura y devuelve los nombres de los alumnos que lo han cursado junto a su nota
CREATE OR ALTER PROCEDURE AlumnosPorModulo (@Asignatura VARCHAR(25))
AS
BEGIN

	--	Excepción por si la asignatura introducida no existe
	IF @Asignatura NOT IN (SELECT NOMBRE FROM ASIGNATURAS)
	BEGIN
		PRINT 'La asignatura introducida no existe en la base de datos'
		RETURN;
	END;

	--	Declaración de variables
	DECLARE @Alumno VARCHAR(30), 
			@NotaAlumno DECIMAL(4,2), 
			@CodigoAsignatura INT, 

			@ContadorSuspensos INT, 
			@ContadorAprobados INT, 
			@ContadorNotables INT, 
			@ContadorSobresalientes INT,

			@NotaMasAlta DECIMAL(4,2),
			@NotaMasBaja DECIMAL(4,2),
			@AlumnoNotaMasAlta VARCHAR(30),
			@AlumnoNotaMasBaja VARCHAR(30);

	SET @CodigoAsignatura = dbo.CodigoAsignatura(@Asignatura);
	SET @ContadorSuspensos = 0;
	SET @ContadorAprobados = 0;
	SET @ContadorNotables = 0;
	SET @ContadorSobresalientes = 0;

	SET @NotaMasAlta = 0.0;
	SET @NotaMasBaja = 10;

	--	Declaración del cursor
	DECLARE CursorAsignaturas CURSOR FOR
	SELECT alum.APENOM, nota.NOTA
	FROM ALUMNOS alum
	INNER JOIN NOTAS nota
	ON alum.DNI = nota.DNI
	INNER JOIN ASIGNATURAS asig
	ON nota.COD = asig.COD
	WHERE nota.COD = @CodigoAsignatura;

	--	Se abre el cursor
	OPEN CursorAsignaturas;

	--	Se pasa a la siguiente fila y se almacenan las variables
	FETCH NEXT FROM CursorAsignaturas INTO @Alumno, @NotaAlumno;

	--	Mientras hayan filas
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--	Se imprimen los alumnos con su asignatura y su nota
		PRINT @Alumno + '	|	' + @Asignatura + '	|	Nota:	' + CAST(@NotaAlumno AS VARCHAR(10));

		--	Condicionales para almacenar el número de suspensos, aprobados, notables y sobresalientes
		IF @NotaAlumno >= 9 
		BEGIN
			SET @ContadorSobresalientes += 1
		END
		ELSE IF @NotaAlumno >= 7.0
		BEGIN
			SET @ContadorNotables += 1
		END
		ELSE IF @NotaAlumno >= 5.0
		BEGIN
			SET @ContadorAprobados += 1
		END
		ELSE
		BEGIN
			SET @ContadorSuspensos += 1
		END;

		--	Condicionales para almacenar el alumno, la nota más alta y la más baja
		IF @NotaAlumno > @NotaMasAlta
		BEGIN
			SET @NotaMasAlta = @NotaAlumno
			SET @AlumnoNotaMasAlta = @Alumno
		END
		IF @NotaAlumno < @NotaMasBaja
		BEGIN
			SET @NotaMasBaja = @NotaAlumno
			SET @AlumnoNotaMasBaja = @Alumno
		END;

		--	Sigue a la siguiente línea almacenando las variables
		FETCH NEXT FROM CursorAsignaturas INTO @Alumno, @NotaAlumno;
	END;

	--	Imprime el contador de notas
	IF @ContadorSuspensos != 0
	BEGIN
		PRINT 'Número de suspensos: ' + CAST(@ContadorSuspensos AS VARCHAR(10))
	END;

	IF @ContadorAprobados != 0
	BEGIN
		PRINT 'Número de aprobados: ' + CAST(@ContadorAprobados AS VARCHAR(10))
	END;

	IF @ContadorNotables != 0
	BEGIN
		PRINT 'Número de notables: ' + CAST(@ContadorNotables AS VARCHAR(10))
	END;

	IF @ContadorSobresalientes != 0
	BEGIN
		PRINT 'Número de sobresalientes: ' + CAST(@ContadorSobresalientes AS VARCHAR(10))
	END;

	--	Imprime a los alumnos con la nota más alta y la más baja
	PRINT 'Alumno con la nota más alta: ' + @AlumnoNotaMasAlta + '	|	' + CAST(@NotaMasAlta AS VARCHAR(10));
	PRINT 'Alumno con la nota más baja: ' + @AlumnoNotaMasBaja + '	|	' + CAST(@NotaMasBaja AS VARCHAR(10));

	CLOSE CursorAsignaturas;
	DEALLOCATE CursorAsignaturas;
END;
GO

EXEC AlumnosPorModulo "RET";
EXEC AlumnosPorModulo "Papoi";