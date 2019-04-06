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
aplasta([], []).
aplasta([L|L1], LAplastado) :-
    aplasta(L, NuevaL),
    aplasta(L1, NuevaLs),
    append(NuevaL, NuevaLs, LAplastado).
aplasta(L, [L]).
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
   next_factor(N,F,NF),
   primos(N,L,NF).
```

<br>

  ##### Ejemplos:

```prolog
primos(100,L).

primos(N,[2,2,5,5]).

primos(100,[2,5,5]).

primos(100,[2,2,5]).

primos(100,[3,5,5]).

```

---
### Ejercicio 7


```prolog

```

<br>

  ##### Ejemplos:

```prolog

```

---
### Ejercicio 8


```prolog

```

<br>

  ##### Ejemplos:

```prolog

```
