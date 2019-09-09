value(0..2). %% G3 values

and(X,X,X) :- value(X).
and(X,Y,X) :- value(X), value(Y), X<Y.
and(X,Y,Y) :- value(X), value(Y), Y<X.

or(X,X,X) :- value(X).
or(X,Y,X) :- value(X), value(Y), Y<X.
or(X,Y,Y) :- value(X), value(Y), X<Y.

neg(0,2).
neg(2,0).
neg(1,0).

implication(X,Y,2) :- value(X), value(Y), X <= Y.
implication(X,Y,Y) :- value(X), value(Y), X > Y. 
