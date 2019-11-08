%% search_formula.lp
%% This ASP program is tailored for XOR or parity constraints/aggregates purposes.
%% This program can either:
%%   Test intermediate representations (propositional formulas), or
%%   Guess new ones.
%% 
%% At first we can test the feasibility that the classical XOR formula, satisfies and given answer sets and Strong Equivalent properties by uncommenting Lines 48 and 49.
%% Then, we could ask for a representation (which results in a constraint) by uncommenting Lines 54 and 55.
%% Finally, we can test the resulting constraint by uncommenting Lines 60-62

%% This approach inverts the standard procedure by starting from the answer sets, and Strong Equivalent properties.
%% It uses brute force to test or calculate an encoding represented as thruth tables in G3 (HT).

%% Persistency is considered.
%% To prove strong equivalence (SE) we use Gödel’s 3-valued logic (G3)
%% which is equivalent to the logic of Here-and-There (HT).
%% For G3, the values are 0 or bottom (false there), 1 (false here but true there), and 2 or top (true here)

%% Input Answer Sets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include a (incomplete) list of answer sets to satisfy
:- not answer_set("p").
:- not answer_set("q").
:- answer_set("").
:- answer_set("p q").
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Strong Equivalent Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Commutativity: X xor Y = Y xor X
:- op(X,Y,R1), op(Y,X,R2), R1!=R2.

%% Associativity: (X xor Y) xor Z = X xor (Y xor Z)
 left(X,Y,Z,R) :- op(X,Y,W1), op(W1,Z,R). %% Left
right(X,Y,Z,R) :- op(Y,Z,W1), op(X,W1,R). %% Right
:- left(X,Y,Z,R1), right(X,Y,Z,R2), R1 != R2.

%% Self Inverse: X xor X = 0
:- op(X,X,R), R!=0.

%% Identity: X xor 0 = not not X
:- op(X,0,Y), neg(X,X1), neg(X1,Z), value(Y), Y != Z.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test or Guess %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please uncomment one of the three options below

%% Test the classical xor formula = (X v Y) ^ (not X v not Y)
%% This yields UNSAT
op(X,Y,Z) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z).
#show op/3.

%% Guess for a propositional formula
%% This yields the single answer set:
%% op(0,2,2) op(2,0,2) op(0,1,2) op(1,0,2) op(0,0,0) op(1,1,0) op(2,2,0) op(1,2,0) op(2,1,0)
%1 { op(X,Y,Z) : value(Z) } 1 :- value(X), value(Y).
%#show op/3.

%% Test classical xor as a constraint. That is, with double negation = not not ((X v Y) ^ (not X v not Y))
%% This yields the same answer set as the guess single answer set:
%% op(0,2,2) op(2,0,2) op(0,1,2) op(1,0,2) op(0,0,0) op(1,1,0) op(2,2,0) op(1,2,0) op(2,1,0)
%op(X,Y,Z2) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z), neg(Z,Z1), neg(Z1,Z2).
%#show op/3.
%#show answer_set/1. %% Additionally, please comment the Input Answer Sets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Logical operators in G3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value(0..2). %% G3 values

%% And
and(X,X,X) :- value(X).
and(X,Y,X) :- value(X), value(Y), X<Y.
and(X,Y,Y) :- value(X), value(Y), Y<X.

%% Or
or(X,X,X) :- value(X).
or(X,Y,X) :- value(X), value(Y), Y<X.
or(X,Y,Y) :- value(X), value(Y), X<Y.

%% Negations
neg(0,2). neg(2,0). neg(1,0).

%% Implication
implication(X,Y,2) :- value(X), value(Y), X <= Y.
implication(X,Y,Y) :- value(X), value(Y), X > Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Theory completion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
completion(0,X,Y,R):- neg(X,X1), neg(Y ,Y1), and(X1,Y1,R).
completion(1,X,Y,R):- neg(X,X1), neg(X1,X2), neg(Y,Y1), and(X2,Y1,R).
completion(2,X,Y,R):- neg(Y,Y1), neg(Y1,Y2), neg(X,X1), and(X1,Y2,R).
completion(3,X,Y,R):- neg(Y,Y1), neg(Y1,Y2), neg(X,X1), neg(X1,X2), and(X2,Y2,R).

belongs(1,p).
belongs(2,q).
belongs(3,p).
belongs(3,q).

code(0, "").
code(1, "p").
code(2, "q").
code(3, "p q").

completion_asp(A_ID,X,Y,R) :- op(X,Y,Z), completion(A_ID,X,Y,C), and(Z,C,R).

consistent(A_ID):-completion_asp(A_ID,X,Y,R),value(R),R>0.

incomplete(A_ID):-belongs(A_ID,x), completion_asp(A_ID,X,Y,Z), implication(Z,X,R), R<2.
incomplete(A_ID):-belongs(A_ID,y), completion_asp(A_ID,X,Y,Z), implication(Z,Y,R), R<2.

answer_set(S) :- consistent(A_ID), not incomplete(A_ID), code(A_ID,S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% G3 Persistency %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(1,0,2), op(2,0,X), X != 2.
:- op(0,1,2), op(0,2,X), X != 2.
:- op(X,Y,1),X!=1,Y!=1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
