{Realizar un algoritmo que cree un archivo de números enteros no ordenados y pe
incorporar datos al archivo. Los números son ingresados desde teclado. La carga
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nomb
archivo debe ser proporcionado por el usuario desde teclado.}

Program ejer1;

Type 
    file_integers = file Of integer;

Var 
    archivo_enteros: file_integers;
    num: integer;
    nombre: string;
Begin
    writeln ('ingrese el nombre que desea ponerle al archivo');
    readln (nombre);
    assign (archivo_enteros, nombre);
    rewrite (archivo_enteros);
    writeln ('ingrese numeros, 30000 para cortar la carga');
    readln (num);
    while (num <> 30000) Do
  Begin
        write (archivo_enteros, num);
        readln (num);
    End;
    close (archivo_enteros);
End.
