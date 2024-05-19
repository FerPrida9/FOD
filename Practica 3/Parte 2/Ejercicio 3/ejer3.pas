{Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
o inclusive, en diferentes máquinas.}

program ejer3;
const
    dimF = 3;
type 
    sesion = record 
        cod_usuario: integer;
        fecha: string;
        tiempo_sesion: real;
    end;

    archivo = file of sesion;

    vectorD = array[1..dimF] of archivo;

procedure importarDetalle (var det: archivo);
var 
    s: sesion;
    nombre: string;
    txt: text;
begin 
    writeln ('ingrese el nombre del archivo detalle binario: ');
    readln (nombre);
    assign (det, nombre);
    rewrite (det);
    writeln ('ingrese el nombre del archivo detalle.txt');
    readln (nombre);
    assign (txt, nombre);
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, s.cod_usuario, s.tiempo_sesion, s.fecha);
        write (det, s);
    end;
    writeln ('archivo detalle creado');
    close (det);
    close (txt);
end;

procedure cargarVector (var vd: vectorD);
var 
    i: integer;
begin 
    for i:= 1 to dimF do 
        importarDetalle (vd[i]);
end;

procedure crearMaestro (var mae: archivo; var vd: vectorD);
var 
    d, s: sesion;
    encontre: boolean;
    i: integer;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    for i := 1 to dimF do begin 
        reset (vd[i]);
        while (not eof(vd[i])) do begin 
            seek (mae, 0);
            read (vd[i], d);
            encontre := false;
            while (not eof(mae) and (not encontre)) do begin 
                read (mae, s);
                if (s.cod_usuario = d.cod_usuario) then 
                    encontre := true;
            end;
            if (encontre) then begin    
                s.tiempo_sesion := s.tiempo_sesion + d.tiempo_sesion;
                seek (mae, filepos(mae)-1);
                write (mae, s);
            end 
            else 
                write (mae, d);
        end;
        close (vd[i]);
    end;
    writeln ('archivo maestro creado');
    close (mae);
end;

procedure imprimirMaestro (var mae: archivo);
var 
    s: sesion;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, s);
        writeln ('Codigo de usuario: ',s.cod_usuario,' / Fecha: ',s.fecha,' / Tiempo total de sesiones: ',s.tiempo_sesion:0:2);
    end;
    close (mae);
end;

var 
    vd: vectorD;
    mae: archivo;
begin 
    cargarVector (vd);
    crearMaestro (mae, vd);
    imprimirMaestro (mae);
end.