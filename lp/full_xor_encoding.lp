%% This file presents the full encoding used in the paper:
%% Everardo,F.,Osorio,M.:
%% Towards an Answer Set Programming Methodology for Constructing Programs Following a Semi-Automatic Approach.
%% Accepted to apper in the Twelve Latin American Workshop on New Methods of Reasoning 2019 (LANMR 2019), and in CEUR.
%%
%% and the extended version
%% Everardo,F.,Osorio,M.:
%% Towards an Answer Set Programming Methodology for Constructing Programs Following a Semi-Automatic Approach – Extended and Revised version.
%% Submitted to the Journal Electronic Notes in Theoretical Computer Science.

%% full_xor_encodig.lp
%% This ASP program is tailored for XOR or parity constraints/aggregates purposes.
%% This program can either:
%%   Test intermediate representations (propositional formulas), or
%%   Guess new ones.
%% 
%% This encoding receives a constant input value.
%% Please change the xor constant value for either:
%% 1: Simply guess for a formula satisfying the XOR SE properties.
%% 2: Guess only for the constraint formula discarding candidate answer sets from an external generate process that satisfies the XOR SE properties.
#const xor=1. 


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

%% Test or Guess %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1
%% Guess for a propositional formula
1 { xor(X,Y,Z) : value(Z) } 1 :- value(X), value(Y), xor=1.
%% For consistency of the xor
op(X,Y,R1) :- xor(X,Y,R1), xor=1.
xor_t(X,Y,R1) :- xor(X,Y,R1), xor=1.

%% 2
%% Test the classical logic XOR formula
%% (p ∨ q) ∧ (¬p ∨ ¬q)
op(X,Y,Z) :- or(X,Y,R1), neg(X,X1),neg(Y,Y1),or(X1,Y1,R2), and(R1,R2,Z), xor=2.
xor_t(X,Y,R1) :- op(X,Y,R1), xor=2.

%% 3
%% XOR as a Generate and Test
%% XOR generate as:
%% (x or not x) and (y or not y)
xor_g(X,Y,Z) :- neg(X,X1), neg(Y,Y1), or(X,X1,Z1), or(Y,Y1,Z2), and(Z1,Z2,Z), xor=3.
%#show xor_g/3.

%% XOR test as either:
%% Guess for a propositional formula (constraint)
1 { xor_t(X,Y,Z) : value(Z) } 1 :- value(X), value(Y), xor=3.
%% or
%% The classical XOR formula as a constraint.
%% That is, with double negation = not not ((X v Y) ^ (not X v not Y))
%xor_t(X,Y,Z2) :- or(X,Y,R1), neg(X,X1), neg(Y,Y1), or(X1,Y1,R2), and(R1,R2,Z), neg(Z,Z1), neg(Z1,Z2).
#show xor_t/3.

%% Definition of the Generate and Test XOR operator as
op(X,Y,Z) :- xor_g(X,Y,Z1), xor_t(X,Y,Z2), and(Z1,Z2,Z), xor=3.
%#show xor/3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Strong Equivalent Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Associativity: (X xor Y) xor Z = X xor (Y xor Z)
 left(X,Y,Z,R) :- xor_t(X,Y,W1), xor_t(W1,Z,R). %% Left
right(X,Y,Z,R) :- xor_t(Y,Z,W1), xor_t(X,W1,R). %% Right
:- left(X,Y,Z,R1), right(X,Y,Z,R2), R1 != R2.

% Commutativity: X xor Y = Y xor X
:- xor_t(X,Y,Z1), xor_t(Y,X,Z2), Z1 != Z2.

% Identity: X xor 0 = not not X
:- xor_t(X,0,Y), neg(X,X1), neg(X1,Z), Y != Z.

% Self_inverse for xor_t: X xor X = 0
:- xor_t(X,X,Z), Z!= 0.

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

incomplete(A_ID):-belongs(A_ID,p), completion_asp(A_ID,X,Y,Z), implication(Z,X,R), R<2.
incomplete(A_ID):-belongs(A_ID,q), completion_asp(A_ID,X,Y,Z), implication(Z,Y,R), R<2.

answer_set(S) :- consistent(A_ID), not incomplete(A_ID), code(A_ID,S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% G3 Persistency %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(1,0,2), op(2,0,X), X != 2.
:- op(0,1,2), op(0,2,X), X != 2.
:- op(X,Y,1),X!=1,Y!=1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
