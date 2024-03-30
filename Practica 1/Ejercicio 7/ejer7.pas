{ Realizar un programa que permita:

a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela. 

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela. }

program ejer7;
type 
    tnovela = record
        codigo: integer;
        nombre: string [50];
        genero: string [30];
        precio: real;
    end;

    tarch = file of tnovela;

procedure cargar(var arch: tarch);
var 
    nombre: string;
    txt: Text;
    novela: tnovela;
begin 
    writeln;
    writeln('Cargando datos desde "novelas.txt".');
    write('Ingrese el nombre del archivo binario: ');
    readln(nombre);
    assign(arch, nombre);
    rewrite(arch);
    assign(txt,'novelas.txt');
    reset(txt);
    while (not eof(txt)) do begin 
            readln(txt,novela.codigo,novela.precio,novela.genero);
            readln(txt,novela.nombre);
            write(arch, novela);
        end;
    close(txt);
    close(arch);
end;

procedure leerNovela(var novela: tnovela);
begin 
    writeln;
    write('Ingrese codigo: ');
    readln(novela.codigo);
    write('Ingrese nombre: ');
    readln(novela.nombre);
    write('Ingrese genero: ');
    readln(novela.genero);
    write('Ingrese precio: ');
    readln(novela.precio);
end;

procedure agregarNovela (var arch: tarch);
var 
    novela: tnovela;
    opcion: string [3];
begin 
    reset (arch);
    seek (arch, FileSize(arch));
    leerNovela (novela);
    while true do begin 
        write (arch, novela);
        writeln;
        writeln ('desea agregar otra novela? si / no');
        readln (opcion);
        if opcion = 'no' then
            Break
        else
            leerNovela (novela);
    end;
    close (arch);
end;

procedure modificarNovela (var arch: tarch);
var 
    found: boolean;
    novela: tnovela;
    codigo: integer;
begin 
    found := false;
    reset (arch);
    writeln ('ingrese el codigo de la novela que desea modificar: ');
    readln (codigo);
    while (not eof (arch)) do begin 
        read(arch, novela);
        if (novela.codigo = codigo) then begin 
            found := true;
            break;
        end;
    end;
    if (found) then begin 
        writeln ('ingrese los nuevos datos de la novela: ');
        leerNovela (novela);
        seek (arch, Filepos (arch) - 1);
        write (arch, novela);
    end 
    else begin 
        writeln ('no se encontro ninguna novela con codigo ', codigo);
    end;
    close (arch);
end;

procedure imprimirNovela(novela: tnovela);
begin 
    writeln ('codigo: ',novela.codigo,'/ nombre: ',novela.nombre,'/ genero: ',novela.genero,'/ precio: ',novela.precio:0:2);
end;

procedure mostrarNovelas (var arch: tarch);
var
    novela: tnovela;
begin 
    reset (arch);
    writeln;
    writeln ('las novelas cargadas son: ');
    while (not eof (arch)) do begin 
        read(arch, novela);
        imprimirNovela (novela);
    end;
    close (arch)
end;

procedure runMenu (var arch: tarch);
var 
    opcion: integer;
begin 
    while (true) do begin 
        writeln;
        writeln ('ingrese la opcion deseada: ');
        writeln ('1: cargar el archivo binario');
        writeln ('2: agregar novela');
        writeln ('3: modificar novela');
        writeln ('4: mostrar novelas cargadas');
        writeln ('5: finalizar programa');
        read (opcion);
        case opcion of
            1: cargar (arch);
            2: agregarNovela (arch);
            3: modificarNovela (arch);
            4: mostrarNovelas (arch);
            5: break 
        end;
    end;
end;

var 
    arch: tarch;
begin 
    cargar (arch);
    runMenu (arch);
end. 
