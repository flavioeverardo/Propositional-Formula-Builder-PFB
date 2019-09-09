%% Strong Equivalent Properties

%% Commutativity
:- theory(X,Y,R1), theory(Y,X,R2), R1!=R2. 

%% Associativity : (X op Y) op Z = X op (Y op Z)
%% Left
left(X,Y,Z,R)  :- theory(X,Y,W1), theory(W1,Z,R).
%% Right
right(X,Y,Z,R) :- theory(Y,Z,W1), theory(X,W1,R).
:- left(X,Y,Z,R1), right(X,Y,Z,R2), R1 != R2.

%% Value operated with False, equals value
:- not theory(X,0,X), value(X).

%% Value operated with True, equals True
:- not theory(X,2,2), value(X).

%% Idenpotency
:- not theory(X,X,X), value(X).
