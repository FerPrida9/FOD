{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

program ejer7;
const   
    dimF = 3;    // 10
    valorAlto = 9999;
type 
    registroDetalle = record
        codLocalidad: integer;
        codCepa: integer;
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;

    registroMaestro =  record
        codLocalidad: integer;
        nomLocalidad: string[50];
        codCepa: integer;
        nomCepa: string[50];
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;

    rango = 1..dimF;

    maestro = file of registroMaestro;
    detalle = file of registroDetalle;

    vectorD = array[rango] of detalle;
    vectorR = array[rango] of registroDetalle;

procedure importarMaestro (var mae: maestro);
var
    regM: registroMaestro;
    txt: text;
begin 
    writeln ('Creando archivo maestro: ');
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regM.codLocalidad, regM.codCepa, regM.cantActivos, regM.cantNuevos, regM. cantRecuperados, regM.cantFallecidos, regM.nomCepa);
        readln (txt, regM.nomLocalidad);
        write (mae, regM);
    end;
    writeln ('Archivo maestro creado');
    close (mae);
    close (txt);
end;

procedure importarDetalle (var det: detalle);
var 
    nombre: string[50];
    txt: text;
    regD: registroDetalle;
begin 
    writeln ('Creando archivo detalle');
    writeln ('Ingrese el nombre que desea ponerle al archivo detalle binario: ');
    readln (nombre);
    assign (det, nombre);
    rewrite (det);
    writeln ('Ingrese el nombre del archivo detalle .txt');
    readln (nombre);
    assign (txt, nombre);
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regD.codLocalidad, regD.codCepa, regD.cantActivos, regD.cantNuevos, regD.cantRecuperados, regD.cantFallecidos);
        write (det, regD);
    end;
    writeln ('Archivo detalle creado');
    close (det);
    close (txt);
end;

procedure cargarVectorD (var vd: vectorD);
var 
    i: rango;
begin 
    for i:= 1 to dimF do
        importarDetalle (vd[i]);
end;

procedure leer (var det: detalle; var regD: registroDetalle);
begin 
    if (not eof(det)) then 
        read (det, regD)
    else 
        regD.codLocalidad := valorAlto;
end;

procedure minimo (var vd: vectorD; var vr: vectorR; var min: registroDetalle);
var     
    i, pos: integer;
begin 
    min.codLocalidad := valorAlto;
    min.codCepa := valorAlto;
    for i := 1 to dimF do begin 
        if (vr[i].codLocalidad <= min.codLocalidad) and (vr[i].codCepa <= min.codCepa) then begin 
            min := vr[i];
            pos := i;
        end;
    end;
    if (min.codLocalidad <> valorAlto) then 
        leer (vd[pos], vr[pos]);
end;

procedure actualizarMaestro (var mae: maestro; var vd: vectorD);
var 
    actual: registroMaestro;
    cantCasosLoc, cant, codigoLoc, codigoCepa: integer;
    min: registroDetalle;
    i: rango;
    vr: vectorR;
begin 
    cant := 0;
    reset (mae);
    read (mae, actual);
    for i := 1 to dimF do begin 
        reset (vd[i]);
        leer (vd[i], vr[i]);
    end;
    minimo (vd, vr, min);
    while (min.codLocalidad <> valorAlto) do begin 
        while (min.codLocalidad <> actual.codLocalidad) do 
            read (mae, actual);                             // si sale de este loop es pq las localidades son iguales
        while (min.codLocalidad <> valorAlto) and (min.codLocalidad = actual.codLocalidad) do begin 
            while (min.codCepa <> actual.codCepa) do
                read (mae, actual);                         // busco la cepa del registro maestro que estoy procesando
            while (min.codLocalidad <> valorAlto) and (min.codLocalidad = actual.codLocalidad) do begin 
                actual.cantActivos := min.cantActivos;
                actual.cantNuevos := min.cantNuevos;
                actual.cantRecuperados := actual.cantRecuperados + min.cantRecuperados;
                actual.cantFallecidos := actual.cantFallecidos + min.cantFallecidos;
                minimo (vd, vr, min);
            end;
            seek (mae, filepos(mae) - 1);
            write (mae, actual);
        end;
    end;
    writeln ('Archivo maestro actualizado');
    close (mae);
    for i := 1 to dimF do 
        close (vd[i]);
end;

procedure imprimirReg (r: registroMaestro);
begin 
    writeln ('Codigo de localidad: ', r.codLocalidad, ' / Nombre de localidad: ', r.nomLocalidad, ' / Codigo de cepa: ', r.codCepa, ' / Nombre de la cepa: ', r.nomCepa, 
    ' / Cantidad de casos activos: ', r.cantActivos, ' / Cantidad de casos nuevos: ', r.cantNuevos, ' / Cantidad de casos recuperados: ', r.cantRecuperados, ' / Cantidad de fallecidos: ', r.cantFallecidos);
    writeln;
end;

procedure imprimirMaestro (var mae: maestro);
var 
    regM: registroMaestro;
    cantLocalidades: integer;
begin 
    reset (mae);
    cantLocalidades := 0;
    while (not eof(mae)) do begin 
        read (mae, regM);
        imprimirReg (regM);
        if (regM.cantActivos > 50) then 
            cantLocalidades := cantLocalidades + 1;
    end;
    writeln ('Cantidad de localidades con mas de 50 casos activos: ', cantLocalidades);
    close (mae);
end;

var 
    mae: maestro;
    vd: vectorD;
begin 
    importarMaestro (mae);
    cargarVectorD (vd);
    actualizarMaestro (mae, vd);
    imprimirMaestro (mae);
end.
