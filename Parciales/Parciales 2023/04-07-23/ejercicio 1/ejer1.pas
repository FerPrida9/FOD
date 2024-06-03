program ejer1;
const 
    valorAlto = 9999;
type 
    partido = record 
        codigoEquipo: integer;
        nombreEquipo: string;
        anio: integer;
        codigoTorneo: integer;
        codigoRival: integer;
        golesAFavor: integer;
        golesEnContra: integer;
        puntos: integer;         // 0 si perdio, 1 si empato y 3 si gano 
    end;

    archivo = file of partido;

procedure importarArchivo (var arch: archivo);
var 
    txt: text;
    p: partido;
begin 
    assign (arch, 'partidos');
    rewrite (arch);
    assign (txt, 'partidos.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        with p do begin
            readln(txt, codigoEquipo, codigoRival, codigoTorneo, golesAFavor, golesEnContra, puntos, nombreEquipo);
            readln(txt, anio);
        end;
        write (arch, p);
    end;
    writeln ('archivo binario creado');
    close (arch);
    close (txt);
end;

procedure leer (var arch: archivo; var p: partido);
begin 
    if (not eof(arch)) then 
        read (arch, p)
    else 
        p.anio := valorAlto;
end;

procedure informar (var arch: archivo);
var 
    p: partido;
    diferenciaDeGol, anio, codigoTorneo, maxPuntos, codigoEquipo, golesAFavor, golesEnContra, partidosGanados, partidosPerdidos, partidosEmpatados, totalPuntos: integer;
    nombreEquipo, campeon: string;
begin 
    reset (arch);
    leer (arch, p);
    while (p.anio <> valorAlto) do begin 
        writeln ('Anio: ', p.anio);
        anio := p.anio;
        while (p.anio = anio) do begin 
            writeln ('  cod_torneo: ', p.codigoTorneo);
            codigoTorneo := p.codigoTorneo;
            maxPuntos := -1;
            while (p.anio = anio) and (p.codigoTorneo = codigoTorneo) do begin 
                writeln ('      cod_equipo ', p.codigoEquipo, ' nombre equipo ', p.nombreEquipo);
                codigoEquipo := p.codigoEquipo;
                nombreEquipo := p.nombreEquipo;
                golesAFavor := 0;
                golesEnContra := 0;
                partidosGanados := 0;
                partidosPerdidos := 0;
                partidosEmpatados := 0;
                totalPuntos := 0;
                while (p.anio = anio) and (p.codigoTorneo = codigoTorneo) and (p.codigoEquipo = codigoEquipo) do begin 
                    golesAFavor := golesAFavor + p.golesAFavor;
                    golesEnContra := golesEnContra + p.golesEnContra;
                    if (p.puntos = 0) then 
                        partidosPerdidos := partidosPerdidos + 1
                    else if  (p.puntos = 1) then 
                        partidosEmpatados := partidosEmpatados + 1
                    else 
                        partidosGanados := partidosGanados + 1;
                    diferenciaDeGol := golesAFavor - golesEnContra;
                    totalPuntos := totalPuntos + p.puntos;
                    leer (arch, p);
                end;
                writeln ('          cantidad total de goles a favor: ', golesAFavor);
                writeln ('          cantidad total de goles en contra: ', golesEnContra);
                writeln ('          diferencia de gol: ', diferenciaDeGol);
                writeln ('          cantidad de partidos ganados: ', partidosGanados);
                writeln ('          cantidad de partidos perdidos: ', partidosPerdidos);
                writeln ('          cantidad de partidos empatados: ', partidosEmpatados);
                writeln ('          cantidad total de puntos: ', totalPuntos);
                if (totalPuntos > maxPuntos) then begin 
                    maxPuntos := totalPuntos;
                    campeon := nombreEquipo;
                end;
            end;
            writeln ('  el equipo ', campeon, ' fue campeon del torneo ', codigoTorneo, ' del anio ', anio);
        end;
    end;
    close (arch);
end;

var 
    arch: archivo;
begin 
    importarArchivo (arch);
    informar (arch);
end.