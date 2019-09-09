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
#include "strong_equiv_properties.lp".
%% Theory and Completion statements
#include "theory_completion.lp".

%% Display
#show answer_set/1.

%% Proposed Formulas
% ej1
% y :- not x.
%theory(X,Y,R) :- neg(X,X1), impl(X1,Y,R).

% ej2
% y :- x.
%theory(X,Y,R) :-  impl(X,Y,R).

% ej3
% x v y.
%theory(X,Y,R) :-  or(X,Y,R).
%theory(X,Y,R) :-  and(X,Y,R).

% ej4
% x v not x. y. 
%theory(X,Y,R) :-  neg(X,X1), or(X,X1,W), and(W,Y,R).

