1. Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M.

a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
alumnos como un árbol B de orden M.

b. Suponga que la estructura de datos que representa una persona (registro de
persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el
valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
(en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número
entero, ignorar la parte decimal).

c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
información de los alumnos como un árbol B?

d. ¿Qué dato seleccionaría como clave de identificación para organizar los
elementos (alumnos) en el árbol B? ¿Hay más de una opción?

e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
encontrar un alumno por su clave de identificación en el peor y en el mejor de
los casos? ¿Cuáles serían estos casos?

f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas
lecturas serían necesarias en el peor de los casos?

- **A**
```pascal
const 
    M = ..; // orden del arbol
type 
    alumno = record 
        nombre: string;
        apellido: string;
        DNI: integer;
        legajo: string;
        anio: integer;
    end;

    Tnodo = record 
        cant_datos: integer;
        datos: array[1..M-1] of alumno;
        hijos: array[1..M] of integer;
    end;

    arbolB = file of Tnodo;

var 
    archivoDatos: arbolB;
```

- **B**
    - N = 512 bytes
    - A = 64 bytes
    - B = 4 bytes
    - c = 4 bytes 
    
    Reemplazo en la formula y resuelvo para averiguar el valor de M:

    N = (M-1) * A + M * B + C

    512 = (M-1) * 64 + M * 4 + 4  
    512 = 64M - 64 + 4M + 4  
    512 = 64M + 4M - 64 + 4  
    512 = 68M - 60  
    512 + 60 = 68M  
    572 = 68M  
    572/68 = M  
    8,4 = M  

    M = 8    // Me quedo con la parte entera

    TNodo = record  
        cant_datos : integer; // Ocupa 4 bytes  
        datos : array[1..M-1] of persona; // Ocupa 7*64 bytes  
        hijos : array[1..M] of integer; // Ocupa 8*4 Bytes  
    end;  
**Conclusion:**  
 512 - ((7*64) + (8*4) + 4) = 28 ---> Por lo tanto entran 7 registros persona y sobran 28 bytes

- **C**  
    Organizar el archivo como un arbol B no tiene ningun impacto sobre  
    el valor de M

- **D**  
    Usaria como clave el DNI de los alumnos ya que no se repite.  
    Tambien podria usarse el legajo.

- **E**  
    **Mejor caso:**  
    La clave que busco se encuentra en la raiz = 1 lectura  
    
    **Peor caso:**  
    La clave que busco se encuentra en una hoja = 1 lectura * altura del arbol

- **F**  
    Lo que ocurre es que no aprovechariamos el ordenamiento del arbol.  
    En el peor de los casos se necesitarian tantas lectura como nodos tenga el arbol.




 
 




    
    


















