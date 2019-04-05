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

%divisible(X,Y) :- 0 is X mod Y, !.

%divisible(X,Y) :- X > Y+1, divisible(X, Y+1).
%isPrime(2) :- true,!.
%isPrime(X) :- X < 2,!,false.
%isPrime(X) :- not(divisible(X, 2)).
%
divisible(X,Y):-
N is Y*Y,
N =< X,
X mod Y =:= 0.

divisible(X,Y):-
Y < X,
Y1 is Y+1,
divisible(X,Y1).

isPrime(X):-
Y is 2, X > 1, \+divisible(X,Y).

next_factor(_, 2, 3).
next_factor(N, F, NF):-
    F < ceil(sqrt(N)),
    NF is F + 2.

primos(1,[]).
primos(X, [Factor1|L]):-
    between(2, X, Factor1),
    isPrime(Factor1),
    (X mod Factor1) =:= 0,
    NuevoX is X // Factor1,
    next_factor(NuevoX, Factor1, NF),
    primos(NuevoX, L).
