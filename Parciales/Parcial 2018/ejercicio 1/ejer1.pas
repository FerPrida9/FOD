{1. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
    Mes:-- 1
        día:-- 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 1
        Tiempo total acceso dia 1 mes 1
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 1
            --------
            idusuario N Tiempo total de acceso en el dia N mes 1
        Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
        ------
    Mes 12
        día 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 12
        Tiempo total acceso dia 1 mes 12
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 12
            --------
            idusuario N Tiempo total de acceso en el dia N mes 12
        Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program ejer1;
const 
    valorAlto = 9999;
type 
    user = record 
        anio: integer;
        mes: integer;
        dia: integer;
        ID: integer;
        tiempo: real;
    end;

    archivo = file of user;

procedure importarArchivo (var arch: archivo);
var 
    u: user;
    txt: text;
begin 
    assign (arch, 'archivo.dat');
    rewrite (arch);
    assign (txt, 'archivo.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, u.anio, u.mes, u.dia, u.ID, u.tiempo);
        write (arch, u);
    end;
    writeln ('Archivo binario creado');
    close (arch);
    close (txt);
end;

procedure leer (var arch: archivo; var u: user);
begin 
    if (not eof(arch)) then 
        read (arch, u)
    else 
        u.anio := valorAlto;
end;

function existe (var arch: archivo; anio: integer): boolean;
var 
    encontre: boolean;
    u: user;
begin 
    encontre := false;
    reset (arch);
    read (arch, u);
    while (not eof(arch) and not encontre) do begin 
        if (u.anio = anio) then 
            encontre := true
        else 
            read (arch, u)
    end;
    existe := encontre;
end;

procedure informar (var arch: archivo);
var 
    totalTiempoDia, totalTiempoMes, totalTiempoAnio, totalTiempoID: real;
    dia, mes, anio, ID: integer;
    u: user;
begin 
    reset (arch);
    writeln ('Ingrese el anio del cual desea ver informacion: ');
    read (anio);
    if (existe(arch, anio)) then begin
        seek (arch, filepos(arch) - 1);
        leer (arch, u);
        writeln ('Anio: ', u.anio);
        totalTiempoAnio := 0;
        anio := u.anio;
        while (anio = u.anio) do begin 
            writeln ('  Mes: ', u.mes);
            totalTiempoMes := 0;
            mes := u.mes;
            while (anio = u.anio) and (mes = u.mes) do begin 
                writeln ('      Dia: ', u.dia);
                totalTiempoDia := 0;
                dia := u.dia;
                while (anio = u.anio) and (mes = u.mes) and (dia = u.dia) do begin 
                    totalTiempoID := 0;
                    ID := u.ID;
                    while (anio = u.anio) and (mes = u.mes) and (dia = u.dia) and (ID = u.ID) do begin
                        totalTiempoID := totalTiempoID + u.tiempo;
                        leer (arch, u);
                    end;
                    writeln ('          IDusuario ', ID , ' Tiempo total de acceso en el dia ', dia, ' mes ', mes, ': ', totalTiempoID:0:2);
                    totalTiempoDia := totalTiempoDia + totalTiempoID;
                end;
                writeln ('      Tiempo total acceso dia ', dia, ' mes ', mes, ': ', totalTiempoDia:0:2);
                totalTiempoMes := totalTiempoMes + totalTiempoDia;
            end;
            writeln ('  Total tiempo de acceso mes ', mes, ': ', totalTiempoMes:0:2);
            totalTiempoAnio := totalTiempoAnio + totalTiempoMes;
        end;
        writeln ('Total tiempo de acceso anio ', anio, ': ', totalTiempoAnio:0:2);
    end
    else 
        writeln ('Anio no encontrado');
    close (arch);
end;

var 
    arch: archivo;
begin 
    importarArchivo (arch);
    informar (arch);
end.






