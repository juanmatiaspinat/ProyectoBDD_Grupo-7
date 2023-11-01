---------------------------------------------------
---------------------TAREAS------------------------
---------------------------------------------------

--Use Master

------------------------------------------------------------------------------------------------------

/* 1)Verificar que el mode de recuperación de la base de datos este en el modo adecuado para realizar backup en linea */
------------------------------------------------------------------------------------------------------

/* Esta línea indica que se seleccionarán dos columnas de la tabla sys.databases. 
Estas columnas son name (que contiene el nombre de la base de datos) y recovery_model_desc 
(que contiene el modo de recuperación de la base de datos). */
SELECT name, recovery_model_desc

/* Esta línea especifica la tabla de la cual se seleccionarán los datos. sys.databases es una 
vista del sistema en SQL Server que contiene información sobre todas las bases de datos en la instancia de SQL Server. */
FROM sys.databases

/* Esta línea especifica la tabla de la cual se seleccionarán los datos. sys.databases es una vista del sistema en SQL Server que contiene información sobre todas las bases de datos en la instancia de SQL Server.*/
WHERE name = 'base_consorcio'

/* Esta parte de la sentencia indica que se realizará una acción en la base de datos llamada "base_consorcio". Específicamente, se realizará un cambio en su configuración. */
ALTER DATABASE base_consorcio SET RECOVERY FULL;

/* Esta parte de la sentencia establece el nuevo modo de recuperación de la base de datos como "FULL". En el modo de recuperación completa, SQL Server mantiene un registro completo de todas las transacciones, lo que permite realizar copias de seguridad en línea y restauraciones hasta el punto exacto de una transacción. */
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio'


------------------------------------------------
/* 2) Realizar un backup full de la base de datos */
------------------------------------------------

--Use base_consorcio

/* Aquí se declara una variable llamada @Fecha con un tipo de datos VARCHAR de longitud 200. Esta variable se usará para almacenar la fecha y hora actual en un formato específico. */
DECLARE @Fecha VARCHAR(200)

/* Aquí se asigna un valor a la variable @Fecha la cual sera el resultado de la siguiente operacion, la cual convierte a VARCHAR la fecha actual */
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

/* Se declara una segunda variable llamada @DireccionCarpeta con un tipo de datos VARCHAR de longitud 400. Esta variable se usará para almacenar la ruta del archivo de respaldo de la base de datos. */
Declare @DireccionCarpeta Varchar(400)

/* En esta línea,se asigna el valor que tomara la variable @DireccionCarpeta la cual sera la ruta del archivo de respaldo para la base de datos */
Set @DireccionCarpeta = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Consorcio\Consorcio ' + @Fecha + '.bak'

/* Esta es la sentencia donde se ejecuta el BACKUP de la base de datos llamada base_consorcio en el archivo especificado por la variable @DireccionCarpeta */
BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta

/* WITH INIT: Indica que se está realizando una copia de seguridad inicial. Si ya existen copias de seguridad en el archivo de respaldo, esta opción las sobrescribe.
NAME = 'base_consorcio': Aquí se asigna un nombre a la copia de seguridad.
STATS = 10: Muestra información de progreso en la operación de copia de seguridad cada vez que se completen 10 porcentajes de la operación. */
WITH INIT, NAME = 'base_consorcio', STATS = 10

-----------------------------------------------
/* 3) Generar 10 inserts sobre la  tabla gasto */
-----------------------------------------------

INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,6,'20130720',5,708.97)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,3,'20130312',3,58026.65)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130709',3,72573.61)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130718',3,11137.20)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130802',2,2033.99)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,1,'20130111',4,532.22)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,7,'20130426',4,5243.66)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130802',3,2910.70)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,8,'20130823',3,403.09)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (1,1,1,3,'20130311',3,8853.68)

Select * From gasto

-----------------------------------------------------------------------
/* 4) Realizar backup del archivo de log y registrar la hora del backup */
------------------------------------------------------------------------

--Para realizar el backup de log, utilizamos la misma sentencia que para el backup con la extension .bak, solamente cambiamos algunos parametros, como el nombre del archivo y la extension.

DECLARE @Fecha VARCHAR(200)
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

Declare @DireccionCarpeta Varchar(400)
Set @DireccionCarpeta = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Consorcio\LogBackupConsorcio ' + @Fecha + '.trn'

BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta
WITH INIT, NAME = 'base_consorcio', STATS = 10

----------------------------------------------------
/* 5) Generar otros 10 insert sobre la tabla gasto. */
----------------------------------------------------

INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,3,1,11,'20161105',1,4888.92)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,3,1,7,'20160722',5,970.72)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160224',4,8264.97)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,7,'20160728',1,3317.89)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160212',1,9002.84)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,3,'20160319',2,4043.28)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,2,'20160218',5,288.56)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,8,'20160818',5,426.35)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,8,'20160802',4,4789.37)
INSERT INTO gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) VALUES (11,5,2,10,'20161022',5,431.32)

Select * From gasto

---------------------------------------------------------------------------
/* 6) Realizar nuevamente backup de archivo de log  en otro archivo fisico. */
---------------------------------------------------------------------------

DECLARE @Fecha VARCHAR(200)
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

Declare @DireccionCarpeta Varchar(400)
Set @DireccionCarpeta = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Consorcio\LogBackupConsorcio ' + @Fecha + '.trn'

BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta
WITH INIT, NAME = 'base_consorcio', STATS = 10

------------------------------------------------------------------------------------------------------------------------------
/* 7) Restaurar la base de datos al momento del primer backup del archivo de log. Es decir después de los primeros 10 insert. */
------------------------------------------------------------------------------------------------------------------------------

/* Para realizar la restauracion utilizamos la misma sentencia que para la restauracion de la base de datos con los archivos '.bak' solamente realizacion unas modificaciones en la extension del archivo busado */

--use master

DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';

DECLARE @Ubicacion NVARCHAR(128);

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Oct 31 2023  9.38PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH RECOVERY;

--use base_consorcio

select * from gasto

-----------------------------------------------------------------
/* 8) Restaurar la base de datos aplicando ambos archivos de log. */
----------------------------------------------------------------

--use master

--Restauracion de los 2 archivos de log. 

DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';
DECLARE @Ubicacion NVARCHAR(128);

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Oct 31 2023  9.38PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH RECOVERY;

SELECT @Ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
  AND RIGHT(m.physical_device_name, 4) = '.trn' -- Filtrar por la extensión ".trn"
  AND m.physical_device_name LIKE '%LogBackupConsorcio Oct 31 2023  9.39PM%' -- Filtrar por el nombre del archivo
ORDER BY b.backup_start_date DESC;

RESTORE Database base_consorcio
FROM DISK = @Ubicacion
WITH RECOVERY;

--use base_consorcio

--Select * From gasto

----------------
/*CONCLUSION */
---------------

/*Como conclusión podríamos decir que la restauración de los datos (Restore) y la copia de seguridad (Backup) están muy relacionada una con la otra dado que no nos sirve realizar una copia de seguridad si no vamos a restaurar dichos datos en algún momento determinado y para realizar dicha restauración debemos tener una copia de seguridad válida para ello. De esta manera siempre que se haga una copia de seguridad vamos a tener la seguridad de poder volver a dichos datos ante cualquier tipo de complicación o accidente, cabe mencionar que volveremos a obtener los datos de la última copia de seguridad realizada, por esto, es recomendable realizar copias de seguridad de manera constante para de esta manera una vez al momento de realizar una restauración poder obtener los datos más cercanos al momento del error o inconveniente que se produjo.*/
