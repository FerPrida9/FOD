{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenad
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 15
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá lista
contenido del archivo en pantalla.}

Program ejer2;

Type 
    file_integers = file Of integer;

Var 
    archivo_enteros: file_integers;
    num, cantMayores, cantTotal, sumaTotal, cant: integer;
    nombre: string;
    promedio: real;
Begin
    writeln ('ingrese el nombre del archivo que quiere procesar');
    read (nombre);
    assign (archivo_enteros, nombre);
    reset (archivo_enteros);
    cant := 0;
    sumaTotal := 0;
    while (Not EOF (archivo_enteros)) Do
  Begin
        read (archivo_enteros, num);
        If (num > 1500) Then
          cant := cant + 1;
                  sumaTotal := sumaTotal + num;
        cantTotal := cantTotal + 1;
    End;
    promedio := sumaTotal/cantTotal;
    writeln ('la cantidad de numeros mayores a 1500 es: ', cant);
    writeln ('el promedio de los numeros ingresados es: ', promedio:0:2);
End.
