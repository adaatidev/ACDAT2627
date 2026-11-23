USE JUVENIL
GO

--	EJERCICIO 1.
CREATE OR ALTER PROCEDURE ListadoCuatroMasPrestados
AS
BEGIN
	-- Si la tabla LIBROS está vacía
	IF NOT EXISTS (SELECT 1 FROM LIBROS)
	BEGIN
		PRINT 'ERROR: La tabla LIBROS está vacía';
		RETURN;
	END;

	-- Si la tabla SOCIOS está vacía
	IF NOT EXISTS (SELECT 1 FROM SOCIOS)
	BEGIN
		PRINT 'ERROR: La tabla SOCIOS está vacía';
		RETURN;
	END;

	-- Si la tabla LIBROS tiene menos de cuatro libros prestados
	--DECLARE @TotalLibros INT;
	--SELECT @TotalLibros = COUNT(DISTINCT RefLibro) FROM PRESTAMOS;

	--IF @TotalLibros < 4
	--BEGIN
	--	PRINT 'Hay menos de cuatro libros que han sido prestados.';
	--	RETURN;
	--END;

	--	Declaración de variables
	DECLARE @RefLibro VARCHAR(10), @NombreLibro VARCHAR(30), @NumeroPrestamos INT, @Genero VARCHAR(10);

	--	Declaración del cursor, selecciona los cuatro libros más prestados
	DECLARE CursorLibros CURSOR FOR
	SELECT TOP 4 p.RefLibro, l.Nombre, COUNT(p.RefLibro), l.Genero
	FROM PRESTAMOS p
	INNER JOIN LIBROS l
	ON p.RefLibro = l.RefLibro
	GROUP BY p.RefLibro, l.Nombre, l.Genero
	ORDER BY COUNT(p.RefLibro) DESC;

	--	Se abre el cursor
	OPEN CursorLibros;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valores a las variables
	FETCH NEXT FROM CursorLibros INTO @RefLibro, @NombreLibro, @NumeroPrestamos, @Genero;

	--	Mientras que hayan filas
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--	Imprime el nombre del libro, las veces que ha sido prestado y su género
		PRINT @NombreLibro + '	|	' + CAST(@NumeroPrestamos AS VARCHAR(20)) + '	|	' + @Genero;

		--	Declaración de variables
		DECLARE @DNI VARCHAR(10), @FechaPrestamo DATE;

		--	Declaración del cursor, selecciona el DNI y la fecha de préstamo del libro seleccionado
		DECLARE CursorPrestamos CURSOR FOR
		SELECT p.DNI, p.FechaPrestamo
		FROM PRESTAMOS p
		WHERE p.RefLibro = @RefLibro;

		--	Se abre el cursor
		OPEN CursorPrestamos;

		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valores a las variables
		FETCH NEXT FROM CursorPrestamos INTO @DNI, @FechaPrestamo;

		--	Mientras que hayan filas
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			--	Imprime el DNI y la fecha en la que fue prestado
			PRINT @DNI + '	|	' + CAST(@FechaPrestamo AS VARCHAR(20));

			--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valores a las variables
			FETCH NEXT FROM CursorPrestamos INTO @DNI, @FechaPrestamo;
		END;

		--	Cierre y liberación de memoria del cursor
		CLOSE CursorPrestamos;
		DEALLOCATE CursorPrestamos;

		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valores a las variables
		FETCH NEXT FROM CursorLibros INTO @RefLibro, @NombreLibro, @NumeroPrestamos, @Genero;
	END;

	--	Cierre y liberación de memoria del cursor
	CLOSE CursorLibros;
	DEALLOCATE CursorLibros;
END;
GO

EXEC ListadoCuatroMasPrestados;