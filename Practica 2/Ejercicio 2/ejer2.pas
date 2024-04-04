{ Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto. }

program ejer2;
const valorAlto = 9999;
type
    alumno = record 
        codigo: integer;
        cantCursadas: integer;
        cantMaterias: integer;
        nomYape: string [60];
    end;

    materia = record 
        codigo: integer;
        estado: integer;     // 1 si aprobo la materia, 0 si aprobo la cursada
    end;

    detalle = file of materia;
    maestro = file of alumno;

procedure importarMaestro (var mae: maestro);
var 
    regm: alumno;
    txt: text;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regm.codigo, regm.cantCursadas, regm.cantMaterias, regm.nomYape);
        write (mae, regm);
    end;
    writeln ('archivo maestro creado con exito');
    close (mae);
    close (txt);
end;

procedure importarDetalle (var det: detalle);
var 
    txt2: text;
    regd: materia;
begin 
    assign (det, 'detalle.dat');
    rewrite (det);
    assign (txt2, 'detalle.txt');
    reset (txt2);
    while (not eof(txt2)) do begin 
        readln (txt2, regd.codigo, regd.estado);
        write (det, regd);
    end;
    writeln ('archivo detalle creado con exito');
    close (det);
    close (txt2);
end; 

procedure leer (var det: detalle; var regd: materia);
begin 
    if (not eof(det)) then 
        read (det, regd)
    else 
        regd.codigo := valorAlto;
end;

procedure actualizarMaestro (var mae: maestro; var det: detalle);
var 
    regd: materia;
    regm: alumno;
    cursadas, materias, codigo: integer;
begin 
    reset (mae);
    reset (det);
    read (mae, regm); 
    leer (det, regd);
    while (regd.codigo <> valorAlto) do begin 
        codigo := regd.codigo;
        cursadas := 0;
        materias := 0;
        while (regd.codigo = codigo) do begin 
            if (regd.estado = 1) then 
                materias := materias + 1
            else 
                cursadas := cursadas + 1;
            leer(det, regd);
        end;
        while (regm.codigo <> codigo) do     // busco el codigo en el archivo maestro
            read (mae, regm);
        regm.cantMaterias := regm.cantMaterias + materias;
        regm.cantCursadas := regm.cantCursadas - materias;
        regm.cantCursadas := regm.cantCursadas + cursadas;
        seek (mae, FilePos(mae) - 1);
        write (mae, regm);
        if (not eof (mae)) then
            read (mae, regm);
    end;
    writeln ('maestro actualizado con exito');
    close (mae);
    close (det);
end;

procedure imprimirAlumno (var a: alumno);
begin 
    writeln ('codigo: ', a.codigo);
    writeln ('cantidad de cursadas: ', a.cantCursadas);
    writeln ('cantidad de materias aprobadas con final: ', a.cantMaterias);
    writeln ('nombre y apellido: ', a.nomYape);
end;

procedure imprimirMaestro (var mae: maestro);
var
    regm: alumno;
begin 
    writeln ('los datos del archivo maestro son: ');
    reset (mae);
    while (not eof (mae)) do begin 
        read (mae, regm);
        imprimirAlumno (regm);
    end;
    close (mae);
end;

procedure exportarMaestro (var mae: maestro);
var
    txt: text;
    regm: alumno;
begin
    writeln ('exportando a TXT aquellos alumnos con mas materias aprobadas que materias sin finales aprobados');
    assign (txt, 'alumnos.txt');
    rewrite (txt);
    reset (mae);
    while (not eof (mae)) do begin 
        read (mae, regm);
        if (regm.cantMaterias > regm.cantCursadas) then 
            writeln (txt, regm.codigo,' ', regm.cantCursadas,' ', regm.cantMaterias,' ', regm.nomYape);
    end;
    close (mae);
    close (txt);
end;

var 
    mae: maestro;
    det: detalle;
begin 
    importarMaestro (mae);
    importarDetalle (det);
    actualizarMaestro (mae, det);
    imprimirMaestro (mae);
    exportarMaestro (mae);
end. 
