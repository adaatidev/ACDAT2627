USE SCOTT
GO

--	EJERCICIO 1.
CREATE OR ALTER FUNCTION DevolverCodDept (@NombreDepartamento VARCHAR(20))
RETURNS INT
AS
BEGIN
	DECLARE @CodigoDepartamento INT;

	SELECT @CodigoDepartamento = DEPTNO
	FROM DEPT 
	WHERE DNAME = @NombreDepartamento

	RETURN @CodigoDepartamento
END;
GO

--	EJERCICIO 2.
CREATE OR ALTER PROCEDURE HallarNumEmp (@NombreDepartamento VARCHAR(20))
AS
BEGIN
	DECLARE @CodigoDepartamento INT, @NumeroEmpleados INT;

	SET @CodigoDepartamento = dbo.DevolverCodDept(@NombreDepartamento);

	IF @CodigoDepartamento IS NULL
	BEGIN
		PRINT 'El departamento indicado no existe';
		RETURN;
	END

	SELECT @NumeroEmpleados = COUNT(*)
	FROM DEPT
	WHERE DEPTNO = @CodigoDepartamento;

	IF @NumeroEmpleados = 0
	BEGIN
		PRINT 'El departamento no tiene empleados'
	END
	ELSE 
	BEGIN
		PRINT 'El departamento ' + @NombreDepartamento + ' tiene ' + CAST(@NumeroEmpleados AS VARCHAR(10)) + ' empleados.';
	END
END;
GO

EXEC HallarNumEmp "ACCOUNTING";

--	EJERCICIO 3.
CREATE OR ALTER FUNCTION CalcularCosteSalarial (@NombreDepartamento VARCHAR(20))
RETURNS DECIMAL(10,2)
AS 
BEGIN
	DECLARE @CodigoDepartamento INT, @SumaTotal DECIMAL(10,2), @NumeroEmpleados INT;

	SET @CodigoDepartamento = dbo.DevolverCodDept(@NombreDepartamento);

	IF @CodigoDepartamento IS NULL
	BEGIN
		RETURN -1;
	END

	SELECT @SumaTotal = SUM(SAL + ISNULL(COMM, 0.00))
	FROM EMP
	WHERE DEPTNO = @CodigoDepartamento;
	
	RETURN ISNULL(@SumaTotal, 0.00);
END;
GO

SELECT dbo.CalcularCosteSalarial('ACCOUNTING');


--	EJERCICIO 4.
CREATE OR ALTER PROCEDURE MostrarCostesSalariales
AS
BEGIN
	
	--	Declaración de las variables
	DECLARE @NombreDepartamento VARCHAR(20), @CosteSalarial DECIMAL(10,2);

	--	Declaración del cursor
	DECLARE CursorMostrarCostesSalariales CURSOR FOR
		SELECT DNAME 
		FROM DEPT;

	--	Se abre el cursor
	OPEN CursorMostrarCostesSalariales;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
	FETCH NEXT FROM CursorMostrarCostesSalariales INTO @NombreDepartamento;

	--	Mientras que hayan filas
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--	Se asigna valor a la variable del coste salarial del departamento por el que esté iterando
		SET @CosteSalarial = dbo.CalcularCosteSalarial(@NombreDepartamento);
		SELECT @NombreDepartamento AS Departamento, @CosteSalarial AS CosteSalarial;
		PRINT 'Departamento: ' + @NombreDepartamento + ' | Coste salarial: ' + CAST(@CosteSalarial AS VARCHAR(20));
		
		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
		FETCH NEXT FROM CursorMostrarCostesSalariales INTO @NombreDepartamento;
	END;
	
	--	Cierre y liberación del cursor
	CLOSE CursorMostrarCostesSalariales;
	DEALLOCATE CursorMostrarCostesSalariales;
END;
GO

EXEC MostrarCostesSalariales;


--	EJERCICIO 5.
CREATE OR ALTER PROCEDURE MostrarAbreviaturas
AS
BEGIN
	
	--	Declaración de las variables
	DECLARE @NombreEmpleado VARCHAR(20);

	--	Declaración del cursor
	DECLARE CursorMostrarAbreviaturas CURSOR FOR
		SELECT ENAME
		FROM EMP;

	--	Se abre el cursor
	OPEN CursorMostrarAbreviaturas;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
	FETCH NEXT FROM CursorMostrarAbreviaturas INTO @NombreEmpleado;

	--	Mientras que hayan filas
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SELECT @NombreEmpleado AS Nombre, LEFT(@NombreEmpleado, 3) AS Abreviatura
		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
		FETCH NEXT FROM CursorMostrarAbreviaturas INTO @NombreEmpleado;
	END;

	--	Cierre y liberación de memoria del cursor
	CLOSE CursorMostrarAbreviaturas;
	DEALLOCATE CursorMostrarAbreviaturas;
END;
GO

EXEC MostrarAbreviaturas;


