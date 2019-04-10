# Memoria Práctica 3

### Pareja 4 Grupo 2302

Santiago Valderrábano Zamorano | Martín de las Heras Moreno
------------------------------ | --------------------------
santiago.valderrabano@estudiante.uam.es | martin.delasheras@estudiante.uam.es


<br>
<hr>

## Índice

  * Ejercicio 1

  * Ejercicio 2

  * Ejercicio 3

  * Ejercicio 4

  * Ejercicio 5

  * Ejercicio 6

  * Ejercicio 7

    * Apartado 7.1

    * Apartado 7.2

    * Apartado 7.3

  * Ejercicio 8

    * Apartado 8.1

    * Apartado 8.2

    * Apartado 8.3

  <br>
  <hr>
  <br>

### Ejercicio 1

En este ejercicio se nos pide una función que dadas dos listas devuelva *True* en caso de que se proporcione solamente una de las dos listas, el programa devolverá el valor necesario de la otra lista para que devuelva *True* la función.

Nuestra función va comparando su primer elemento con los dos primeros de la segunda lista y después hace una llamada recursiva a sí misma con el resto de las listas, en el caso base hay dos listas vacías lo cual devolvería *True*.

```prolog
duplica([], []).
% Si son iguales el primer elemento de L y los dos primeros de L1 hace una
% llamada recursiva.
duplica([X | L], [X , X | L1]) :- duplica(L, L1).
```
<br>

  ##### Ejemplos:

```prolog
duplica([1,2,3], [1,1,2,2,3,3]).
true

duplica([1,2,3], [1,1,2,3,3]).
false

duplica([1,2,3], L1).
L1 = [1, 1, 2, 2, 3, 3]

duplica(L, [1,2,3]).
false

duplica(L, [1,1,2,2,3,3]).
L = [1, 2, 3]

duplica(L, [1,1,2,2,3,3,4]).
false

duplica([1,2], L1).
L1 = [1, 1, 2, 2]

duplica([1,2], []).
false

duplica([], []).
true
```

---
### Ejercicio 2

En este ejercicio se nos pide una función que dadas dos listas devuelva *True* en caso de que una sea la inversa de la otra, o en caso de que solo se le proporcione una de las listas devuelve el valor que tiene que tener la otra para que la función devuelva *True*.

En nuestra función hacemos uso de la función **concatena** proporcionada en el enunciado para que la función **invierte** concatene los elementos del último al primero de la lista inicial dando así de resultado la lista invertida.


```prolog
%% Esto nos lo daban hecho
concatena([], L, L).
concatena([X | L1], L2, [X | L3]) :- concatena(L1,L2,L3).

% Código nuestro

invierte([], []).
% Una vez llega al final de la lista por invierte va llamando a concatena y
% creando la lista nueva invertida.
invierte([X | L], R) :- invierte(L, P), concatena(P, [X], R).
```

<br>

  ##### Ejemplos:

```prolog
invierte([1,2], L).
L = [2, 1]

invierte([], L).
L = []

invierte(L, [1,2]).
L = [2, 1]

invierte(L, [1]).
L = [1]

invierte([3,2,1], [1,2,3]).
true

invierte([3,2,1], [1,2,3,4]).
false

invierte([1,2,3], [1,2,3]).
false

invierte([1,2,3], []).
false
```

---
### Ejercicio 3

En este ejercicio se pide implementar una función que te devuelva *True* cuando la lista introducida es un palíndromo.

Como una lista palíndroma es su misma inversa, simplemente le pasamos la lista como los dos argumentos a la función **invierte** y esta devolverá *True* solamente cuando sea su misma inversa y por tanto palíndroma.

```prolog
% Llama a invierte y esta devuelve True si es la misma lista invertida.
palindromo([]).
palindromo(L) :- invierte(L,L).
```

<br>

  ##### Ejemplos:

```prolog
palindromo([1,2,1]).
true

palindromo([1,2,1,1]).
false

palindromo([1,1,1,1]).
true

palindromo([]).
true

palindromo([1,2,3]).
false

% Al llamar a la función con una variable no inicializada esta devuelve simplemente una lista vacía.
palindromo(L).
L = []
```

