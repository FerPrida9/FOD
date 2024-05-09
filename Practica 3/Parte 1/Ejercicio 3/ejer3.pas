program ejer3;
type 
    novela = record 
        codigo: integer;
        genero: string;
        nombre: string;
        duracion: string;
        director: string;
        precio: real;
    end;

    file_novelas = file of novela;

procedure asignar (var arch: file_novelas);
var 
    nombre: string;
begin 
    writeln ('ingrese el nombre que desea ponerle al archivo: ');
    readln (nombre);
    assign (arch, nombre);
end;

procedure inicializarLista (var n: novela);
begin 
    n.codigo := 0;
    n.genero := '';
    n.nombre := '';
    n.duracion := '';
    n.director := '';
    n.precio := 0;
end;

procedure leerNovela (var n: novela);
begin 
    writeln ('ingrese el codigo de la novela: ');
    readln (n.codigo);
    if (n.codigo <> -1) then begin 
        writeln ('ingrese el genero de la novela: ');
        readln (n.genero);
        writeln ('ingrese el nombre de la novela: ');
        readln (n.nombre);
        writeln ('ingrese la duracion de la novela: ');
        readln (n.duracion);
        writeln ('ingrese el director de la novela: ');
        readln (n.director);
        writeln ('ingrese el precio de la novela: ');
        readln (n.precio);
    end;
end;

procedure cargarArchivo (var arch: file_novelas);
var 
    n: novela;
begin 
    rewrite (arch);
    inicializarLista (n);
    write (arch, n);
    writeln ('la lectura finaliza con el codigo -1');
    leerNovela (n);
    while (n.codigo <> -1) do begin 
        write (arch, n);
        leerNovela (n);
    end;
    writeln ('archivo de novelas creado');
    close (arch);
end;

procedure darDeAlta (var arch: file_novelas);
var 
    n, aux: novela;
    pos: integer;
begin 
    reset (arch);    // abro el archivo
    read (arch, aux);  // leo la cabecera
    leerNovela (n);    // leo la novela que voy a agregar
    if (aux.codigo < 0) then begin  // si el codigo de la cabecera es negativo recupero ese espacio
        pos := aux.codigo * -1;     // pos = la posicion dada de baja
        seek (arch, pos);           // me situo en esa posicion
        read (arch, aux);           // leo esa posicion
        seek (arch, filepos(arch) - 1);   // como lei y avance una posicion, vuelvo una posicion para atras para seguir en el mismo lugar
        write (arch, n);   // escribo la nueva novela en esa posicion para recuperar espacio
        seek (arch, 0);    // me posiciono en la cabecera
        write (arch, aux);  // escribo la novela dada de baja en la cabecera
    end 
    else begin   // si el codigo de cabecera no es negativo, entonces agrego la novela al final del archivo 
        seek (arch, filesize(arch));  // me situo al final del archivo
        write (arch, n);   // agrego la novela al final
    end;
    close (arch);
    writeln ('la novela fue agregada correctamente');
end;

procedure modificarNovela (var arch: file_novelas);
var 
    encontre: boolean;
    n, aux: novela;
begin 
    writeln ('ingrese el codigo de la novela que desea modificar: ');
    readln (n.codigo);
    reset (arch);
    encontre := false;
    while (not eof(arch) and (not encontre)) do begin 
        read (arch, aux);
        if (aux.codigo = n.codigo) then begin 
            writeln ('ingrese el nuevo genero de la novela: ');
            readln (n.genero);
            writeln ('ingrese el nuevo nombre de la novela: ');
            readln (n.nombre);
            writeln ('ingrese la nueva duracion de la novela: ');
            readln (n.duracion);
            writeln ('ingrese el nuevo director de la novela: ');
            readln (n.director);
            writeln ('ingrese el nuevo precio de la novela: ');
            readln (n.precio);
            seek (arch, filepos(arch) - 1);
            write (arch, n);
            encontre := true;
        end;
    end;
    if (not encontre) then 
        writeln ('no se encontro una novela con el codigo ingresado');
    close (arch);
end;

procedure darDeBaja (var arch: file_novelas);
var 
    codigo, pos: integer;
    encontre: boolean;
    n, aux: novela;
begin 
    encontre := false;
    writeln ('ingrese el codigo de novela que desea dar de baja: ');
    readln (codigo);
    reset (arch);
    read (arch, aux);   // leo la cabecera
    while (not eof(arch)) and (not encontre) do begin 
        read (arch, n);  // leo novelas
        if (n.codigo = codigo) then begin 
            seek (arch, filepos(arch) - 1);   // me situo en la posicion de la novela a borrar
            write (arch, aux);   // escribo en esa posicion la cabecera actual
            aux.codigo := (filepos(arch)-1) * -1;   // en el campo codigo de la cabecera actual guardo la posicion negativa de la novela borrada
            seek (arch, 0);  // me posiciono en la cabecera
            write (arch, aux);  // escribo la nueva cabecera la cual ahora en el campo codigo tiene el valor negativo de la posicion de la novela borrada
            encontre := true;
        end;
    end;
    if (not encontre) then 
        writeln ('no se encontro una novela con el codigo ingresado')
    else 
        writeln ('la novela de codigo: ', codigo, ' fue eliminada con exito');
    close (arch);
end;

procedure exportarTXT (var arch: file_novelas);
var 
    n: novela;
    txt: text;
begin 
    writeln ('realizando exportacion a "novelas.txt"');
    assign (txt, 'novelas.txt');
    rewrite (txt);
    reset (arch);
    while (not eof(arch)) do begin 
        read (arch, n);
        writeln (txt, 'codigo: ', n.codigo, ' / precio: ', n.precio:0:2, ' / duracion: ', n.duracion);
        writeln (txt, 'genero: ', n.genero);
        writeln (txt, 'nombre: ', n.nombre);
        writeln (txt, 'director: ', n.director);
        writeln (txt, '');
    end;
    close (txt);
    close (arch);
end;

procedure menu (var arch: file_novelas);
var 
    opcion: integer;
begin 
    while true do begin 
        writeln ('ingrese la opcion deseada: ');
        writeln ('1: crear archivo con novelas');
        writeln ('2: dar de alta una novela');
        writeln ('3: modificar datos de una novela');
        writeln ('4: dar de baja una novela');
        writeln ('5: exportar a TXT todas las novelas del archivo');
        writeln ('6: finalizar programa');
        read (opcion);
        case opcion of   
            1: cargarArchivo (arch);
            2: darDeAlta (arch);
            3: modificarNovela (arch);
            4: darDeBaja (arch);
            5: exportarTXT (arch);
            6: break
        end;
    end;
end;

var 
    arch: file_novelas;
begin 
    asignar (arch);
    menu (arch);
end.