{ Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).}

program ejer5;
const 
    valorAlto = 9999;
    dimF = 3;  // 30
type
    producto = record 
        codigo: integer;
        precio: real;
        stockDisp: integer;
        stockMin: integer;
        nombre: string[50];
        descripcion: string[50];
    end;

    venta = record
        codigo: integer;
        cantVentas: integer;
    end;

    rango = 1..dimF;

    maestro = file of producto;
    detalle = file of venta;

    vectorD = array[rango] of detalle;  // VECTOR DE DETALLES
    vectorR = array[rango] of venta;    // VECTOR DE REGISTROS

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
        readln (txt, regM.codigo, regM.precio, regM.stockDisp, regM.stockMin, regM.nombre);
        readln (txt, regM.descripcion);
        write (mae, regM);
    end;
    writeln ('archivo maestro creado con exito');
    close (mae);
    close (txt);
end;
    
procedure importarDetalle (var det: detalle);
var 
    txt2: Text;
    regD: venta;
    nombre: string;
begin 
    writeln ('ingrese el nombre del archivo detalle binario: ');
    readln (nombre);
    assign (det, nombre);
    rewrite (det);
    writeln ('ingrese el nombre del archivo detalle.txt: ');
    readln (nombre);
    assign (txt2, nombre);
    reset (txt2);
    while (not eof(txt2)) do begin 
        readln (txt2, regD.codigo, regD.cantVentas);
        write (det, regD);
    end;
    writeln ('archivo detalle creado con exito');
    close (det);
    close (txt2);
end;

procedure cargarVectorD (var vd: vectorD);
var 
    i: rango;
begin 
    for i := 1 to dimF do begin 
        importarDetalle (vd[i])
    end;
end;

procedure leer (var det: detalle; var regD: venta);
begin 
    if (not eof(det)) then 
        read (det, regD)
    else 
        regD.codigo := valorAlto;
end;

procedure minimo (var vd: vectorD; var vr: vectorR; var min: venta);
var 
    pos: integer;
    i: rango;
begin 
    min.codigo := valorAlto;
    for i:= 1 to dimF do begin 
        if (vr[i].codigo <= min.codigo) then begin     // busco el codigo minimo entre los registros
            min := vr[i];                
            pos := i;
        end;
    end;
    if (min.codigo <> valorAlto) then 
        leer (vd[pos], vr[pos]);                      // leo el siguiente registro del detalle el cual tiene el registro con codigo minimo
end;

procedure actualizarMaestro (var mae: maestro; var vd: vectorD);
var 
    regM: producto;
    i: rango;
    vr: vectorR;
    cant, codigo: integer;
    min: venta;
begin 
    reset (mae);
    read (mae, regM);
    for i := 1 to dimF do begin                      // abro todos los archivos detalle
        reset (vd[i]);
        leer (vd[i], vr[i]);
    end;
    minimo (vd, vr, min);                            // busco el codigo minimo entre los archivos detalle
    while (min.codigo <> valorAlto) do begin         // mientras no llegue al final del detalle
        codigo := min.codigo;                        // codigo actual
        cant := 0;                                   // cantidad total de ventas de ese codigo
        while (codigo = min.codigo) do begin         // mientras el codigo minimo sea igual al codigo actual que estoy procesando
            cant := cant + min.cantVentas;           // sumo las ventas a las ventas totales
            minimo (vd, vr, min);                    // busco el minimo
        end;
        while (regM.codigo <> codigo) do             // busco ese codigo en el archivo maestro
            read (mae, regM);
        regM.stockDisp := regM.stockDisp - cant;     // actualizo el stock disponible de ese producto
        seek (mae, filepos(mae) - 1);                // me situo en el registro de ese producto en el maestro
        write (mae, regM);                           // actualizo el producto
        if (not eof(mae)) then                       // si no llegue al final del maestro, leo otro producto
            read (mae, regM)
    end;
    writeln ('archivo maestro actualizado con exito');
    close (mae);
    for i := 1 to dimF do                            // cierro todos los archivos detalle
        close (vd[i]);
end;

procedure informarStocksBajos (var mae: maestro);
var 
    txt: Text;
    regM: producto;
begin 
    writeln ('Exportando a txt aquellos productos con stock disponible por debajo del stock minimo');
    reset (mae);
    assign (txt, 'StocksBajos.txt');
    rewrite (txt);
    while (not eof(mae)) do begin 
        read (mae, regM);
        if (regM.stockDisp < regM.stockMin) then begin 
            writeln (txt, regM.precio:0:2,' ', regM.nombre);
            writeln (txt, regM.stockDisp,' ', regM.descripcion);
        end;
    end;
    writeln ('Exportacion realizada con exito');
    close (mae);
    close (txt);
end;

procedure imprimirProducto (var prod: producto);
begin 
    writeln ('Nombre: ', prod.nombre, ' / Descripcion: ', prod.descripcion, ' / Codigo: ', prod.codigo, ' / Precio: ', prod.precio:0:2, ' / Stock disponible: ', prod.stockDisp, ' / Stock minimo: ', prod.stockMin);
end;

procedure imprimirMaestro (var mae: maestro);
var 
    regM: producto;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, regM);
        imprimirProducto (regM);
    end;
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
    informarStocksBajos (mae);
end.