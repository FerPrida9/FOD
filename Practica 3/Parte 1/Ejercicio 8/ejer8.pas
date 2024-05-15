{Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.

b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.

c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
}

program ejer8;
type 
    distribucion = record 
        nombre: string;
        anio: integer;
        versionKernel: string;
        cantDesarrolladores: integer;
        descripcion: string;
    end;

    maestro = file of distribucion;

function existeDistribucion (var mae: maestro; nom: string): boolean;
var 
    d: distribucion;
    found: boolean;
begin 
    found := false;
    while (not eof(mae) and (not found)) do begin 
        read (mae, d);
        if (d.nombre = nom) then 
            found := true;
    end;
    existeDistribucion := found;
end;

procedure leerDistribucion (var d: distribucion);
begin 
    writeln ('ingrese el nombre de la distribucion: ');
    readln (d.nombre);
    if (d.nombre <> 'fin') then begin 
        writeln ('ingrese el anio de la distribucion: ');
        readln (d.anio);
        writeln ('ingrese la version del kernel de la distribucion: ');
        readln (d.versionKernel);
        writeln ('ingrese la cantidad de desarrolladores de la distribucion: ');
        readln (d.cantDesarrolladores);
        writeln ('ingrese la descripcion de la distribucion: ');
        readln (d.descripcion);
    end;
end;

procedure altaDistribucion (var mae: maestro);
var 
    d, aux: distribucion;
    existe: boolean;
begin 
    reset (mae);
    writeln ('ingrese los datos de la distribucion que desea agregar al archivo: ');
    leerDistribucion (d);
    existe := existeDistribucion (mae, d.nombre);
    if (existe) then 
        writeln ('La distribucion ingresada ya existe')
    else begin 
        seek (mae, 0);
        read (mae, aux);
        if (aux.cantDesarrolladores = 0) then begin 
            seek (mae, filesize(mae));
            write (mae, d);
        end 
        else begin 
            seek (mae, aux.cantDesarrolladores * -1);
            read (mae, aux);
            seek (mae, filepos(mae)-1);
            write (mae, d);
            seek (mae, 0);
            write (mae, aux);
        end;
        writeln ('distribucion agregada con exito');
    end;
    close (mae);
end;

procedure bajaDistribucion (var mae: maestro);
var 
    nom: string;
    aux: distribucion;
    existe: boolean;
begin 
    reset (mae);
    writeln ('Ingrese el nombre de la distribucion que desea eliminar: ');
    readln (nom);
    read (mae, aux);
    existe := existeDistribucion (mae, nom);
    if (existe) then begin  
        seek (mae, filepos(mae) - 1);
        write (mae, aux); 
        aux.cantDesarrolladores := (filepos(mae) - 1) * - 1;
        seek (mae, 0);
        write (mae, aux);
        writeln ('distribucion eliminada con exito');
    end 
    else begin 
        writeln ('La distribucion que desea eliminar no existe');
    end;
    close (mae);
end;

procedure crearArchivo (var mae: maestro);
var 
    d: distribucion;
begin 
    assign (mae, 'distribuciones.dat');
    rewrite (mae);
    d.nombre := '';
    d.anio := 0;
    d.versionKernel := '';
    d.cantDesarrolladores := 0;
    d.descripcion := '';
    write (mae, d);
    leerDistribucion (d);
    while (d.nombre <> 'fin') do begin 
        write (mae, d);
        leerDistribucion (d);
    end;
    close (mae);
    writeln ('archivo creado');
end;

procedure imprimirArchivo (var mae: maestro);
var     
    d: distribucion;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, d);
        writeln ('Nombre: ', d.nombre,' / Anio: ', d.anio, ' / Version kernel: ', d.versionKernel, ' / Cantidad de desarrolladores: ', d.cantDesarrolladores, ' / Descripcion: ',d.descripcion);
    end;
    close (mae);
end;

var 
    mae: maestro;
begin 
    crearArchivo (mae);
    writeln ('archivo original: ');
    imprimirArchivo (mae);
    bajaDistribucion (mae);
    writeln ('-------------');
    writeln ('archivo despues de la baja: ');
    imprimirArchivo (mae);
    altaDistribucion (mae);
    writeln ('--------------');
    writeln ('archivo despues del alta: ');
    imprimirArchivo (mae);
end.