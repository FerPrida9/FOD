{Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ejer7;
type 
    ave = record 
        codigo: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zonaGeografica: string;
    end;

    maestro = file of ave;

procedure importarMaestro (var mae: maestro);
var 
    a: ave;
    txt: Text;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, a.codigo, a.nombre);
        readln (txt, a.familia);
        readln (txt, a.descripcion);
        readln (txt, a.zonaGeografica);
        write (mae, a);
    end;
    writeln ('archivo maestro binario creado');
    close (mae);
    close (txt);
end;

procedure borradoLogico (var mae: maestro);
var 
    cod: integer;
    found: boolean;
    a: ave;
begin 
    reset (mae);
    writeln ('Ingrese los codigos de ave que desea borrar (finaliza con codigo 5000)');
    read (cod);
    while (cod <> 5000) do begin 
        seek (mae, 0);
        found := false;
        while (not eof(mae) and (not found)) do begin 
            read (mae, a);
            if (a.codigo = cod) then 
                found := true;
        end;
        if (found) then begin 
            seek (mae, filepos(mae)-1);
            a.codigo := -1;
            write (mae, a);
        end 
        else begin
            writeln ('el codigo ingresado no se encuentra en el archivo, intente nuevamente')
        end;
        readln (cod);
    end;
    writeln ('borrados logicos realizados con exito');
    close (mae);
end;

procedure compactarMaestro (var mae: maestro);
var 
    a: ave;
    pos: integer;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, a);
        if (a.codigo < 0) then begin 
            pos := filepos(mae) - 1;
            seek (mae, filesize(mae) - 1);
            read (mae, a);
            seek (mae, pos);
            write (mae, a);
            seek (mae, filesize(mae) - 1);
            truncate (mae);
            seek (mae, pos);
        end;
    end;
    writeln ('borrados fisicos realizados con exito');
    close (mae);
end;

procedure imprimirMaestro (var mae: maestro);
var 
    a: ave;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, a);
        writeln ('Codigo: ',a.codigo,' / Nombre: ',a.nombre,' / Familia: ',a.familia,' / Descripcion: ',a.descripcion,' / Zona geografica: ',a.zonaGeografica);
    end;
    close (mae);
end;

var 
    mae: maestro;
begin 
    importarMaestro (mae);
    writeln ('Maestro antes del borrado: ');
    imprimirMaestro (mae);
    writeln ('------------------');
    borradoLogico (mae);
    writeln ('Maestro despues del borrado logico: ');
    imprimirMaestro (mae);
    writeln ('-------------------');
    compactarMaestro (mae);
    writeln ('Maestro despues del borrado fisico: ');
    imprimirMaestro (mae);
end.