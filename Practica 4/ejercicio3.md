**3**  
Los árboles B+ representan una mejora sobre los árboles B dado que conservan la  
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,  
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,  
considere que por un lado se tiene el archivo que contiene la información de los  
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado  
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como  
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los  
siguientes incisos:

a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?

b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
qué?

c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño

d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
específico haciendo uso de la estructura auxiliar (índice) que se organiza como
un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
estructurado como un árbol B?

e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?

- **A**  
En un arbol B+ los elementos (claves) siempre se encuentran en las hojas, y los  
nodos internos contienen referencias o copias de las claves para mantener el  
orden del arbol.  

- **B**  
La caracteristica que presentan los nodos hojas es que estos son los que contienen  
las claves reales del arbol, y ademas estos tienen un puntero al nodo adyacente derecho  
(o a ambos nodos adyacentes) lo que permite recorrer todo el arbol de forma secuencial.

- **C**  
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

    tarchivo = file of alumno;

    tlista = ^tnodo;

    tnodo = record 
        cantclaves: integer;
        claves: array[1..M-1] of integer;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M-1] of integer;
        sig: tlista;
    end;

    arbolB+ = file of tnodo;

var 
    archivoDatos: tarchivo;
    archivoIndice: arbolB+;
```

- **D**  
**Inicio en la raiz:**  
- La busqueda comienza en el nodo raiz del arbol B+.  

**Desplazamiento por niveles:**  
- En cada nodo interno se compara la clave buscada con cada una de las claves almacenadas en el vector de claves del nodo.  
- Si la clave buscada es mas chica que la primer clave del vector, entonces se sigue el primer puntero. Si esta entre dos claves, se sigue el puntero correspondiente entre esas 2 claves, y asi sucesivamente hasta encontrar el puntero adecuado.  

**Descenso hasta un nodo hoja:**  
- Este proceso de comparacion y seleccion de punteros continua hasta llegar a un nodo terminal (hoja)  

**Busqueda en un nodo hoja**  
- Una vez que se llega a un nodo terminal, se busca la clave en el vector de claves del nodo. Si encuentra la clave, entonces toma la posicion del vector de claves en donde se encuentra, usa esa posicion para posicionarse en el vector de enlaces donde se encuentra la referencia al alumno, y con ese enlace accede al archivo de alumnos y guarda los datos del alumno con tan solo un acceso.  
La diferencia con la busqueda en un arbol B es que en el arbol B+ podemos encontrar la clave en un nodo interno, pero aun asi la busqueda tiene que continuar hasta un nodo hoja ya que las claves en los nodos terminales son copias, y puede ocurrir que exista la copia pero no exista la clave verdadera.  

- **E**  
El proceso consiste primero en encontrar la clave 40000000 o mayor, para lo cual se debe llegar a una hoja. Una vez identificada la clave, se van leyendo de a una las claves de ese nodo de a una ya que estas estan ordenadas de menor a mayor. Cuando termino de recorrer las claves de ese nodo, me muevo a la siguiente hoja ya que estas estan enlazadas. Continuo leyendo y moviendome entre las hojas secuencialmente hasta encontrar la clave 45000000, o hasta encontrar una clave mayor, lo que determina que la busqueda termino.  
La ventaja que encuentro frente al arbol B es que se evita leer mas de una vez el mismo nodo.  