%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

duplica([], []).
duplica([X | L], [X , X | L1]) :- duplica(L, L1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Esto nos lo daban hecho
concatena([], L, L).
concatena([X | L1], L2, [X | L3]) :- concatena(L1,L2,L3).

%Código nuestro

invierte([], []).
invierte([X | L], R) :- invierte(L, P), concatena(P, [X], R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

palindromo([]).
palindromo(L) :- invierte(L,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

divide(L, 0, [], L).
divide([X | L], N, L1, L2) :- N1 is N - 1, divide(L, N1, P, L2), concatena([X], P, L1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aplasta([], []).
aplasta([L|L1], LAplastado) :-
    aplasta(L, NuevaL),
    aplasta(L1, NuevaLs),
    append(NuevaL, NuevaLs, LAplastado).
aplasta(L, [L]).


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
% Si N es 1 devulve una lista vacia ya que uno no se contempla como factor.

primos(1,[],_) :- !.

primos(N,[Factor|L], Factor) :-
    Cociente is N // Factor,
    N =:= Cociente * Factor,
    !,
    primos(Cociente,L,Factor).

primos(N,L,F) :-
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
cod_all([],[]).

cod_all([X|L],[Y|L1]):-
  cod_primero(X, L, Lrem, Y),
  cod_all(Lrem, L1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJERCICIO 7.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contar([],[]).
contar([[X|RestX]|L], [[N,X]|L1]) :- length([X|RestX], N), contar(L, L1).

run_lenght([],[]).
run_length(L, L1):- 
    cod_all(L, L2),
    contar(L2, L1).
