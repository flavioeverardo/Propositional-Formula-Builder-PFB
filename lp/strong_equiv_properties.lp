%% Strong Equivalent Properties
%% Commutativity
:- op(X,Y,R1), op(Y,X,R2), R1!=R2. 

%% Associativity : (X op Y) op Z = X op (Y op Z)
%% Left
%left(X,Y,Z,R)  :- op(X,Y,W1), op(W1,Z,R).
%% Right
%right(X,Y,Z,R) :- op(Y,Z,W1), op(X,W1,R).
%:- left(X,Y,Z,R1), right(X,Y,Z,R2), R1 != R2.

%% Falsehood preserving
%:- op(0,0,X), X!=0.

%% Truth preserving
%:- op(2,2,X), X!=2.

%% Idenpotency
%:- op(X,X,Y), Y!=X.

%% Identity
:- op(X,0,R), R!=X.
