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