---
### Ejercicio 4

En este ejercicio se nos pide implementar una función que reciba como argumentos tres listas y un número y devuelva *True* cuando la lista principal tenga como primeros elementos los mismos de la primera lista y el resto de la segunda y el tamaño de la primera lista sea el número pasado.

En nuestra función se van eliminando elementos de la lista principal y la de los elementos del principio mientras va decrementando el número con el tamaño, tras esto llega al caso base que es el número es un 0 y la lista del principio está vacía y l lista restante es igual a la principal. Tras esto irá concatenando los elementos que ha eliminado hasta la salida.

```prolog
divide(L, 0, [], L).
% Decrementa N hasta el caso base y luego va concatenando y comprobando.
divide([X | L], N, L1, L2) :- N1 is N - 1, divide(L, N1, P, L2), concatena([X], P, L1).
```

<br>

  ##### Ejemplos:

```prolog
divide([1,2,3,4,5], 3, L1, L2).
L1 = [1, 2, 3],
L2 = [4, 5]

divide(L, 3, [1,2,3], [4,5,6]).
L = [1, 2, 3, 4, 5, 6]

divide([1,2,3,4,5,6], 3, [1,2,3], [4,5,6]).
true

divide([1,2,3,4,5,6], 3, [1,2,3], []).
false

divide([1,2,3], 3, [1,2,3], []).
true

divide([1,2,3], 0, [], [1,2,3]).
true

divide([1,2,3], 0, [], [1,3]).
false

divide([1,2,3], 1, [1], [2,3]).
true
```

---
### Ejercicio 5

En este ejercicio se nos pide implementar una función que devuelve *True* cuando la segunda lista pasada (L1) es la versión *aplastada* de la primera lista (L), es decir que los elementos individuales (no como listas) de las dos listas son los mismos en el mismo orden.

Nuestra función recorre la lista por elementos y en caso de que uno de ellos sea una lista lo recorre de igual manera y va comparando con la otra lista para comprobar si tiene los mismos elementos atómicos.

```prolog
% Va recorriendo los elementos de la lista y en caso de que el elemento sea una
% lista la recorre a su vez, todo esto comparando con los elementos de la otra
% lista.
aplasta(L,[L]) :- \+ is_list(L)
aplasta([], []).
aplasta([L|L1], LAplastado) :-
    aplasta(L, NuevaL),
    aplasta(L1, NuevaLs),
    append(NuevaL, NuevaLs, LAplastado).
```

<br>

  ##### Ejemplos:

```prolog
aplasta([1, [2, [3, 4], 5], [6, 7]], L).
L = [1, 2, 3, 4, 5, 6, 7]

aplasta([[[[1]],2], 3], [1,2,3]).
true

aplasta([[[[1,2]],2], 3], [1,2,3]).
false

aplasta([[[[1]],2], 3, 4], [1,2,3,4]).
true

aplasta([[[[1]],2], 3, 4], L).
L = [1, 2, 3, 4]

% En caso de hacer esto el programa no devuelve nada ya que no hay una sola solución válida
aplasta(L,[1, 2, 3])
```

---
### Ejercicio 6

Esta función, dados un número y una lista de números primos nos pide que devolvamos *True* en caso de que la lista sean sus factores primos, en caso de pasar un valor no definido para la lista, este devuelve el valor necesario de la lista para que devuelva *True*.

Nuestra función en el caso base tiene como argumentos 1 y una lista vacía, ya que cuando llegamos al 1 no tenemos más factores y el 1 no tiene que estar en la lista de factores. En caso contrario recibe como argumentos un número y una lista de factores primos, entonces comprueba que el primer elemento de la lista sea factor del número grande, tras lo cual realiza una llamada recursiva a sí misma pero pasando el resto de la lista de factores y como número el cociente de la división entre ambos.