--	EJERCICIO 6.
CREATE OR ALTER PROCEDURE MostrarMasAntiguos
AS
BEGIN
	
	--	Declaración de las variables
	DECLARE @NombreDepartamento VARCHAR(20), @CodigoDepartamento INT;

	--	Declaración del cursor
	DECLARE CursorMostrarMasAntiguos CURSOR FOR
	SELECT DNAME
	FROM DEPT;

	--	Se abre el cursor
	OPEN CursorMostrarMasAntiguos;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
	FETCH NEXT FROM CursorMostrarMasAntiguos INTO @NombreDepartamento;

	--	Mientras que hayan filas
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--	Selecciona al empleado más antiguo de cada departamento
		SET @CodigoDepartamento = dbo.DevolverCodDept(@NombreDepartamento)
		SELECT TOP 1 ENAME, @NombreDepartamento
		FROM EMP
		WHERE DEPTNO = @CodigoDepartamento
		ORDER BY HIREDATE;

		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
		FETCH NEXT FROM CursorMostrarMasAntiguos INTO @NombreDepartamento;
	END;

	--	Cierre y liberación de memoria del cursor
	CLOSE CursorMostrarMasAntiguos;
	DEALLOCATE CursorMostrarMasAntiguos;
END;
GO

EXEC MostrarMasAntiguos;


--	EJERCICIO 7.
CREATE OR ALTER PROCEDURE MostrarJefes (@NombreDepartamento VARCHAR(20))
AS
BEGIN 

	--	Declaración de las variables
	DECLARE @CodigoDepartamento INT, @NombreEmpleado VARCHAR(20), @JefeDe VARCHAR(20);
	SET @CodigoDepartamento = dbo.DevolverCodDept(@NombreDepartamento);
	
	--	Declaración del cursor
	DECLARE CursorMostrarJefes CURSOR FOR
	SELECT ENAME, MGR
	FROM EMP;

	--	Se abre el cursor
	OPEN CursorMostrarJefes;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
	FETCH NEXT FROM CursorMostrarJefes INTO @NombreEmpleado, @JefeDe;

	--	Mientras que hayan filas
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--	Selecciona los empleados que son jefes de otro empleado
		SELECT @NombreEmpleado AS Jefe, @JefeDe AS Empleado 
		WHERE @JefeDe IS NOT NULL;

		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
		FETCH NEXT FROM CursorMostrarJefes INTO @NombreEmpleado, @JefeDe;
	END;

	--	Cierre y liberación de memoria del cursor
	CLOSE CursorMostrarJefes;
	DEALLOCATE CursorMostrarJefes;
END;
GO

EXEC MostrarJefes "ACCOUNTING";


--	EJERCICIO 8.
CREATE OR ALTER PROCEDURE MostrarMejoresVendedores
AS
BEGIN
	--	Selecciona los dos vendedores con más comisiones
	SELECT TOP 2 ENAME, JOB, COMM
	FROM EMP
	WHERE JOB = 'SALESMAN' 
	ORDER BY COMM DESC;
END;
GO

EXEC MostrarMejoresVendedores;


--	EJERCICIO 10.
CREATE OR ALTER PROCEDURE RecortarSueldos(@Letra VARCHAR(1))
AS
BEGIN
	--	Actualiza el sueldo de los empleados que su nombre empiece por la letra introducida
	UPDATE EMP
	SET SAL = 0.8*SAL
	WHERE LEFT(ENAME, 1) = @Letra;
END;
GO

EXEC RecortarSueldos "M";


--	EJERCICIO 11.
CREATE OR ALTER PROCEDURE BorrarBecarios
AS
BEGIN

	--	Declaración de las variables
	DECLARE @CodigoDepartamento INT;

	--	Declaración del cursor
	DECLARE CursorBorrarBecarios CURSOR FOR
	SELECT DEPTNO
	FROM EMP;

	--	Se abre el cursor
	OPEN CursorBorrarBecarios;

	--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
	FETCH NEXT FROM CursorBorrarBecarios INTO @CodigoDepartamento;
	
	--	Mientras que hayan filas
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--	Borra los dos empleados más nuevos de cada departamento
		DELETE FROM EMP 
		WHERE ENAME IN 
			(SELECT TOP 2 ENAME 
			FROM EMP 
			WHERE DEPTNO = @CodigoDepartamento 
			ORDER BY HIREDATE DESC);

		--	Lee la siguiente fila del conjunto de resultados asociados al cursor y asigna valor a la variable
		FETCH NEXT FROM CursorBorrarBecarios INTO @CodigoDepartamento;
	END;

	--	Cierre y liberación de memoria del cursor
	CLOSE CursorBorrarBecarios;
	DEALLOCATE CursorBorrarBecarios;
END;
GO

SELECT ENAME, HIREDATE
FROM EMP
WHERE JOB = 'SALESMAN';

EXEC BorrarBecarios;