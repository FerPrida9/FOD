{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log}

program ejer6;
const
    dimF = 3;  // 5
    valorAlto = 9999;
type 
    rango = 1..dimF;

    sesion = record
        codigo: integer;
        fecha: string[30];
        tiempo: real;
    end;

    maestro = file of sesion;
    detalle = file of sesion;

    vectorD = array[rango] of detalle;
    vectorR = array[rango] of sesion;

var 
    mae: maestro;
    vd: vectorD;

procedure importarDetalle (var det: detalle);
var 
    txt: text;
    regD: sesion;
    nombre: string;
begin 
    writeln ('Ingrese el nombre del archivo detalle binario: ');
    readln (nombre);
    assign (det, nombre);
    rewrite (det);
    writeln ('Ingrese el nombre del archivo detalle .txt: ');
    readln (nombre);
    assign (txt, nombre);
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regD.codigo, regD.tiempo, regD.fecha);
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
    for i := 1 to dimF do 
        importarDetalle (vd[i]);
end;

procedure leer (var det: detalle; var regD: sesion);
begin 
    if (not eof(det)) then 
        read (det, regD)
    else
        regD.codigo := valorAlto;
end;

procedure minimo (var vd: vectorD; var vr: vectorR; var min: sesion);
var 
    i, pos: integer;
begin 
    min.codigo := valorAlto;
    min.fecha := 'ZZZZ';
    for i := 1 to dimF do begin 
        if (vr[i].codigo <= min.codigo) then begin 
            min := vr[i];
            pos := i;
        end;
    end;
    if (min.codigo <> valorAlto) then
        leer (vd[pos], vr[pos]);
end;

procedure crearMaestro (var mae: maestro; var vd: vectorD);
var 
    vr: vectorR;
    min, dato: sesion;
    i: rango;
begin 
    writeln ('Creando archivo maestro...');
    assign (mae, 'maestro.dat');
    rewrite (mae);
    for i := 1 to dimF do begin                       // abro los archivos detalle
        reset (vd[i]);
        leer (vd[i], vr[i]);
    end;
    minimo (vd, vr, min);
    while (min.codigo <> valorAlto) do begin 
        dato.codigo := min.codigo;                    // codigo del usuario actual
        while (dato.codigo = min.codigo) do begin 
            dato.fecha := min.fecha;                  // fecha de la sesion/es abiertas del usuario actual
            dato.tiempo := 0;                         
            while (dato.codigo = min.codigo) and (dato.fecha = min.fecha) do begin 
                dato.tiempo := dato.tiempo + min.tiempo;
                minimo (vd, vr, min);
            end;
            write (mae, dato);
        end;
    end;
    close (mae);
    writeln ('Archivo maestro creado');
    for i := 1 to dimF do                               // cierro los archivos detalle
        close (vd[i]);
end;

procedure imprimirSesion (s: sesion);
begin 
    writeln ('Codigo de usuario: ', s.codigo, ' / Fecha: ', s.fecha, ' / Tiempo total de sesiones: ', s.tiempo:0:2, ' minutos');
end;

procedure imprimirMaestro (var mae: maestro);
var 
    regM: sesion;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, regM);
        imprimirSesion (regM);
    end;
    close (mae);
end;

begin 
    cargarVectorD (vd);
    crearMaestro (mae, vd);
    imprimirMaestro (mae);
end.