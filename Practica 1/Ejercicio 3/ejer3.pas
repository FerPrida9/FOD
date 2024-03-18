{Realizar un programa que presente un menú con opciones para:

 a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre,edad y DNI. Algunos empleados se ingresan con DNI 00.
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00
La carga finaliza cuando se ingresa el String  ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado

ii. Listar en pantalla los empleados de a uno por línea

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse

 }

Program ejer3;

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
        writeln ('4: finalizar el programa');
        readln (opcion);
        Case opcion Of
            1: buscarEmpleado (archivo_empleados);
            2: listarEmpleados (archivo_empleados);
            3: listarMayores (archivo_empleados);
            4: break
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
