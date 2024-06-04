program ejer1;
const 
    valorAlto = 9999;
    dimF = 3; // 20
type    
    producto = record 
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    venta = record  
        codigo: integer;
        cantidadVendida: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;
    vectorD = array [1..dimF] of detalle;    // VECTOR DE DETALLES
    vectorR = array [1..dimF] of venta;      // VECTOR DE REGISTROS

procedure importarMaestro (var mae: maestro);
var 
    regM: producto;
    txt: text;
begin 
    assign (mae, 'maestro');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        with regM do begin
            readln (txt, codigo, precio, stockActual, stockMinimo, nombre);
        end;
        write(mae, regM);
    end;
    writeln ('archivo maestro importado con exito');
    close (mae);
    close (txt);
end;

procedure importarDetalle (var det: detalle);
var 
    ruta: string;
    txt: text;
    regD: venta;
begin 
    writeln ('ingrese la ruta del detalle binario:');
    readln (ruta);
    assign (det, ruta);
    rewrite (det);
    writeln ('ingrese la ruta del archivo de texto:');
    readln (ruta);
    assign (txt, ruta);
    reset (txt);
    while (not eof(txt)) do begin 
        with regD do 
            readln (txt, codigo, cantidadVendida);
        write (det, regD);
    end;
    writeln ('archivo detalle importado con exito');
    close (det);
    close (txt);
end;

procedure cargarVectorDetalle (var vd: vectorD);
var 
    i: integer;
begin 
    for i := 1 to dimF do 
        importarDetalle(vd[i]);
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
    i, pos: integer;
begin 
    min.codigo := valorAlto;
    for i := 1 to dimF do begin 
        if (vr[i].codigo <= min.codigo) then begin 
            min := vr[i];
            pos := i;
        end;
    end;
    if (min.codigo <> valorAlto) then 
        leer (vd[pos], vr[pos]);
end;

procedure exportarTXT (var txt: text; p: producto);
begin 
    write (txt, p.codigo, ' ', p.precio:0:2, ' ', p.stockActual, ' ', p.stockMinimo, ' ', p.nombre);
end;

procedure actualizarMaestro (var mae: maestro; var vd: vectorD);
var 
    txt: text;
    regM: producto;
    codigo, cantVentas, i: integer;
    montoTotal: real;
    vr: vectorR;
    min: venta;
begin 
    assign (txt, 'productosConMayorMontoVendido.txt');
    rewrite (txt);
    reset (mae);   
    read (mae, regM);                 
    for i := 1 to dimF do begin
        reset (vd[i]);              // abro los archivos detalle
        leer (vd[i], vr[i]);        // leo el primer registro de cada archivo detalle
    end;
    minimo (vd, vr, min);           // busco el codigo minimo entre los archivos detalle
    while (min.codigo <> valorAlto) do begin    // mientras no llegue al final del detalle
        codigo := min.codigo;         // codigo actual
        cantVentas := 0;              // cantidad de ventas de ese producto
        while (codigo = min.codigo) do begin    // mientras el codigo minimo sea igual al codigo actual que estoy procesando
            cantVentas := cantVentas + min.cantidadVendida;    // sumo la cantidad de ventas de ese producto 
            minimo (vd, vr, min);                              // busco el minimo
        end;
        while (regM.codigo <> codigo) do            // busco el producto en el maestro
            read (mae, regM);
        regM.stockActual := regM.stockActual - cantVentas;   // actualizo el stock disponible del producto en el maestro 
        seek (mae, filepos(mae) -1);        // me posiciono en el registro de ese producto en el maestro 
        write (mae, regM);                  // actualizo el producto 
        montoTotal := cantVentas * regM.precio;     // me guardo el monto total de ventas de ese producto
        if (montoTotal > 10000) then                // si el monto total es mayor a 10000, exporto el producto a txt
            exportarTXT (txt, regM);
    end;
    writeln ('Archivo maestro actualizado');
    for i := 1 to dimF do                           // cierro los archivo detalle
        close (vd[i]);
    close (mae);
    close (txt);
end;

procedure imprimirMaestro (var mae: maestro);
var 
    p: producto;
begin 
    reset (mae);
    while (not eof(mae)) do begin 
        read (mae, p);
        writeln ('codigo: ', p.codigo, ' nombre: ',p.nombre, ' precio: ',p.precio:0:2, ' stock actual: ', p.stockActual, ' stock minimo: ',p.stockMinimo);
    end;
end;

var 
    vd: vectorD;
    vr: vectorR;
    mae: maestro;
begin 
    importarMaestro (mae);   // en el examen se dispone
    cargarVectorDetalle (vd);  // en el examen se dispone 
    actualizarMaestro (mae, vd);
    imprimirMaestro (mae);
end.