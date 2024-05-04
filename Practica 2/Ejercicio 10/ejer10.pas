program ejer10;
const 
    valorAlto = 9999;
type 
    trango = 1..15;

    empleado = record
        departamento: integer;
        division: integer;
        num: integer;
        categoria: integer;
        cantHoras: integer;
    end;

    dato = record 
        categoria: integer;
        valor: real;
    end;

    maestro = file of empleado;

    vector = array [trango] of real;

procedure importarMaestro (var mae: maestro);
var 
    emp: empleado;
    txt: text;
begin 
    writeln ('creando archivo maestro');
    assign (mae, 'maestro.dat');
    rewrite (mae);
    assign (txt, 'maestro.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, emp.departamento, emp.division, emp.num, emp.categoria, emp.cantHoras);
        write (mae, emp);
    end;
    writeln ('archivo maestro creado');
    close (mae);
    close (txt);
end;

procedure cargarVector (var v: vector);
var 
    txt: text;
    reg: dato;
begin 
    writeln ('cargando vector');
    assign (txt, 'valores.txt');
    reset (txt);
    while (not eof(txt)) do begin 
        readln (txt, reg.categoria, reg.valor);
        v[reg.categoria] := reg.valor;
    end;
    writeln ('vector cargado');
    close (txt);
end;

procedure leer (var mae: maestro; var emp: empleado);
begin 
    if (not eof(mae)) then 
        read (mae, emp)
    else 
        emp.departamento := valorAlto;
end;

procedure procesarMaestro (var mae: maestro; var v: vector);
var 
    emp: empleado;
    totalHoras, totalHorasCat, totalHorasDep, totalHorasDiv, numero, division, departamento: integer;
    montoTotal, montoTotalDep, montoTotalDiv: real;
begin 
    reset (mae);
    leer (mae, emp);
    while (emp.departamento <> valorAlto) do begin 
        writeln ('Departamento: ', emp.departamento);
        montoTotalDep := 0;
        totalHorasDep := 0;
        departamento := emp.departamento;
        while (departamento = emp.departamento) do begin 
            writeln ('Division: ', emp.division);
            totalHorasDiv := 0;
            montoTotalDiv := 0;
            division := emp.division;
            while (departamento = emp.departamento) and (division = emp.division) do begin 
                montoTotal := 0;
                totalHoras := 0;
                numero := emp.num;
                while (departamento = emp.departamento) and (division = emp.division) and (numero = emp.num) do begin 
                    totalHoras := totalHoras + emp.cantHoras;
                    totalHorasCat := emp.cantHoras;
                    montoTotal := montoTotal + (v[emp.categoria] * totalHorasCat);
                    leer (mae, emp);
                end;
                writeln ('Numero de empleado: ', numero);
                writeln ('Total horas: ', totalHoras);
                writeln ('Importe a cobrar: ', montoTotal:0:2);
                totalHorasDiv := totalHorasDiv + totalHoras;
                montoTotalDiv := montoTotalDiv + montoTotal;
            end;
            writeln ('Total de horas division: ', totalHorasDiv);
            writeln ('Monto total division: ', montoTotalDiv:0:2);
            totalHorasDep := totalHorasDep + totalHorasDiv;
            montoTotalDep := montoTotalDep + montoTotalDiv;
        end;
        writeln ('Total horas departamento: ', totalHorasDep);
        writeln ('Monto total departamento: ', montoTotalDep:0:2);
    end;
    close (mae);
end;

var 
    mae: maestro;
    v: vector;
begin 
    importarMaestro (mae);
    cargarVector (v);
    procesarMaestro (mae, v);
end.