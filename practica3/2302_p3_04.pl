%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

duplica([], []).
% Si son iguales el primer elemento de L y los dos primeros de L1 hace una
% llamada recursiva.
duplica([X | L], [X , X | L1]) :-
  duplica(L, L1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Esto nos lo daban hecho
concatena([], L, L).

concatena([X | L1], L2, [X | L3]) :-
  concatena(L1,L2,L3).

% Código nuestro

invierte([], []).
% Una vez llega al final de la lista por invierte va llamando a concatena y
% creando la lista nueva invertida.
invierte([X | L], R) :-
  invierte(L, P),
  concatena(P, [X], R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Llama a invierte y esta devuelve True si es la misma lista invertida.
palindromo([]).

palindromo(L) :-
  invierte(L,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

divide(L, 0, [], L).

% Decrementa N hasta el caso base y luego va concatenando y comprobando.
divide([X | L], N, L1, L2) :-
  N1 is N - 1,
  divide(L, N1, P, L2),
  concatena([X], P, L1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Va recorriendo los elementos de la lista y en caso de que el elemento sea una
% lista la recorre a su vez, todo esto comparando con los elementos de la otra
% lista.
aplasta(L,[L]) :-
  \+ is_list(L).

aplasta([], []).

aplasta([L|L1], LAplastado) :-
  aplasta(L, NuevaL),
  aplasta(L1, NuevaLs),
  append(NuevaL, NuevaLs, LAplastado).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 7.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 7.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caso base las dos listas están vacías.
cod_all([],[]).

% Recorre la primera lista y va llamando a cod_primero por cada elemento nuevo
% que encuentra.
cod_all([X|L],[Y|L1]):-
  cod_primero(X, L, Lrem, Y),
  cod_all(Lrem, L1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 7.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Caso base
build_tree([], nil).

% En caso de que no queden mas elementos en la lista de nodos se para.
build_tree([Nodo-_], tree(Nodo, nil, nil)):- !.

% Va recorriendo los nodos y metiendolos en el arbol.
build_tree([Nodo-_|Resto], T) :-
  build_tree(Resto, TAux),
  T = tree(1, tree(Nodo, nil, nil), TAux).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 8.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 8.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 8.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Para poder implementar esta última
% función, hemos tenido que implementar
% una serie de funciones auxiliares.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta funcion, le pone guion a lo que devuelve run_length ya que para formar
% el arbol los argumentos tienen que tener la forma [caracter-numRep]
pone_guion([],[]) :- !.

pone_guion([[X, Y|_] | Resto], [[Y-X]|L]) :-
  pone_guion(Resto, L).


% Esta funcion, inserta en una lista ordenadamente los elementos que se le
% pasan teniendo en cuenta el valor de después del guion que es el numero
% de repeticiones.
insertar([X-Y],[], [X-Y]).

insertar([X-Y], [P-Q|Resto], [X-Y, P-Q | Resto]) :-
  Y =< Q.

insertar([X-Y], [P-Q|Resto], [P-Q | Z]) :-
  insertar([X-Y], Resto, Z),
  Y > Q.

% Esta función, ordena una lista que contiene elementos del tipo
%[caracter-numRep] haciendo uso de la funcion insertar para ello.
ordena_lista([],[]).

ordena_lista([[X-Y] | Resto], L) :-
  ordena_lista(Resto, Buffer),
  insertar([X-Y], Buffer, L).

% Esta funcion detecta si hay algun elemento del texto a codificar que no se
% encuentra en el diccionario
validar_elemento(_, []) :- !.

validar_elemento(X, D) :-
  member(X, D).

validar_texto([], _).

validar_texto([X | Resto], D) :-
  validar_elemento(X, D),
  validar_texto(Resto, D).

% Diccionario que se nos proporciona en el enunciado.
dictionary([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]).

% Caso base
encode([], []) :- !.

encode(L1, L2) :-
  sort(0, @=<, L1, SortedL1),
  dictionary(D),
  validar_texto(SortedL1, D),
  run_length(SortedL1, CountedL1),
  pone_guion(CountedL1, GuionL1),
  ordena_lista(GuionL1, OrdenadaL1),
  invierte(OrdenadaL1, ReOrdenadaL1),
  build_tree(ReOrdenadaL1, T),
  encode_list(L1, L2, T).
