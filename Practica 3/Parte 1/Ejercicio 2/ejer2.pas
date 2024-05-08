{Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’}

program ejer2;

type 
    asistente = record 
        numero: integer;
        apellido: string;
        nombre: string;
        email: string;
        telefono: integer;
        DNI: integer;
    end;

    file_asistentes = file of asistente;

procedure leerAsistente (var a: asistente);
begin 
    writeln ('ingrese el numero de asistente: ');
    readln (a.numero);
    writeln ('ingrese el apellido del asistente: ');
    readln (a.apellido);
    if (a.apellido <> 'fin') then begin 
        writeln ('ingrese el nombre del asistente: ');
        readln (a.nombre);
        writeln ('ingrese el email del asistente: ');
        readln (a.email);
        writeln ('ingrese el numero de telefono del asistente: ');
        readln (a.telefono);
        writeln ('ingrese el DNI del asistente: ');
        readln (a.DNI);
    end;
end;

procedure cargar (var arch: file_asistentes);
var 
    nombre: string;
    asis: asistente;
begin 
    writeln ('Ingrese el nombre que desea ponerle al archivo: ');
    read (nombre);
    assign (arch, nombre);
    rewrite (arch);
    leerAsistente (asis);
    while (asis.apellido <> 'fin') do begin 
        write (arch, asis);
        leerAsistente (asis);
    end;
    writeln ('Archivo creado con exito');
    close (arch);
end;

procedure eliminar (var arch: file_asistentes);
var 
    a: asistente;
begin 
    writeln ('Eliminando del archivo todos los asistentes con numero menor a 1000');
    writeln ('El eliminado se realizara agregando "@" al principio del nombre del asistente');
    reset (arch);
    while (not eof(arch)) do begin
        read (arch, a);
        if (a.numero < 1000) then begin
            a.nombre := '@' + a.nombre;
            seek (arch, filepos(arch) - 1);
            write (arch, a);
        end;
    end;
    writeln ('Asistentes eliminados con exito');
    close (arch);
end;

procedure mostrarAsistente (var a: asistente);
begin 
    writeln ('numero: ', a.numero);
    writeln ('apellido: ', a.apellido);
    writeln ('nombre: ', a.nombre);
    writeln ('email: ', a.email);
    writeln ('telefono: ', a.telefono);
    writeln ('DNI: ', a.dni);
end;

procedure imprimir (var arch: file_asistentes);
var 
    a: asistente;
begin 
    writeln ('Los asistentes guardados en el archivo son: ');
    reset (arch);
    while (not eof(arch)) do begin 
        read (arch, a);
        mostrarAsistente (a);
    end;
    close (arch);
end;

var 
    arch: file_asistentes;
begin 
    cargar (arch);
    eliminar (arch);
    imprimir (arch);
end.