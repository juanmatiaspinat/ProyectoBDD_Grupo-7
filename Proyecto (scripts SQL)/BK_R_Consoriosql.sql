/*
Combinacion de un procedimiento almacenado con un Backup
*/ 

Create Procedure BK_Base_Consorcio
as
begin

/* 
Aquí se declara una variable llamada @Fecha con un tipo de datos VARCHAR de longitud 200. Esta variable se 
usará para almacenar la fecha y hora actual en un formato específico.
*/
DECLARE @Fecha VARCHAR(200)

/*
Aquí se asigna un valor a la variable @Fecha la cual sera el resultado de la siguiente operacion, la cual convierte a VARCHAR la fecha actual.
*/
SET @Fecha = REPLACE(CONVERT(VARCHAR,GETDATE(),100), ':', '.')

/*
Se declara una segunda variable llamada @DireccionCarpeta con un tipo de datos VARCHAR de longitud 400. Esta variable se usará para 
almacenar la ruta del archivo de respaldo de la base de datos.
*/
Declare @DireccionCarpeta Varchar(400)

/*
En esta línea,se asigna el valor que tomara la variable @DireccionCarpeta la cual sera la ruta del archivo de respaldo para la base de datos.
*/
Set @DireccionCarpeta = 'F:\Backups SQL Server\Consorcio\Consorcio ' + @Fecha + '.bak'

/*
Esta es la sentencia donde se ejecuta el BACKUP de la base de datos llamada base_consorcio en el archivo especificado 
por la variable @DireccionCarpeta.
*/
BACKUP DATABASE base_consorcio
TO DISK =  @DireccionCarpeta

/*
WITH INIT: Indica que se está realizando una copia de seguridad inicial. Si ya existen copias de seguridad en el archivo de respaldo,
esta opción las sobrescribe.
NAME = 'base_consorcio': Aquí se asigna un nombre a la copia de seguridad.
STATS = 10: Muestra información de progreso en la operación de copia de seguridad cada vez que se completen 10 porcentajes de la operación.
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
En esta línea, se declara una variable llamada @NombreDataBase y se le asigna el valor 'base_consorcio'. Esta variable se utilizará para especificar el nombre de la base de datos que se va a restaurar.
*/ 
DECLARE @NombreDataBase VARCHAR(200) = 'base_consorcio';

/*
Se declara otra variable llamada @Ubicacion que se utilizará para almacenar la ubicación (ruta del archivo) de la última copia de seguridad realizada para la base de datos base_consorcio. Inicialmente, esta variable está vacía.
*/
DECLARE @Ubicacion NVARCHAR(128);

/*
Esta consulta se utiliza para recuperar la ubicación del archivo de la ***última copia de seguridad de la base de datos base_consorcio.
*/

/*
Se selecciona la columna physical_device_name de la tabla backupmediafamily, que contiene la ubicación del archivo de copia de seguridad.
Se filtra la consulta para que solo incluya registros donde el nombre de la base de datos (b.database_name) coincide con el valor almacenado en @NombreDataBase (en este caso, 'base_consorcio') y ademas que solo incluyan los archivos con la extension '.bak'.
Los resultados se ordenan por la fecha de inicio de la copia de seguridad (b.backup_start_date) en orden descendente (del más reciente al más antiguo).
La cláusula TOP 1 se utiliza para seleccionar solo el primer registro (el más reciente) que cumple con las condiciones, y su valor se asigna a la variable @Ubicacion.
*/
SELECT top 1 @ubicacion = m.physical_device_name
FROM msdb.dbo.backupset AS b
JOIN msdb.dbo.backupmediafamily AS m ON b.media_set_id = m.media_set_id
WHERE b.database_name = @NombreDataBase
/*
AND RIGHT(m.physical_device_name, 4) = '.bak': Esta línea agrega otra condición al filtro. Utiliza la función RIGHT() para extraer los últimos cuatro caracteres de la columna physical_device_name en la tabla backupmediafamily. Luego, compara esos cuatro caracteres con '.bak'. Esto se hace para asegurarse de que la ubicación física del archivo de copia de seguridad termine con '.bak', lo que indica que es un archivo de copia de seguridad con la extensión '.bak'.
*/
  AND RIGHT(m.physical_device_name, 4) = '.bak' --
ORDER BY b.backup_start_date DESC;


/*
En esta línea, se ejecuta la sentencia de restauración de la base de datos base_consorcio. La restauración se realiza desde el archivo de 
copia de seguridad cuya ubicación se determinó en la consulta anterior y se almacena en la variable @Ubicacion. 
*/
RESTORE DATABASE base_consorcio

/* 
Especifica que la restauración se realiza desde el archivo de copia de seguridad que se encuentra en la ubicación almacenada en @Ubicacion.
*/
FROM DISK = @Ubicacion

/*
Esta opción permite reemplazar la base de datos existente con la restaurada.
Esta opción coloca la base de datos en estado de recuperación, lo que significa que la base de datos estará disponible para su uso después
de esta operación.
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
