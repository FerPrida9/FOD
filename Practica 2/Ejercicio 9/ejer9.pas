{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.

NOTA: La información está ordenada por código de provincia y código de localidad.}

program ejer9;
const
    valorAlto = 9999;
type
    registroMaestro = record 
        codProv: integer;
        codLoc: integer;
        numMesa: integer;
        cantVotos: integer;
    end;

    maestro = file of registroMaestro;

procedure importarMaestro (var mae: maestro);
var 
    txt: text;
    regM: registroMaestro;
begin 
    writeln ('Creando archivo maestro');
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regM.codProv, regM.codLoc, regM.numMesa, regM.cantVotos);
        write (mae, regM);
    end;
    writeln ('Archivo maestro creado');
    close (txt);
    close (mae);
end;

procedure leer (var mae: maestro; var reg: registroMaestro);
begin 
    if (not eof(mae)) then 
        read (mae, reg)
    else 
        reg.codProv := valorAlto;
end;

procedure procesarMaestro (var mae: maestro);
var 
    regM: registroMaestro;
    totalGeneral, totalProv, totalLoc, codigoProv, codigoLoc: integer;
begin 
    reset (mae);
    leer (mae, regM);
    totalGeneral := 0;
    while (regM.codProv <> valorAlto) do begin 
        writeln ('Codigo de provincia: ', regM.codProv);
        codigoProv := regM.codProv;
        totalProv := 0;
        while (codigoProv = regM.codProv) do begin 
            writeln ('Codigo de localidad: ', regM.codLoc);
            codigoLoc := regM.codLoc;
            totalLoc := 0;
            while (codigoProv = regM.codProv) and (codigoLoc = regM.codLoc) do begin 
                totalLoc := totalLoc + regM.cantVotos;
                leer (mae, regM);
            end;
            writeln ('Total de votos de la localidad de ', codigoLoc, ': ', totalLoc);
            totalProv := totalProv + totalLoc;
        end;
        writeln ('Total de votos de la provincia de ', codigoProv, ': ', totalProv);
        totalGeneral := totalGeneral + totalProv;
    end;
    writeln ('Total general de votos: ', totalGeneral);
    close (mae);
end;

var 
    mae: maestro;
begin 
    importarMaestro (mae);
    procesarMaestro (mae);
end.