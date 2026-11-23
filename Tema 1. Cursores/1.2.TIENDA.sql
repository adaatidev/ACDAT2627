USE PCCOMPONENTES
GO

--	Procedimiento para imprimir los productos
CREATE OR ALTER PROCEDURE ImprimirProductos
AS
BEGIN

	--	Declaración de las variables
	DECLARE @NombreLinea VARCHAR(10),
            @NombreProducto VARCHAR(20), 
            @UnidadesTotales INT,
            @ImporteTotalProducto DECIMAL(10,2), 
            @ImporteTotalLinea DECIMAL(10,2),
            @TotalVentasGeneral DECIMAL(10,2) = 0;

	--	Declaración del cursor principal, obtiene únicamente las líneas de producto distintas
	DECLARE CursorLineas CURSOR FOR
	SELECT DISTINCT LineaProducto
	FROM Productos
	WHERE LineaProducto IS NOT NULL;

	OPEN CursorLineas;
	FETCH NEXT FROM CursorLineas INTO @NombreLinea;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Línea de producto: ' + @NombreLinea;
		SET @ImporteTotalLinea = 0;

		--	Se declara el cursor secundario que obtiene los productos de la línea actual y acumula sus ventas
		DECLARE CursorProductos CURSOR FOR
        SELECT 
            p.Nombre,
            ISNULL(SUM(v.UnidadesVendidas), 0) AS UnidadesTotales,
            ISNULL(SUM(v.UnidadesVendidas * p.PrecioUnitario), 0) AS ImporteTotal
        FROM Productos p
        LEFT JOIN Ventas v ON p.CodProducto = v.CodProducto
        WHERE p.LineaProducto = @NombreLinea
        GROUP BY p.CodProducto, p.Nombre, p.PrecioUnitario;

		OPEN CursorProductos;
		FETCH NEXT FROM CursorProductos INTO @NombreProducto, @UnidadesTotales, @ImporteTotalProducto;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT	'	' + @NombreProducto + '	' +
					CAST(@UnidadesTotales AS VARCHAR(10)) + '	' + 
					CAST(@ImporteTotalProducto AS VARCHAR(15));

			SET @ImporteTotalLinea = @ImporteTotalLinea + @ImporteTotalProducto;

			FETCH NEXT FROM CursorProductos INTO @NombreProducto, @UnidadesTotales, @ImporteTotalProducto;
		END;

		CLOSE CursorProductos;
		DEALLOCATE CursorProductos;

		PRINT 'Importe total: ' + @NombreLinea + ':	' + CAST(@ImporteTotalLinea AS VARCHAR(15));
		PRINT '';

		SET @TotalVentasGeneral = @TotalVentasGeneral + @ImporteTotalLinea;

		FETCH NEXT FROM CursorLineas INTO @NombreLinea;
	END;

	CLOSE CursorLineas;
	DEALLOCATE CursorLineas;

	PRINT 'Total ventas:	' + CAST(@TotalVentasGeneral AS VARCHAR(15));
END;
GO

EXEC ImprimirProductos;