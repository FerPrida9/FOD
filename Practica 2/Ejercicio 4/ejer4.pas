program ejer4;
const 
    valorAlto = 'ZZZZ';
type 
    archMaestro = record
        cantPersonas: integer;
        totalPersonas: integer;
        provincia: string[50]
    end;

    archDetalle = record
        codigo: integer;
        cantPersonas: integer;
        totalPersonas: integer;
        provincia: string[50];
    end;

    maestro = file of archMaestro;
    detalle = file of archDetalle;

procedure importarMaestro (var mae: maestro);
var 
    txt: text;
    regM: archMaestro;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regM.cantPersonas, regM.totalPersonas, regM.provincia);
        write (mae, regM);
    end;
    writeln ('archivo maestro creado con exito');
    close (mae);
    close (txt);
end; 

procedure importarDetalle (var det: detalle; ruta: string);
var 
    txt2: text;
    regD: archDetalle;
begin 
    rewrite (det);
    assign (txt2, ruta);
    reset (txt2);
    while (not eof(txt2)) do begin 
        readln (txt2, regD.codigo, regD.cantPersonas, regD.totalPersonas, regD.provincia);
        write (det, regD);
    end;
    writeln ('archivo detalle creado con exito');
    close (det);
    close (txt2);
end;

procedure leer (var det: detalle; var regD: archDetalle);
begin 
    if (not eof(det)) then  
        read (det, regD)
    else
        regD.provincia := valorAlto;
end;

procedure minimo (var det1, det2: detalle; var r1, r2, min: archDetalle);
begin 
    if (r1.provincia <= r2.provincia) then begin 
        min := r1;
        leer (det1, r1);
    end 
    else begin 
        min := r2;
        leer (det2, r2);
    end; 
end;

procedure actualizarMaestro (var mae: maestro; var det1, det2: detalle);
var 
    regM: archMaestro;
    regD1, regD2, min: archDetalle;
begin 
    reset (mae);
    reset (det1);
    reset (det2);
    leer (det1, regD1);
    leer (det2, regD2);
    minimo (det1, det2, regD1, regD2, min);
    while (min.provincia <> valorAlto) do begin 
        read (mae, regM);
        while (regM.provincia <> min.provincia) do begin 
            read (mae, regM);
        end;
        while (regM.provincia = min.provincia) do begin 
            regM.cantPersonas := regM.cantPersonas + min.cantPersonas;
            regM.totalPersonas := regM.totalPersonas + min.totalPersonas;
            minimo (det1, det2, regD1, regD2, min);
        end;
        seek (mae, FilePos(mae) - 1);
        write (mae, regM);
    end;
    writeln ('maestro actualizado con exito');
    close (mae);
    close (det1);
    close (det2);
end;

procedure informar (regM: archMaestro);
begin 
    writeln('nombre de provincia: ', regM.provincia, ' / Cantidad de personas alfabetizadas ', regM.cantPersonas, ' / total de encuestados ', regM.totalPersonas);
end;

procedure informarMaestroActualizado (var mae: maestro);
var 
    regM: archMaestro;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, regM);
        informar (regM);
    end;
end;

var 
    mae: maestro;
    det1, det2: detalle;
begin 
    importarMaestro (mae);
    assign (det1, 'detalle1.dat');
    assign (det2, 'detalle2.dat');
    importarDetalle (det1, 'detalle1.txt');
    importarDetalle (det2, 'detalle2.txt');
    actualizarMaestro (mae, det1, det2);
    informarMaestroActualizado (mae);
end.