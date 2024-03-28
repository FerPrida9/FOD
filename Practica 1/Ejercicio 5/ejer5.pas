{Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible. 

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

}

program ejer5;

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
        writeln ('5: terminar programa');
        readln (opcion);
        case opcion of
            1: cargar (arch_cel);
            2: stockInsuficiente (arch_cel);
            3: buscarDescripcion (arch_cel);
            4: exportarTXT (arch_cel);
            5: break
        end;
    end;
end;

var
    arch_cel: tarch;
begin
    runMenu (arch_cel);
end.
