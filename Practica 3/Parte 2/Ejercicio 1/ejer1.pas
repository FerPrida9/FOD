{El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:

i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program ejer1;
type 
    producto = record 
        codigo: integer;
        nombre: string;
        precio: real;
        stockAct: integer;
        stockMin: integer;
    end;

    venta = record
        codigo: integer;
        cantVendidas: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure crearMaestro (var mae: maestro);
var 
    p: producto;
    txt: text;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, p.codigo, p.precio, p.stockAct, p.stockMin, p.nombre);
        write (mae, p);
    end;
    writeln ('archivo maestro creado');
    close (mae);
    close (txt);
end;

procedure crearDetalle (var det: detalle);
var 
    txt: text;
    v: venta;
begin 
    assign (det, 'detalle.dat');
    rewrite (det);
    assign (txt, 'detalle.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, v.codigo, v.cantVendidas);
        write (det, v);
    end;
    writeln ('archivo detalle creado');
    close (det);
    close (txt);
end;

procedure actualizarMaestro (var mae: maestro; var det: detalle);
var 
    encontre: boolean;
    v: venta;
    p: producto;
begin 
    reset (mae);
    reset (det);
    encontre := false;
    while (not eof(det)) do begin 
        read (det, v);
        encontre := false;
        seek (mae, 0);
        while (not eof(mae) and (not encontre)) do begin 
            read (mae, p);
            if  (p.codigo = v.codigo) then begin 
                p.stockAct := p.stockAct - v.cantVendidas;
                seek (mae, filepos(mae) - 1);
                write (mae, p);
                encontre := true;
            end;
        end;
    end;
    writeln ('maestro actualizado');
    close (mae);
    close (det);
end;

procedure imprimirMaestro (var mae: maestro);
var 
    p: producto;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, p);
        writeln ('codigo: ',p.codigo,' / precio: ',p.precio:0:2, ' / stock actual: ',p.stockAct,' / stock minimo: ',p.stockMin,' / nombre: ',p.nombre);
    end;
    close (mae);
end;

var 
    mae: maestro;
    det: detalle;
begin 
    crearMaestro (mae);
    crearDetalle (det);
    writeln ('maestro antes de actualizar: ');
    imprimirMaestro (mae);
    writeln ('-----------------------');
    writeln ('maestro actualizado: ');
    actualizarMaestro (mae, det);
    imprimirMaestro (mae);
end.