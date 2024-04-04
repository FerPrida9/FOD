{ Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program ejer1;
const valorAlto = 9999;
type
    ingresosComision = record
        codigo: integer;
        monto: real;
        nombre: string [30];
    end;

    archivoIngresos = file of ingresosComision;

procedure importarTXT (var comisionFile: archivoIngresos);
var 
    c: ingresosComision;
    txt: text;
begin 
    assign (comisionFile, 'comisiones.dat');
    rewrite (comisionFile);
    writeln ('importando informacion desde "comisiones.txt"');
    assign (txt, 'comisiones.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, c.codigo,c.monto,c.nombre);
        write (comisionFile, c);
    end;
    writeln ('importacion realizada con exito');
    close (txt);
    close (comisionFile);
end;

procedure leerComision (var comisionFile: archivoIngresos; var c: ingresosComision);
begin 
    if (not eof (comisionFile)) then 
        read (comisionFile, c)
    else 
        c.codigo := valorAlto;
end;

procedure compactar (var comisionFile, compactFile: archivoIngresos);
var 
    c: ingresosComision;
    nombre: string [30];
    montoTotal: real;
    codigo: integer;
begin 
    writeln ('ingrese el nombre que desea ponerle al archivo compactado');
    readln (nombre);
    assign (compactFile, nombre);
    rewrite (compactFile);
    reset (comisionFile);
    leerComision (comisionFile, c);
    while (c.codigo <> valorAlto) do begin 
        montoTotal := 0;
        codigo := c.codigo;
        while (c.codigo = codigo) do begin 
            montoTotal := montoTotal + c.monto;
            leerComision (comisionFile, c);
        end;
        c.monto := montoTotal;
        write (compactFile, c);
    end;
    close (comisionFile);
    close (compactFile);
end;

procedure informarEmpleado (c: ingresosComision);
begin 
    writeln ('codigo de empleado: ', c.codigo);
    writeln ('monto: ', c.monto:0:2);
    writeln ('nombre: ', c.nombre);
end;

procedure informar (var compactFile: archivoIngresos);
var 
    c: ingresosComision;
begin 
    writeln ('Imprimiendo archivo compactado: ');
    reset (compactFile);
    while (not eof (compactFile)) do begin 
        read (compactFile, c);
        informarEmpleado (c);
    end;
    close (compactFile);
end;

var 
    comisionFile, compactFile: archivoIngresos;
begin 
    importarTXT (comisionFile);
    compactar (comisionFile, compactFile);
    informar (compactFile);
end.
