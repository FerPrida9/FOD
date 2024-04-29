{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

program ejer8;
const
    valorAlto = 9999;
type
    Mrango = 1..12;
    Drango = 1..31;

    registroMaestro = record
        codigo: integer;
        nombre: string;
        apellido: string;
        anio: integer;
        mes: Mrango;
        dia: Drango;
        monto: real;
    end;

    data = record
        codigo: integer;
        anio: integer;
        mes: Mrango;
    end;

    maestro = file of registroMaestro;

procedure importarMaestro (var mae: maestro);
var 
    txt: text;
    regM: registroMaestro;
begin
    writeln ('Creando archivo maestro');
    assign (txt, 'maestro.txt');
    reset (txt);
    assign (mae, 'maestro.dat');
    rewrite (mae);
    while (not eof(txt)) do begin 
        readln (txt, regM.codigo, regM.anio, regM.mes, regM.dia, regM.monto, regM.nombre);
        readln (txt, regM.apellido);
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
        reg.codigo := valorAlto;
end;

procedure procesarMaestro (var mae: maestro);
var 
    regM: registroMaestro;
    totalEmpresa, totalAnio, totalMes: real;
    dato: data;
begin 
    reset (mae);
    leer (mae, regM);
    totalEmpresa := 0;
    while (regM.codigo <> valorAlto) do begin 
        writeln ('Codigo de cliente: ', regM.codigo, ' / Nombre: ', regM.nombre, ' / Apellido: ', regM.apellido);
        dato.codigo := regM.codigo;
        while (dato.codigo = regM.codigo) do begin 
            writeln ('Anio: ', regM.anio);
            dato.anio := regM.anio;
            totalAnio := 0;
            while (regM.codigo = dato.codigo) and (regM.anio = dato.anio) do begin 
                dato.mes := regM.mes;
                totalMes := 0;
                while (regM.codigo = dato.codigo) and (regM.mes = dato.mes) do begin 
                    totalMes := totalMes + regM.monto;
                    leer (mae, regM);
                end;
                if (totalMes <> 0) then begin 
                    totalAnio := totalAnio + totalMes;
                    writeln ('Total del mes de ', dato.mes, ': ', totalMes:0:2);
                end;
            end;
            writeln ('Total del anio ', dato.anio, ': ', totalAnio:0:2);
            totalEmpresa := totalEmpresa + totalAnio;
        end;
    end;
    writeln ('Total de la empresa: ', totalEmpresa:0:2);
    close (mae);
end;

var
    mae: maestro;
begin
    importarMaestro (mae);
    procesarMaestro (mae);
end.