```prolog
% next_factor(N,F,NF) :- when calculating the prime factors of N
%    and if F does not divide N then NF is the next larger candidate to
%    be a factor of N.

next_factor(_,2,3) :- !.

next_factor(N,F,NF) :-
  F * F < N,         % F < sqrt(N)
  !,
  NF is F + 2.

next_factor(N,_,N).

% primos(N, L) :- L es la lista de factores primos N.
% Primero comprueba que N sea mayor que 0.
% Si lo es, llama a primos(N, L, 2)

primos(N, L) :-
  N > 0,
  primos(N,L,2).

% primos(N,L,K) :- L es la lista de factores primos N. K es el primo a comprobar
% Si N es 1 devuelve una lista vacia ya que uno no se contempla como factor.

primos(1,[],_) :- !.

primos(N,[Factor|L], Factor) :-
    Cociente is N // Factor,
    N =:= Cociente * Factor,
    !,
    primos(Cociente,L,Factor).

primos(N,L,F) :-
   F < N,
   next_factor(N,F,NF),
   primos(N,L,NF).
```

<br>

  ##### Ejemplos:

```prolog
primos(100,L).
L = [2, 2, 5, 5]

primos(N,[2,2,5,5]).
>/2: Arguments are not sufficiently instantiated

primos(6,[2,3]).
true

primos(100,[2,2,5,5]).
true

primos(100,[2,5,5]).
primos(100,[2,5,5]).
false

primos(100,[2,2,5]).
false

primos(100,[3,5,5]).
primos(100,[3,5,5]).
false

primos(100,[4,5,5]).
false

primos(6,[3,2]).
false
```

---
### Ejercicio 7


#### Apartado 7.1

Esta función dada una lista de elementos y un elemento, devuelve *True* si en Lfront está una lista del elemento repetido tantas veces como esté seguidas en el principio de la lista y en Lrem el resto de la lista. En caso de que no se pase Lrem o Lfront se devolverá los valores que requiera para devolver *True*.

Nuestra función va recorriendo el principio de la lista comparando los valores del principio de la lista y de Lfront y al no encontrar más comprueba que lo que quede en la lista sea igual que Lrem.

```prolog
% Primero miramos si la lista que nos pasan para buscar copias esta vacia, si
% es así, entonces devovlemos una lista con el elemento X como Lfront.
% El sigueinte caso es comparar el primer elemento de la lista que nos pasan
% con el que estamos buscando. Si son distintos, al estar la lista que se pasa
% ordenada, habremos acabado. Si son iguales pasamos al ultimo caso. Este
% consiste en meter en llamar de nuevo a cod_primero con el rsto de la lista
% y al hacer la recursión de vuelta es domnde metemos en la lista Lfront todos
% los elementos repetidos.

cod_primero(X,[],[],[X]).

cod_primero(X,[Y|Rem],[Y|Rem],[X]) :-
  X \= Y.

cod_primero(X,[X|L],Rem,[X|Front]) :-
  cod_primero(X,L,Rem,Front).
```

##### Ejemplos:

```prolog
cod_primero(1, [1, 1, 2, 3], Lrem, Lfront).
Lfront = [1, 1, 1],
Lrem = [2, 3]
false

cod_primero(1, [2, 3, 4], Lrem, Lfront).
Lfront = [1],
Lrem = [2, 3, 4]
false

cod_primero(2, [1, 2, 3, 4], Lrem, Lfront).
Lfront = [2],
Lrem = [1, 2, 3, 4]
false

cod_primero(1, [1, 2, 3, 4], [2, 3, 4], [1, 1]).
true
false

cod_primero(1, [1, 1, 2, 3, 4], [2, 3, 4], [1, 1]).
false
```

#### Apartado 7.2

En este apartado se pide lo mismo que en el anterior pero que en vez de hacerlo para los elementos del principio de la lista que lo haga para cada elemento diferente.

Nuestra función va llamando a **cod_primero** de manera recursiva y creando la lista de listas (equivalentes a Lfront del apartado anterior).

