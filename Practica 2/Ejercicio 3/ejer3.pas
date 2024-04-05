{ El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido. }

program ejer3;
const 
    valorAlto = 9999;
type
    producto = record
        codigo: integer;
        precio: real;
        stockAct: integer;
        stockMin: integer;
        nombre: string;
    end;

    venta = record
        codigo: integer;
        cantUnidades: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure importarMaestro (var mae: maestro);
var 
    txt: text;
    regM: producto;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, regM.codigo, regM.precio, regM.stockAct, regM.stockMin, regM.nombre);
        write (mae, regM);
    end;
    writeln ('archivo maestro creado con exito');
    close (mae);
    close (txt);
end;

procedure importarDetalle (var det: detalle);
var 
    txt2: text;
    regD: venta;
begin 
    assign (det, 'detalle.dat');
    rewrite (det);
    assign (txt2, 'detalle.txt');
    reset (txt2);
    while (not eof(txt2)) do begin 
        readln (txt2, regD.codigo, regD.cantUnidades);
        write (det, regD);
    end;
    writeln ('archivo detalle creado con exito');
    close (det);
    close (txt2);
end;

procedure leer (var det: detalle; var regD: venta);
begin 
    if (not eof(det)) then 
        read (det, regD)
    else 
        regD.codigo := valorAlto;
end;

procedure actualizarMaestro (var mae: maestro; var det: detalle);
var 
    regM: producto;
    regD: venta;
    cantTotal, codigo: integer;
begin 
    reset (mae);
    reset (det);
    read (mae, regM);   // leo maestro
    leer (det, regD);   // leo detalle
    while (regD.codigo <> valorAlto) do begin 
        codigo := regD.codigo;                   // asigno codigo actual
        cantTotal := 0;                          // inicializo total de ventas de un producto
        while (codigo = regD.codigo) do begin 
            cantTotal := cantTotal + regD.cantUnidades;   // voy sumando la cantidad total de ventas del producto
            leer (det, regD);
        end;
        while (regM.codigo <> codigo) do begin           // busco el codigo en el archivo maestro
            read (mae, regM);
        end;
        regM.stockAct := regM.stockAct - cantTotal;     // actualizo el stock actual del producto
        seek (mae, FilePos(mae) - 1);                        // me situo en el producto del archivo maestro
        write (mae, regM);                              // actualizo el producto
        if (not eof(mae)) then 
            read (mae, regM);                           // si no llegue al final del maestro, leo otro producto
    end;
    writeln ('maestro actualizado con exito');
    close (det);
    close (mae);
end;

procedure imprimirProducto (var prod: producto);
begin 
    writeln ('codigo: ', prod.codigo);
    writeln ('precio: ', prod.precio:0:2);
    writeln ('stock actual: ', prod.stockAct);
    writeln ('stock minimo: ', prod.stockMin);
    writeln ('nombre: ', prod.nombre);
    writeln;
end;

procedure imprimirMaestro (var mae: maestro);
var 
    regM: producto;
begin 
    writeln ('los datos del archivo maestro son: ');
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, regM);
        imprimirProducto (regM);
    end;
    close (mae);
end;

procedure exportarTXT (var mae: maestro);
var 
    txt: text;
    prod: producto;
begin 
    writeln ('exportando a TXT aquellos productos con stock actual menor al stock minimo permitido ');
    assign (txt, 'stock_minimo.txt');
    rewrite (txt);
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, prod);
        if (prod.stockAct < prod.stockMin) then 
            writeln (txt, prod.codigo,' ', prod.precio:0:2,' ', prod.stockAct,' ', prod.stockMin,' ', prod.nombre);
    end;
    close (txt);
    close (mae);
end;

var 
    mae: maestro;
    det: detalle;
begin 
    importarMaestro (mae);
    importarDetalle (det);
    actualizarMaestro (mae, det);
    imprimirMaestro (mae);
    exportarTXT (mae);
end.
