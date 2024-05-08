{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

program ejer1;

Type 
    empleado = Record
                 nro: integer;
                 apellido: string;
                 nombre: string;
                 edad: integer;
                 DNI: integer;
    End;

    file_empleados = file Of empleado;

Procedure asignar (Var archivo_empleados: file_empleados);

Var 
    nombre: string;
Begin
    writeln ('ingrese el nombre que desea ponerle al archivo');
    read (nombre);
    assign (archivo_empleados, nombre);
End;

Procedure leerEmpleado (Var emp: empleado);
Begin
  writeln ('ingrese el numero de empleado');
  readln (emp.nro);
  writeln ('ingrese el apellido del empleado');
  readln (emp.apellido);
  If (emp.apellido <> 'fin') Then
    Begin
      writeln ('ingrese el nombre del empleado');
      readln (emp.nombre);
      writeln ('ingrese la edad del empleado');
      readln (emp.edad);
      writeln ('ingrese el DNI del empleado');
      readln (emp.DNI);
    End;
End;

Procedure cargar (Var archivo_empleados: file_empleados);

Var 
    emp: empleado;
Begin
    rewrite (archivo_empleados);
    leerEmpleado (emp);
    while (emp.apellido <> 'fin') Do
  Begin
        write (archivo_empleados, emp);
        leerEmpleado (emp);
    End;
    close (archivo_empleados)
End;

Procedure mostrarEmpleado (Var emp: empleado);
Begin
    writeln ('numero: ', emp.nro);
    writeln ('apellido: ', emp.apellido);
    writeln ('nombre: ', emp.nombre);
    writeln ('edad: ', emp.edad);
    writeln ('DNI: ', emp.DNI);
End;

Procedure buscarEmpleado (Var archivo_empleados: file_empleados);

Var 
    dato: string;
    emp: empleado;
Begin
    reset (archivo_empleados);
    writeln ('ingrese el nombre/apellido del empleado que desea buscar');
    readln (dato);
    while (Not EOF (archivo_empleados)) Do
  Begin
        read (archivo_empleados, emp);
        If (emp.nombre = dato) Or (emp.apellido = dato) Then
            mostrarEmpleado (emp);
    End;
    close (archivo_empleados);
End;

  Procedure listarEmpleados (Var archivo_empleados: file_empleados);

  Var 
    emp: empleado;
  Begin
    reset (archivo_empleados);
    writeln ('los empleados guardados son: ');
    while (Not EOF(archivo_empleados)) Do
    Begin
        read (archivo_empleados, emp);
        mostrarEmpleado (emp);
    End;
    close (archivo_empleados);
  End;

  Procedure listarMayores (Var archivo_empleados: file_empleados);

  Var 
    emp: empleado;
  Begin
    reset (archivo_empleados);
    writeln ('los empleados mayores a 70 años son:');
    while (Not EOF (archivo_empleados)) Do
    Begin
        read (archivo_empleados, emp);
        If (emp.edad >= 70) Then
          mostrarEmpleado (emp);
    End;
    close (archivo_empleados);
  End;

function existe (var archivo_empleados: file_empleados; num: integer): Boolean;
var 
    flag: boolean;
    emp: empleado;
begin 
    reset (archivo_empleados);
    flag := false;
    while (not EOF (archivo_empleados)) do begin 
        read (archivo_empleados, emp);
        if (emp.nro = num) then begin 
            flag := true;
            break;
        end;
    end;
    existe := flag;
end;

procedure agregarEmpleado (var archivo_empleados: file_empleados);
var
    emp: empleado;
    opcion: string;
begin
    reset (archivo_empleados);
    seek (archivo_empleados, FileSize(archivo_empleados));
    leerEmpleado (emp);
    while (emp.apellido <> 'fin') do begin 
        if (existe(archivo_empleados, emp.nro)) then
            writeln ('el empleado ingresado ya existe')
        else
            write (archivo_empleados, emp);
        writeln ('');
        writeln ('desea ingresar otro empleado? (si/no)');
        readln (opcion);
        if (opcion = 'no') then
            Break
        else
            leerEmpleado (emp);
    end;
    close (archivo_empleados);
end;

procedure modificarEdad (var archivo_empleados: file_empleados);
var 
    emp: empleado;
    found: boolean;
    num, edad: integer;
begin 
    found := false;
    reset (archivo_empleados);
    writeln ('ingrese el numero del empleado que desea modificar');
    readln (num);
    while (not EOF (archivo_empleados)) do begin 
        read (archivo_empleados, emp);
        if (emp.nro = num) then begin 
            found := true;
            break;
        end;
    end;
    if (found) then begin
        writeln ('ingrese la nueva edad');
        readln (edad);
        seek (archivo_empleados, FilePos (archivo_empleados) - 1);
        emp.edad := edad;
        write (archivo_empleados, emp);
    end
    else begin
        writeln ('el empleado numero ', num, ' no existe');    
    end;
    close (archivo_empleados);
end;

procedure exportarContenido (var archivo_empleados: file_empleados);
var 
    txt: Text;
    emp: empleado;
begin
    reset (archivo_empleados);
    assign (txt, 'todos_empleados.txt');
    Rewrite (txt);
    while (not EOF (archivo_empleados)) do begin 
        read (archivo_empleados, emp);
        writeln (txt, ' ',emp.nro,' ',emp.apellido,' ',emp.nombre,' ',emp.edad,' ',emp.DNI);
    end;
    close (archivo_empleados);
    close (txt);
end;

procedure exportarEmpSinDNI (var archivo_empleados: file_empleados);
var 
    txt: text;
    emp: empleado;
begin 
    reset (archivo_empleados);
    assign (txt,'faltaDNIEmpleado.txt');
    rewrite (txt);
    while (not EOF (archivo_empleados)) do begin 
        read (archivo_empleados, emp);
        if (emp.DNI = 00) then begin 
            writeln (txt, ' ',emp.nro,' ',emp.apellido,' ',emp.nombre,' ',emp.edad,' ',emp.DNI);
        end;
    end;
    Close (archivo_empleados);
    Close (txt);
end;

procedure buscar (var archivo_empleados: file_empleados; num: integer; var pos: integer; var encontre: boolean);
var 
    emp: empleado;
begin 
    reset (archivo_empleados);
    encontre := false;
    while (not eof(archivo_empleados) and (not encontre)) do begin 
        read (archivo_empleados, emp);
        if (emp.nro = num) then begin
            encontre := true;
            pos := filepos (archivo_empleados) - 1;
        end;
    end;
    close (archivo_empleados);
end;
        
procedure eliminarEmpleado (var archivo_empleados: file_empleados);
var 
    emp: empleado;
    pos, num: integer;
    encontre: boolean;
begin 
    writeln ('Ingrese el numero del empleado que desea eliminar: ');
    readln (num);
    buscar (archivo_empleados, num, pos, encontre);
    if (encontre) then begin 
        reset (archivo_empleados);
        seek (archivo_empleados, filesize(archivo_empleados) - 1);
        read (archivo_empleados, emp);
        seek (archivo_empleados, pos);
        write (archivo_empleados, emp);
        seek (archivo_empleados, filesize(archivo_empleados) - 1);
        truncate (archivo_empleados);
        close (archivo_empleados);
        writeln ('Se ha eliminado el empleado del archivo');
    end
    else 
        writeln ('No se encontro un empleado con ese numero');
end;

  Procedure menuOpciones (Var archivo_empleados: file_empleados);

  Var 
    opcion: integer;
  Begin
    while (true) Do
    Begin
        writeln ('ingrese la opcion deseada:');
        writeln ('1: buscar empleado');
        writeln ('2: listar empleados');
        writeln ('3: listar empleados mayores a 70 años');
        writeln ('4: agregar empleado/empleados');
        writeln ('5: modificar edad de un empleado');
        writeln ('6: exportar contenido a un archivo .txt');
        writeln ('7: exportar empleados sin DNI a un archivo txt');
        writeln ('8: Eliminar un empleado del archivo');
        writeln ('9: finalizar programa');
        readln (opcion);
        Case opcion Of
            1: buscarEmpleado (archivo_empleados);
            2: listarEmpleados (archivo_empleados);
            3: listarMayores (archivo_empleados);
            4: agregarEmpleado (archivo_empleados);
            5: modificarEdad (archivo_empleados);
            6: exportarContenido (archivo_empleados);
            7: exportarEmpSinDNI (archivo_empleados);
            8: eliminarEmpleado (archivo_empleados);
            9: break
        End;
    End;
End;

    Var 
      archivo_empleados: file_empleados;
    Begin
      asignar (archivo_empleados);
      cargar (archivo_empleados);
      menuOpciones (archivo_empleados);
    End.