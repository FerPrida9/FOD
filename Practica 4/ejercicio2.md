2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.

a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.

b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.

c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?

d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.

e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?

f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?

- **A**  
```pascal
const
    M = ..;  // orden del arbol
type 
    alumno = record 
        nombre: string;
        apellido: string;
        DNI: integer;
        legajo: string;
        anio: integer;
    end;

    Tnodo = record 
        cant_claves: integer;
        claves: array [1..M-1] of integer;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
    end;

    TarchivoDatos = file of alumno;
    arbolB = file of Tnodo;

var 
    archivoAlumnos: TarchivoDatos;
    archivoIndice: arbolB;
```

- **B**  
Tnodo = record  
    cant_claves: integer;                // C      
    claves: array [1..M-1] of integer;   // (M-1) * A  
    enlaces: array[1..M-1] of integer;   // (M-1) * A  
    hijos: array[1..M] of integer;       // M * B  
end;  

**Formula:**  
N = (M-1) * A + (M-1) * A + M * B + C   

N = tamaño del nodo  
A = tamaño de un integer  
B = tamaño de cada enlace a un hijo  
C = tamaño del campo de cantidad de claves  
(A, B Y C valen 4 ya que son todos enteros)  

Reemplazo en la formula:    

512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4   
512 = 4M - 4 + 4M - 4 + 4M + 4  
512 = 12M - 4  
512 + 4 = 12M  
516 = 12M  
516/12 = M  
43 = M  

El orden del arbol es 43

- **C**  
Implica que se van a necesitar menos lecturas para encontrar un registro, ya que en un solo nodo  
tenemos 42 indices a registros de alumnos, y en el arbolB del ejercicio 1 solo teniamos 7 registros  
de alumno por nodo, lo que hace que se necesiten realizar mas lecturas para encontrar un registro.  

- **D**  
Lo primero que habria que hacer es abrir el archivo, luego leer la raiz del arbol, una vez leida  
busco el DNI en el vector de claves del nodo, si lo encuentro uso la posicion en la que me encuentro  
en el vector de claves para ubicarme en el vector de enlaces en la posicion que contiene la direccion del  
alumno que estoy buscando. Una vez posicionado leo el enlace, luego abro el archivo donde se encuentran  
los registros de alumnos, me ubico en el registro buscado usando el enlace y finalmente leo el alumno.  
En caso de no encontrar la clave en la raiz, sigo buscando en los hijos hasta encontrarlo y procedo a  
realizar el proceso anteriormente mencionado en caso de encontrarlo.  

- **E**  
Si se desea buscar por num. de legajo no se podria usar el arbol B indice, ya que este esta hecho  
para buscar alumnos por DNI. Por lo tanto tendriamos que buscar el alumno directamente en el archivo  
de alumnos, el cual esta desordenado, lo que implica que no hay ningun criterio de busqueda y por  
consecuencia la busqueda seria muy ineficiente.  
Para brindar acceso indizado crearia un archivo indice como arbol B con la misma idea que el anterior,  
pero con la diferencia de que estaria diseñado para buscar alumnos por numero de legajo.  

- **F**  
El problema que tiene es que resulta muy probable que se tengan que recorrer los mismos nodos varias veces, resultando  
en mas lecturas de las idealmente necesarias.  