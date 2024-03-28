{ Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.

b. Modificar el stock de un celular dado.

c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.

}

program ejer6;

type
    tcelular = record
        codigo: integer;
        precio: real;
        marca: string [20]; 
        stockDisp: integer;
        stockMin: integer;
        descripcion: string [30];
        nombre: string [30];
    end;

    tarch = file of tcelular;

procedure cargar (var arch_cel: tarch);
var
    celu: tcelular;
    nombre: string [30];
    txt: text;
begin 
    writeln ('ingrese el nombre que desea ponerle al archivo binario: ');
    readln (nombre);
    assign (arch_cel, nombre);
    rewrite (arch_cel);
    assign (txt,'celulares.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt,celu.codigo,celu.precio,celu.marca);
        readln (txt,celu.stockDisp,celu.stockMin,celu.descripcion);
        readln (txt, celu.nombre);
        write (arch_cel, celu);
    end;

    close (txt);
    close (arch_cel);
end;

procedure imprimirCelular (var celu: tcelular);
begin 
    writeln ('codigo: ', celu.codigo);
    writeln ('precio: ', celu.precio:0:2);
    writeln ('marca: ', celu.marca);
    writeln ('stock disponible: ', celu.stockDisp);
    writeln ('stock minimo: ', celu.stockMin);
    writeln ('descripcion: ', celu.descripcion);
    writeln ('nombre: ', celu.nombre);
    writeln ('');
end;

procedure stockInsuficiente (var arch_cel: tarch);
var
    celu: tcelular;
    found: boolean;
begin
    found := false;
    reset (arch_cel);
    while (not eof (arch_cel)) do begin 
        read (arch_cel, celu);
        if (celu.stockDisp < celu.stockMin) then begin 
            if (not found) then begin 
                found := true;
                writeln ('los celulares con stock menor al minimo son: ');
            end;
            imprimirCelular (celu);
        end;
    end;
    if (not found) then 
        writeln ('no se encontraron celulares con stock menor al minimo');
    close (arch_cel);
end;

procedure buscarDescripcion (var arch_cel: tarch);
var
    found: boolean;
    description: string [30];
    celu: tcelular;
begin 
    found := false;
    writeln ('ingrese la descripcion que desea buscar');
    readln (description);
    reset (arch_cel);
    while (not eof (arch_cel)) do begin 
        read (arch_cel, celu);
        if (pos (description, celu.descripcion) <> 0) then begin 
            if (not found) then begin 
                found := true;
                writeln ('los celulares con esa descripcion son: ');
            end;
            imprimirCelular (celu);
        end;
    end;
    if (not found) then 
        writeln ('no se encontraron celulares con esa descripcion');
    close (arch_cel);
end;

procedure exportarTXT (var arch_cel: tarch);
var 
    celu: tcelular;
    txt: text;
begin 
    assign (txt, 'celulares2.txt');
    rewrite (txt);
    reset (arch_cel);
    while (not eof (arch_cel)) do begin 
        read (arch_cel, celu);
        writeln (txt,celu.codigo,' ',celu.precio:0:2,' ',celu.marca);
        writeln (txt,celu.stockDisp,' ',celu.stockMin,' ',celu.descripcion);
        writeln (txt,celu.nombre);
    end;
    close (arch_cel);
    close (txt);
end;

procedure leerCelular (var celu: tcelular);
begin 
    writeln;
    writeln('Ingrese codigo: ');
    readln(celu.codigo);
    writeln('Ingrese precio: ');
    readln(celu.precio);
    writeln('Ingrese marca: ');
    readln(celu.marca);
    writeln('Ingrese stock disponible: ');
    readln(celu.stockDisp);
    writeln('Ingrese stock minimo: ');
    readln(celu.stockMin);
    writeln('Ingrese descripcion: ');
    readln(celu.descripcion);
    writeln('Ingrese nombre: ');
    readln(celu.nombre);
end;

procedure agregarCelulares (var arch_cel: tarch);
var 
    celu: tcelular;
    opcion: string [5];
begin 
    reset (arch_cel);
    seek (arch_cel, FileSize(arch_cel));
    leerCelular (celu);
    while (true) do begin 
        write (arch_cel, celu);
        writeln ('desea agregar otro celular? (si/no)');
        readln (opcion);
        if (opcion = 'no') then 
            break 
        else
            leerCelular (celu);
    end;
    close (arch_cel);
end;

procedure modificarStock (var arch_cel: tarch);
var 
    celu: tcelular;
    found: boolean;
    nombre: string [30];
    stock: integer;
begin 
    reset (arch_cel);
    found := false;
    writeln ('ingrese el nombre del celular: ');
    readln (nombre);
    while (not eof (arch_cel)) do begin
        read (arch_cel, celu);
        if (celu.nombre = nombre) then begin 
            found := true;
            break;
        end;
    end;
    if (found) then begin
        writeln ('ingrese el nuevo stock: ');
        readln (stock);
        seek (arch_cel, filepos (arch_cel)-1);
        celu.stockDisp := stock;
        write (arch_cel, celu);
    end
    else begin 
        writeLn;
        writeln ('el celular ', nombre , ' no existe');
    end;
    close (arch_cel);
end;

procedure exportarSinStock (var arch_cel: tarch);
var 
    txt: text;
    celu: tcelular;
begin
    assign (txt, 'sinStock.txt');
    rewrite (txt);
    reset (arch_cel);
    while (not eof (arch_cel)) do begin 
        read (arch_cel, celu);
        if (celu.stockDisp = 0) then begin 
            writeln (txt,celu.codigo,' ',celu.precio:0:2,' ',celu.marca);
            writeln (txt,celu.stockDisp,' ',celu.stockMin,' ',celu.descripcion);
            writeln (txt,celu.nombre);
        end;
    end;
    close (arch_cel);
    close (txt);
end;

procedure runMenu (var arch_cel: tarch);
var
    opcion: integer;
begin 
    while (true) do begin 
        writeln ('');
        writeln ('ingrese la operacion deseada');
        writeln ('1: cargar archivo binario desde "celulares.txt"');
        writeln ('2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
        writeln ('3: buscar celular por descripcion');
        writeln ('4: exportar info. del archivo binario a un archivo .txt');
        writeln ('5: agregar celular/es al archivo');
        writeln ('6: modificar stock de un celular');
        writeln ('7: exportar a un archivo txt los celulares sin stock ');
        writeln ('8: terminar programa');
        readln (opcion);
        case opcion of
            1: cargar (arch_cel);
            2: stockInsuficiente (arch_cel);
            3: buscarDescripcion (arch_cel);
            4: exportarTXT (arch_cel);
            5: agregarCelulares (arch_cel);
            6: modificarStock (arch_cel);
            7: exportarSinStock (arch_cel);
            8: break
        end;
    end;
end;

var
    arch_cel: tarch;
begin
    runMenu (arch_cel);
end.
