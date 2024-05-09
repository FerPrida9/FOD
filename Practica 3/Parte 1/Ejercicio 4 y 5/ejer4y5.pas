{Dada la siguiente estructura:
type
    reg_flor = record
    nombre: String[45];
    codigo:integer;
    end;

tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.

5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente }


program ejer4y5;
type 
    reg_flor = record 
        nombre: string[45];
        codigo: integer;
    end;

    archFlores = file of reg_flor;

procedure agregarFlor (var arch: archFlores; nombre: string; codigo: integer);
var 
    f, cabecera: reg_flor;
begin 
    reset (arch);
    read (arch, cabecera);
    f.nombre := nombre;
    f.codigo := codigo;
    if (cabecera.codigo = 0) then begin // si el codigo de la cabecera es 0, entonces agrego la flor al final del archivo
        seek (arch, filesize(arch));
        write (arch, f);
    end 
    else begin // si no es 0
        seek (arch, cabecera.codigo * -1);  // me situo en la posicion borrada del archivo
        read (arch, cabecera);   // leo el registro de esa posicion
        seek (arch, filepos(arch) - 1);  // me situo nuevamente ya que al leer el puntero se corre
        write (arch, f);  // escribo en esa posicion la nueva flor
        seek (arch, 0);   // me situo en la cabecera
        write (arch, cabecera);  // escribo como cabecera el registro borrado
    end;
    writeln ('Se realizo con exito el alta de la flor ', f.nombre);
    close (arch);
end;

procedure imprimirFlores (var arch: archFlores);
var 
    f: reg_flor;
begin 
    reset (arch);
    while (not eof(arch)) do begin 
        read (arch, f);
        if (f.codigo > 0) then 
            writeln ('Flor: ', f.nombre, ' / Codigo: ', f.codigo);
    end;
    writeln ('');
    close (arch);
end;

procedure eliminarFlor (var arch: archFlores; flor: reg_flor);
var 
    cabecera, f: reg_flor;
    encontre: boolean;
begin 
    reset (arch);
    encontre := false;
    read (arch, cabecera);
    while (not eof(arch) and (not encontre)) do begin 
        read (arch, f);
        if (f.codigo = flor.codigo) then begin 
            seek (arch, filepos(arch) - 1);  // me situo en la posicion de la flor a eliminar
            write (arch, cabecera);   // copio la cabecera actual en esa posicion
            cabecera.codigo := (filepos(arch)-1) * -1;  // en el campo codigo de la cabecera pongo el valor negativo de la posicion que borre
            seek (arch, 0);   // me situo en la cabecera
            write (arch, cabecera);  // copio la cabecera nueva
            encontre := true;
        end;
    end;
    if (not encontre) then 
        writeln ('el codigo de flor: ', flor.codigo, ' no se encuentra en el archivo')
    else 
        writeln ('la flor de codigo: ', flor.codigo, ' fue eliminada exitosamente');
    close (arch);
end;

procedure leerFlor (var f: reg_flor);
begin 
    writeln ('ingrese el codigo de la flor: ');
    readln (f.codigo);
    if (f.codigo <> -1) then begin 
        writeln ('ingrese el nombre de la flor: ');
        readln (f.nombre);
    end;
end;

procedure crearArchivo (var arch: archFlores);
var 
    f: reg_flor;
begin 
    assign (arch, 'flores.dat');
    rewrite (arch);
    f.codigo := 0;
    f.nombre := '';
    write (arch, f);
    writeln ('ingrese las flores que desea agregar al archivo (-1 en campo codigo para finalizar lectura)');
    leerFlor (f);
    while (f.codigo <> - 1) do begin 
        write (arch, f);
        leerFlor (f);
    end;
    writeln ('archivo creado');
    close (arch);
end;

var 
    arch: archFlores;
    f: reg_flor;
begin 
    crearArchivo (arch);
    imprimirFlores (arch);
    agregarFlor (arch, 'tulipan', 10);
    imprimirFlores (arch);
    f.codigo := 2;
    eliminarFlor (arch, f);
    imprimirFlores (arch);
    agregarFlor (arch, 'rosa', 5);
    imprimirFlores (arch);
end.