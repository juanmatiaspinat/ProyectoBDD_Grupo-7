/*
Combinacion de un procedimiento almacenado con un Backup
*/ 

Create Procedure BK_Base_Consorcio
as
begin

/* 
Aqu� se declara una variable llamada @Fecha con un tipo de datos VARCHAR de longitud 200. Esta variable se 
usar� para almacenar la fecha y hora actual en un formato espec�fico.
*/
DECLARE @Fecha VARCHAR(200)

/*
Aqu� se asigna un valor a la variable @Fecha la cual sera el resultado de la siguiente operacion, la cual convierte a VARCHAR la fecha actual.
*/
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

/*
Se declara una segunda variable llamada @DireccionCarpeta con un tipo de datos VARCHAR de longitud 400. Esta variable se usar� para 
almacenar la ruta del archivo de respaldo de la base de datos.
*/
Declare @DireccionCarpeta Varchar(400)

/*
En esta l�nea,se asigna el valor que tomara la variable @DireccionCarpeta la cual sera la ruta del archivo de respaldo para la base de datos.
*/
Set @DireccionCarpeta = 'F:\Backups SQL Server\Consorcio\Consorcio ' + @Fecha + '.bak'

/*
Esta es la sentencia donde se ejecuta el BACKUP de la base de datos llamada base_consorcio en el archivo especificado 
por la variable @DireccionCarpeta.
*/
BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta

/*
WITH INIT: Indica que se est� realizando una copia de seguridad inicial. Si ya existen copias de seguridad en el archivo de respaldo,
esta opci�n las sobrescribe.
NAME = 'base_consorcio': Aqu� se asigna un nombre a la copia de seguridad.
STATS = 10: Muestra informaci�n de progreso en la operaci�n de copia de seguridad cada vez que se completen 10 porcentajes de la operaci�n.
*/
WITH INIT, NAME = 'base_consorcio', STATS = 10

end

/*
Combinacion de un procedimiento almacenado con un Restore.
Creamos el Procedimiento RDB_SQLTestDB el cual nos permitira ejecutarlo mediante la sentencia "exec RDB_SQLTestDB".
*/
Create Procedure RDB_base_Consorcio2
as
begin

/*
En esta l�nea, se declara una variable llamada @NombreDataBase y se le asigna el valor 'base_consorcio'. Esta variable se utilizar� para especificar el nombre de la base de datos que se va a restaurar.
*/ 
DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';

/*
Se declara otra variable llamada @Ubicacion que se utilizar� para almacenar la ubicaci�n (ruta del archivo) de la �ltima copia de seguridad realizada para la base de datos base_consorcio. Inicialmente, esta variable est� vac�a.
*/
DECLARE @Ubicacion NVARCHAR(128);

/*
Esta consulta se utiliza para recuperar la ubicaci�n del archivo de la ***�ltima copia de seguridad de la base de datos base_consorcio.
*/

/*
Se selecciona la columna physical_device_name de la tabla backupmediafamily, que contiene la ubicaci�n del archivo de copia de seguridad.
Se filtra la consulta para que solo incluya registros donde el nombre de la base de datos (b.database_name) coincide con el valor almacenado en @NombreDataBase (en este caso, 'base_consorcio') y ademas que solo incluyan los archivos con la extension '.bak'.
Los resultados se ordenan por la fecha de inicio de la copia de seguridad (b.backup_start_date) en orden descendente (del m�s reciente al m�s antiguo).
La cl�usula TOP 1 se utiliza para seleccionar solo el primer registro (el m�s reciente) que cumple con las condiciones, y su valor se asigna a la variable @Ubicacion.
*/
SELECT top 1 @ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
/*
AND RIGHT(m.physical_device_name, 4) = '.bak': Esta l�nea agrega otra condici�n al filtro. Utiliza la funci�n RIGHT() para extraer los �ltimos cuatro caracteres de la columna physical_device_name en la tabla backupmediafamily. Luego, compara esos cuatro caracteres con '.bak'. Esto se hace para asegurarse de que la ubicaci�n f�sica del archivo de copia de seguridad termine con '.bak', lo que indica que es un archivo de copia de seguridad con la extensi�n '.bak'.
*/
  AND RIGHT(m.physical_device_name, 4) = '.bak' --
ORDER BY b.backup_start_date DESC;


/*
En esta l�nea, se ejecuta la sentencia de restauraci�n de la base de datos base_consorcio. La restauraci�n se realiza desde el archivo de 
copia de seguridad cuya ubicaci�n se determin� en la consulta anterior y se almacena en la variable @Ubicacion. 
*/
RESTORE DATABASE base_consorcio

/* 
Especifica que la restauraci�n se realiza desde el archivo de copia de seguridad que se encuentra en la ubicaci�n almacenada en @Ubicacion.
*/
FROM DISK = @Ubicacion

/*
Esta opci�n permite reemplazar la base de datos existente con la restaurada.
Esta opci�n coloca la base de datos en estado de recuperaci�n, lo que significa que la base de datos estar� disponible para su uso despu�s
de esta operaci�n.
*/
WITH REPLACE, RECOVERY;

end 

USE base_consorcio2

 Select * From zona

 exec base_consorcio2.dbo.BK_Base_Consorcio

 delete zona where idzona > 6

 Insert into zona(descripcion) values ('algo')

 use master

 exec RDB_base_Consorcio2
