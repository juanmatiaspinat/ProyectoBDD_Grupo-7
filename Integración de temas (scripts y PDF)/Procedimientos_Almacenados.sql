------------------------------------------
--PROCEDIMIENTOS Y FUNCIONES ALMACENADAS--
------------------------------------------

-----------------------------
--INSERTAR UN ADMINISTRADOR--
-----------------------------

USE [base_consorcio]
GO

DROP PROCEDURE IF EXISTS [InsertarAdministrador]
GO

CREATE PROCEDURE [InsertarAdministrador] (
	@apeynom varchar(50) = null,
	@viveahi varchar(1) = null,
	@tel varchar(20) = null,
	@sexo varchar(1) = null,
	@fechnac datetime  = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	BEGIN TRAN
	INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) 
	VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac)
	COMMIT TRAN
END TRY
BEGIN CATCH
	SET @error = CASE
					WHEN ERROR_MESSAGE() LIKE '%CK_habitante_viveahi%' THEN 'Valor incorrecto para el campo viveahi. Los valores posibles son S y N.'
					ELSE ERROR_MESSAGE()
					END
	ROLLBACK TRAN;
	SET @exito = 0
END CATCH
END

--INSERCCION INCORRECTA

DECLARE @inserccionExitosa bit 
DECLARE @mensajeError varchar(200)
EXEC InsertarAdministrador 'Gonzale Rodrigo', 'G' , '37943358', 'M', '2001-23-06', @inserccionExitosa OUT, @mensajeError OUT
Select @inserccionExitosa
SELECT @mensajeError

--INSERCCION CORRECTA

DECLARE @inserccionExitosa bit 
DECLARE @mensajeError varchar(200)
EXEC InsertarAdministrador 'Gonzalez Rodrigo', 'S' , '37943358', 'M', '2001-23-06', @inserccionExitosa OUT, @mensajeError OUT
Select @inserccionExitosa
SELECT @mensajeError

Select * From administrador
where apeynom like 'Gonzalez %'



------------------------------
--ELIMINAR UN ADMINISTRADOR.--
------------------------------


USE [base_consorcio]
GO

DROP PROCEDURE IF EXISTS [EliminarAdministrador]
GO

CREATE PROCEDURE [EliminarAdministrador] (
	@idadmin int = null,
	@exito bit OUT,
	@error varchar(200) OUT
)
AS 
BEGIN
SET @exito = 1
BEGIN TRY
	IF NOT EXISTS (SELECT * FROM administrador WHERE idadmin=@idadmin)
	BEGIN
		SET @exito = 0
		SET @error = 'Administrador inexistente'
		RETURN
	END
	BEGIN TRAN
	DELETE FROM administrador
	WHERE idadmin=@idadmin
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	SET @error = ERROR_MESSAGE()
	SET @exito = 0
END CATCH
END

--ELIMINACION FALLIDA

DECLARE @inserccionExitosa bit 
DECLARE @mensajeError varchar(200)
EXEC EliminarAdministrador 180, @inserccionExitosa OUT, @mensajeError OUT
Select @inserccionExitosa
SELECT @mensajeError

--ELIMINACION CORRECTA

DECLARE @inserccionExitosa bit 
DECLARE @mensajeError varchar(200)
EXEC EliminarAdministrador 179, @inserccionExitosa OUT, @mensajeError OUT
Select @inserccionExitosa
SELECT @mensajeError

Select * From administrador
where idadmin = 179


----------------------------------------
--CREAR LA FUNCION DE "CALCULAR EDAD"--
---------------------------------------


USE [base_consorcio]
GO

DROP FUNCTION IF EXISTS [CalcularEdad]
GO

CREATE FUNCTION [CalcularEdad] (
	@FechaNacimiento date
)
RETURNS int
AS
BEGIN
	RETURN DATEDIFF(YEAR, @FechaNacimiento, GETDATE())
END

select *, dbo.CalcularEdad(fechnac) as 'Edad' From administrador

----------------------------
----VER ADMINISTRADORES----
----------------------------

Create Procedure [VerAdministradores]
AS
BEGIN 
SELECT 
  [Apellido y Nombre] = apeynom,
  [Telefono] = tel,
  [Edad] = dbo.calcularedad(fechnac),
  [Sexo] = IIF(sexo = 'F', 'Femenino', 'Masculino'),
  [Fecha de Nacimiento] = FORMAT(CONVERT(date, fechnac),'dd-mm-yyyy'),
  [Vive ahi] = IIF(viveahi = 'S', 'Si', 'No')
FROM administrador
END


exec VerAdministradores


-------------------------
------VER CONSORCIOS-----
-------------------------


Create Procedure [VerConsorcio]
AS
BEGIN 
SELECT 
  [Provincia] = p.descripcion,
  [Localidad] = l.descripcion,
  [Nombre Consorcio] = c.nombre,
  [Direccion] = c.direccion,
  [Zona] = z.descripcion,
  [Conserje] = co.apeynom,
  [Administrador] = a.apeynom
FROM consorcio c
INNER JOIN provincia p 
on p.idprovincia = c.idprovincia 
INNER JOIN localidad l 
on l.idprovincia = c.idprovincia and l.idlocalidad = c.idlocalidad
INNER JOIN zona z 
on c.idzona = z.idzona
INNER JOIN conserje co
on c.idconserje = co.idconserje
INNER JOIN administrador a 
on c.idadmin = a.idadmin
END

exec VerConsorcio