```prolog
% Caso base las dos listas están vacías.
cod_all([],[]).

% Recorre la primera lista y va llamando a cod_primero por cada elemento nuevo
% que encuentra.
cod_all([X|L],[Y|L1]):-
  cod_primero(X, L, Lrem, Y),
  cod_all(Lrem, L1).
```

##### Ejemplos:

```prolog
cod_all([1, 1, 2, 3, 3, 3, 3], L).
L = [[1, 1], [2], [3, 3, 3, 3]]
false

cod_all([1, 2, 2, 3, 3, 4, 4, 4, 5], L).
L = [[1], [2, 2], [3, 3], [4, 4, 4], [5]]
false

cod_all([1, 1, 2, 3, 3, 3, 3], [[1, 1], [2], [3, 3, 3, 3]]).
true
false

cod_all([1, 1, 2, 3, 3, 3, 3], [[1, 1], [2], [3, 3, 3], [4]]).
cod_all([1, 1, 2, 3, 3, 3, 3], [[1, 1], [2], [3, 3, 3], [4]]).
false

cod_all([], L).
L = []
```

#### Apartado 7.3

En este apartado finalmente se nos pide que en vez de la lista con todos los elementos repetidos devolvamos una tupla (n, e) donde *n* es el número de veces que aparece repetido el elemento *e* y *e* es el elemento.

Nuestra función simplemente llama a **cod_all** y luego, por cada elemento de la lista (que es a su vez una lista) cuenta el número de veces que el elemento aparece y devuelve la tupla generada.

```prolog
% Funcion que cuenta el numero de veces que esta el elemento en la lista y
% genera la tupla correspondiente
contar([],[]).

contar([[X|RestX]|L], [[N,X]|L1]) :-
  length([X|RestX], N),
  contar(L, L1).

% Funcion que llama a cod_all y a contar para que genere la lista de tuplas.
run_length([],[]).

run_length(L, L1):-
  cod_all(L, L2),
  contar(L2, L1).
```

<br>

  ##### Ejemplos:

```prolog
run_length([1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 5, 5], L).
L = [[4, 1], [1, 2], [2, 3], [5, 4], [2, 5]]
false

run_length([1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 5, 5], []).
false

run_length([1, 1, 3, 3, 4, 4, 4, 4, 4, 5, 5], L).
run_length([1, 1, 3, 3, 4, 4, 4, 4, 4, 5, 5], L).
L = [[2, 1], [2, 3], [5, 4], [2, 5]]
false

run_length([1, 1, 3, 3, 4, 4, 4, 4, 4, 5, 5], [[2, 1], [2, 1], [2, 3], [5, 4], [2, 5]]).
false

run_length([1, 1, 3, 3, 4, 4, 4, 4, 4, 5, 5], [[2, 1], [2, 3], [5, 4], [2, 5]]).
true
false

run_length([], [[2, 1], [2, 3], [5, 4], [2, 5]]).
false

run_length([], L).
L = []
```

---
### Ejercicio 8

Esta función nos pide que dada una lista de nodos, nos devuelva su árbol de Huffman creado.

Nuestra función dada la lista pasada nos va creando los nodos y anexándolos al árbol que ha ido generando.

```prolog
%Caso base
build_tree([], nil).

% En caso de que no queden mas elementos en la lista de nodos se para.
build_tree([Nodo-_], tree(Nodo, nil, nil)):- !.

% Va recorriendo los nodos y metiendolos en el arbol.
build_tree([Nodo-_|Resto], T) :-
    build_tree(Resto, TAux),
    T = tree(1, tree(Nodo, nil, nil), TAux).
```

  ##### Ejemplos:

