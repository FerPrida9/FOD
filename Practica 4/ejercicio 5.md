Defina los siguientes conceptos:  
● Overflow  
● Underflow  
● Redistribución  
● Fusión o concatenación  
En los dos últimos casos, ¿cuándo se aplica cada uno?  

**Overflow**  
Ocurre cuando se intenta insertar un elemento en un nodo pero la cantidad de elementos que contiene es igual a la cantidad maxima de elementos que puede tener. En este caso lo que se hace es dividir en nodo en 2, la mitad del lado izquierdo se guarda en el nodo izquierdo, y en la otra mitad el elemento mas chico asciende, si hay un nodo arriba se guarda en ese, si esta lleno el overflow puede propagarse hacia arriba en el arbol, si la division alcanza la raiz y esta se desborda, se crea una nueva raiz y la altura del arbol incrementa en 1. Los restantes de la mitad derecha se guardan en el nodo derecho.  

**Underflow**  
Ocurre cuando se elimina una clave de un nodo y la cantidad de claves del nodo luego de la eliminacion es menor a la cantidad minima de claves permitida (M/2 - 1).  
Las principales estrategias para tratar el underflow son:  
**Redistribucion**  
Se redistribuyen las claves entre el nodo con underflow y uno de sus dos hermanos adyacentes.  
Si uno de sus hermanos adyacentes tiene mas claves del minimo permitido, se puede mover una de sus claves al nodo con underflow, ajustando las claves y punteros adecuadamente  
**Fusion**  
Si la redistribucion no es posible ya que sus hermanos adyacentes tienen el minimo numero de claves, entonces se fusiona el nodo con underflow con uno de sus hermanos adyacentes, reduciendo la cantidad de nodos y en algunos casos, la altura del arbol. 