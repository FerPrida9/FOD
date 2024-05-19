{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:

Código de Localidad Total de Votos
..................   ......................
..................   ......................
Total General de Votos: ………………

NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}

program ejer2;
type 
    localidad = record 
        codigo: integer;
        numMesa: integer;
        votos: integer;
    end;

    archivo = file of localidad;

procedure importarArchivo (var mae: archivo);
var 
    txt: text;
    l: localidad;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, l.codigo, l.numMesa, l.votos);
        write (mae, l);
    end;
    writeln ('archivo maestro creado');
    close (mae);
    close (txt);
end;

procedure crearAuxiliar (var mae, newFile: archivo; var cantTotal: integer);
var 
    l, aux: localidad;
    encontre: boolean;
begin 
    cantTotal := 0;
    reset (mae);
    assign (newFile, 'archivo_auxiliar');
    rewrite (newfile);
    while (not eof(mae)) do begin 
        read (mae, l);
        seek (newFile, 0);
        encontre := false;
        while (not eof(newFile) and (not encontre)) do begin 
            read (newFile, aux);
            if (l.codigo = aux.codigo) then 
                encontre := true;
        end;
        if (encontre) then begin 
            seek (newFile, filepos(newFile) - 1);
            aux.votos := aux.votos + l.votos;
            write (newFile, aux);
        end 
        else 
            write (newFile, l);
        cantTotal := cantTotal + l.votos;
    end;
    writeln ('archivo auxiliar creado');
    close (mae);
    close (newFile);
end;

procedure imprimirArchivo (var arch: archivo; cantTotal: integer);
var 
    l: localidad;
begin 
    reset (arch);
    writeln ('Codigo de localidad         Total de votos');
    while (not eof(arch)) do begin 
        read (arch, l);
        writeln (l.codigo,'                           ', l.votos);
    end;
    close (arch);
end;

var 
    mae, newFile: archivo;
    cantTotal: integer;
begin 
    importarArchivo (mae);
    crearAuxiliar (mae, newFile, cantTotal);
    imprimirArchivo (newFile, cantTotal);
end.