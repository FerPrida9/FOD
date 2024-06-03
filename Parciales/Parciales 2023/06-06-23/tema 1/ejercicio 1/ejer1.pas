program ejer1;
type 
    producto = record 
        codigo: integer;
        nombre: string;
        descripcion: string;
        precioCompra: real;
        precioVenta: real;
        ubicacion: string;
    end;

    archivo = file of producto;

procedure leerProducto (var p: producto);
begin 
    writeln ('ingrese el codigo de producto: ');
    readln (p.codigo);
    if (p.codigo <> -1) then begin 
        writeln ('ingrese el nombre del producto: ');
        readln (p.nombre);
        writeln ('ingrese la descripcion del producto: ');
        readln (p.descripcion);
        writeln ('ingrese el precio de compra del producto: ');
        readln (p.precioCompra);
        writeln ('ingrese el precio de venta del producto: ');
        readln (p.precioVenta);
        writeln ('ingrese la ubicacion del producto');
        readln (p.ubicacion);
    end;
end;

procedure crearArchivo (var arch: archivo);
var 
    p: producto;
begin 
    assign (arch, 'productos');
    rewrite (arch);
    p.codigo := 0;
    p.nombre := '';
    p.descripcion := '';
    p.precioCompra := 0;
    p.precioVenta := 0;
    p.ubicacion := '';
    write (arch, p);
    writeln ('A continuacion, ingrese los productos que desea agregar al archivo (-1 en campo codigo para finalizar lectura)');
    leerProducto (p);
    while (p.codigo <> - 1) do begin 
        write (arch, p);
        leerProducto (p);
    end;
    close (arch);
end;

function existe (var arch: archivo; codigo: integer): boolean;
var 
    encontre: boolean;
    p: producto;
begin 
    reset (arch);
    encontre := false;
    while (not eof(arch) and not encontre) do begin 
        read (arch, p);
        if (p.codigo = codigo) then 
            encontre := true;
    end;
    close (arch);
    existe := encontre;
end;

procedure agregarProducto (var arch: archivo);
var 
    p, cabecera: producto;
begin 
    writeln ('Ingrese los datos del producto que desea agregar: ');
    leerProducto (p);
    if (existe(arch, p.codigo)) then 
        writeln ('el producto ingresado ya existe en el archivo')
    else begin 
        reset (arch);
        read (arch, cabecera);   // leo la cabecera
        if (cabecera.codigo = 0) then begin   // si la cabecera es 0 significa que el archivo no tiene datos eliminados
            seek (arch, filesize(arch));      // me situo al final del archivo y agrego el producto
            write (arch, p);
        end 
        else begin 
            seek (arch, cabecera.codigo * -1);   // me situo en la posicion borrada del archivo
            read (arch, cabecera);   // leo la posicion borrada
            seek (arch, filepos(arch) - 1);  // me situo nuevamente en esa posicion ya que al leer se corre el puntero
            write (arch, p);                 // escribo en esa posicion el producto que quiero agregar
            seek (arch, 0);              // me situo en la cabecera
            write (arch, cabecera);    // escribo en la cabecera el registro borrado
        end;
        writeln ('El producto se agrego correctamente');
        close (arch);
    end;
end;

procedure quitarProducto (var arch: archivo);
var 
    cabecera, p: producto;
    codigo: integer;
begin 
    writeln ('ingrese el codigo del producto que desea eliminar: ');
    readln (codigo);
    if (existe(arch, codigo)) then begin 
        reset (arch);
        read (arch, cabecera);
        read (arch, p);
        while (p.codigo <> codigo) do 
            read (arch, p);
        seek (arch, filepos(arch) - 1);  // me situo en la posicion del producto a eliminar 
        write (arch, cabecera);          // copio la cabecera actual en esa posicion
        cabecera.codigo := (filepos(arch) -1) * -1;  // en el campo codigo de la cabecera pongo el valor negativo de la posicion que borre
        seek (arch, 0);           // me situo en la cabecera
        write (arch, cabecera);   // copio la cabecera nueva
        writeln ('producto eliminado correctamente');
        close (arch);
    end 
    else  
        writeln ('el codigo ingresado no existe en el archivo');
end;

procedure imprimirArchivo (var arch: archivo);
var 
    p: producto;
begin 
    reset (arch);
    while (not eof(arch)) do begin 
        read (arch, p);
        if (p.codigo > 0) then begin
            writeln('Codigo: ', p.codigo, ' Nombre: ', p.nombre, ' Descripcion: ', p.descripcion
            , ' Precio de compra: ', p.precioCompra:0:2, ' Precio de venta: ', p.precioVenta:0:2, ' Ubicacion: ', p.ubicacion);
        end
        else 
            writeln ('espacio disponible');
    end;
    close (arch);
end;

var 
    arch: archivo;
begin 
    crearArchivo (arch);
    writeln ('archivo original: ');
    imprimirArchivo (arch);
    writeln ('--------------------------------------------------------');
    quitarProducto (arch);
    writeln ('archivo con producto eliminado: ');
    imprimirArchivo (arch);
    writeln ('--------------------------------------------------------');
    agregarProducto (arch);
    writeln ('archivo con producto agregado: ');
    imprimirArchivo (arch);
end.