```prolog
build_tree([], X).
X = nil

build_tree([p-0], X).
X = tree(p, nil, nil)

build_tree([p-0, a-6, g-7, p-9, t-2, 9-99], X).
X = tree(1, tree(p, nil, nil), tree(1, tree(a, nil, nil), tree(1, tree(g, nil, nil), tree(1, tree(p, nil, nil), tree(1, tree(t, nil, nil), tree(9, nil, nil))))))

build_tree([p-55, a-6, g-7, p-9, t-2, 9-99], X).
X = tree(1, tree(p, nil, nil), tree(1, tree(a, nil, nil), tree(1, tree(g, nil, nil), tree(1, tree(p, nil, nil), tree(1, tree(t, nil, nil), tree(9, nil, nil))))))

build_tree([p-55, a-6, g-2, p-1], X).
X = tree(1, tree(p, nil, nil), tree(1, tree(a, nil, nil), tree(1, tree(g, nil, nil), tree(p, nil, nil))))

build_tree([a-11, b-6, c-2, d-1], X)
X = tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))
```
#### Apartado 8.1

Esta función dado dos elementos, comprueba si el segundo elemento es la codificación en el árbol de Huffman del primero, y en ese caso devuelve *True*.

Nuestra función comprueba si ha llegado al nodo hoja y le concatena un *0* o un *1* en función de si la hoja a la que se ha llegado está por la parte izquierda o no.

```prolog
% En este caso es que ya ha llegado al nodo hoja de la parte izquierda y por
% tanto, concatena un 0.

encode_elem(X1, X2, tree(1, tree(X1, nil, nil), _)) :-
  concatena([0], [], X2).

% En este caso, el arbol está compuesto por un único nodo. Este tambien sería
% el caso en el que se llega a un nodo hoja que está en la derecha.

encode_elem(X1, [], tree(X1, nil, nil)) :- !.

% Este ultimo caso es en el que se llega a un nodo intermedio y sigue habiendo
% mas nodos que "explorar" (Resto) por tanto como se genera un nuevo nivel,
% se llama a encode_elem del resto y a lo que devuelva se le concatena un uno.

encode_elem(X1, X2, tree(1,_,Resto)) :-
  encode_elem(X1, X2Aux, Resto),
  concatena([1], X2Aux, X2).
```

  ##### Ejemplos:

```prolog
encode_elem(a, X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [0]
false

encode_elem(b, X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [1, 0]
false

encode_elem(c, X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [1, 1, 0]
false

encode_elem(d, X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [1, 1, 1]

encode_elem(e, X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_elem(d, [0], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_elem(d, [1,1,1], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
true

encode_elem(X, [1,1,1], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = d

encode_elem(X, [1,1,2], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_elem(X, [1,0], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = b
false

encode_elem(X, [1], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_elem(X, [1,1,1], nil).
false
```

#### Apartado 8.2

En este ejercicio se pide que dada una lista y un árbol de Huffman se devuelva una lista con los elementos codificados como en el árbol.

Nuestra función va llamando recursivamente a la función **encode_elem** del apartado anterior y creando la lista de los elementos.

```prolog
encode_list([], [], _):- !.

% En caso de estar en el ultimo elemento se llama a enconde_elem se concatena
% y se termina.
encode_list([X1], L2 , T) :-
    encode_elem(X1, X2, T),
    concatena([X2], [], L2),
    !.

% Va elemento a elemento de la lista llamando a encode_elem y concatenandolos en
% la lista nueva.
encode_list([X1|Resto], L2, T) :-
    encode_elem(X1, X2, T),
    encode_list(Resto, L2Aux, T),
    concatena([X2], L2Aux, L2).
```

  ##### Ejemplos:

```prolog
encode_list([a], X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [[0]]

encode_list([a,a], X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [[0], [0]]
false

encode_list([a,d,a], X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
X = [[0], [1, 1, 1], [0]]
false

encode_list([a,d,a,q], X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_list(L, [[0], [1]], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_list([a,a], [[0], [0]], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
true
false

encode_list([a,e], X, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
false

encode_list([], L, tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
L = []

encode_list(L, [[0]], tree(1, tree(a, nil, nil), tree(1, tree(b, nil, nil), tree(1, tree(c, nil, nil), tree(d, nil, nil))))).
L = [a]
```

#### Apartado 8.3

```prolog

```

  ##### Ejemplos:

```prolog

```
