% {}
completion(0,X,Y,R) :- neg(X,X1), neg(Y ,Y1),                        and(X1,Y1,R).
% {x}
completion(1,X,Y,R) :- neg(X,X1), neg(X1,X2), neg(Y,Y1),             and(X2,Y1,R).
% {y}
completion(2,X,Y,R) :- neg(Y,Y1), neg(Y1,Y2), neg(X,X1),             and(X1,Y2,R).
% {x,y}
completion(3,X,Y,R) :- neg(Y,Y1), neg(Y1,Y2), neg(X,X1), neg(X1,X2), and(X2,Y2,R).


belongs(1,x).
belongs(2,y).
belongs(3,x).
belongs(3,y).

code(0, "").
code(1, "x").
code(2, "y").
code(3, "x y").

% theory
completion_asp(AID,X,Y,R) :- theory(X,Y,Z), completion(AID,X,Y,C), and(Z,C,R).
 
consi_asp(A_ID) :- completion_asp(A_ID,X,Y,R), value(R), R > 0. 
i_compl(A_ID) :-  belongs(A_ID,x), completion_asp(A_ID,X,Y,Z), implication(Z,X,R), R < 2.
i_compl(A_ID) :-  belongs(A_ID,y), completion_asp(A_ID,X,Y,Z), implication(Z,Y,R), R < 2.

answer_set_code(M) :- consi_asp(M), not i_compl(M).
answer_set(S)      :- answer_set_code(M), code(M,S). 
