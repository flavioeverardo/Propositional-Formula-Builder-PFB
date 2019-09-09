%% search_answer_sets.lp
%% This ASP program takes a formula as input,
%% plus Strong Equivalent properties and search for answer sets.

%% Persistency is considered.
%% To prove strong equivalence (SE) we use Gödel’s 3-valued logic (G3)
%% which is equivalent to the logic of Here-and-There (HT).
%% For G3, the values are 0 or bottom (false there), 1 (false here but true there), and 2 or top (true here)

%% Include files:
%% logical operators
#include "logical_operators.lp".
%% G3 persistency constraints
#include "g3_persistent.lp".
%% Strong Equivalent Properties
%#include "strong_equiv_properties.lp".
%% Theory and Completion statements
#include "theory_completion.lp".

%% Display
#show answer_set/1.

%% Proposed Formulas
% ej1
% y :- not x.
%op(X,Y,R) :- neg(X,X1), implication(X1,Y,R).

% ej2
% y :- x.
%op(X,Y,R) :-  implication(X,Y,R).

% ej3
% x v y.
%op(X,Y,R) :-  or(X,Y,R).
%op(X,Y,R) :-  and(X,Y,R).

% ej4
% x v not x. y. 
%op(X,Y,R) :-  neg(X,X1), or(X,X1,W), and(W,Y,R).

% ej5
%% xor = (X v Y) ^ (not X v not Y)
%op(X,Y,Z) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z).

% ej6
%% XOR Test
%% xor test = not (X ^ Y) ^ not (not X ^ not Y))
%% xor test = (not X v not Y) ^ (not not X v not not Y)
%op(X,Y,Z2) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z), neg(Z,Z1), neg(Z1,Z2).

% ej7
%% Generate
%generate(X,Y,Z) :- neg(X,X1), neg(Y,Y1), or(X,X1,R1), or(Y,Y1,R2), and(R1,R2, Z).
%% xor = --((X v Y) ^ (not X v not Y))
%test(X,Y,Z2) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z), neg(Z,Z1), neg(Z1,Z2).

%op(X,Y,Z) :- generate(X,Y,Z1), test(X,Y,Z2), and(Z1,Z2,Z).
