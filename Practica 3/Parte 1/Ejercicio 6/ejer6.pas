{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.

Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}

program ejer6;
type 
    prenda = record
        codigo: integer;
        descripcion: string;
        colores: string;
        tipo: string;
        stock: integer;
        precio: real;
    end;

    maestro = file of prenda;

    detalle = file of integer;

procedure importarMaestro (var mae: maestro);
var 
    p: prenda;
    txt: text;
begin 
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, p.codigo, p.stock, p.precio, p.descripcion);
        readln (txt, p.tipo);
        readln (txt, p.colores);
        write (mae, p);
    end;
    writeln ('archivo maestro binario creado');
    close (txt);
    close (mae);
end;

procedure importarDetalle (var det: detalle);
var 
    txt: text;
    cod: integer;
begin   
    assign (det, 'detalle.dat');
    rewrite (det);
    assign (txt, 'detalle.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, cod);
        write (det, cod);
    end;
    writeln ('archivo detalle binario creado');
    close (txt);
    close (det);
end;

procedure baja (var mae: maestro; var det: detalle);
var 
    p: prenda;
    codigo: integer;
begin 
    reset (mae);
    reset (det);
    while (not eof(det)) do begin 
        read (det, codigo);
        seek (mae, 0);
        read (mae, p);
        while (p.codigo <> codigo) do
            read (mae, p);
        p.stock := -1;
        seek (mae, filepos(mae) - 1);
        write (mae, p);
    end;
    writeln ('bajas realizadas con exito');
    close (mae);
    close (det);
end;

procedure compactarMaestro (var mae: maestro; var newMae: maestro);
var 
    p: prenda;
begin 
    assign (newMae, 'MaeCompactado');
    rewrite (newMae);
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, p);
        if (p.stock >= 0) then  
            write (newMae, p);
    end;
    close (mae);
    close (newMae);
    erase (mae);
    rename (newMae, 'maestro.dat');
    writeln ('archivo maestro compactado con exito');
end;

procedure imprimirMaestro (var mae: maestro);
var 
    p: prenda;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, p);
        writeln ('codigo: ', p.codigo,' descripcion: ', p.descripcion,' colores: ', p.colores,' tipo: ', p.tipo,' stock: ', p.stock,' precio: ', p.precio:0:2);
    end;
    close (mae);
end;

var 
    det: detalle;
    mae, newMae: maestro;
begin 
    importarMaestro (mae);
    importarDetalle (det);
    writeln ('maestro antes del borrado: ');
    imprimirMaestro (mae);
    baja (mae, det);
    writeln ('----------------');
    writeln ('maestro despues del borrado: ');
    imprimirMaestro (mae);
    compactarMaestro (mae, newMae);
    writeln ('---------------');
    writeln ('maestro compactado: ');
    imprimirMaestro (newMae);
end.