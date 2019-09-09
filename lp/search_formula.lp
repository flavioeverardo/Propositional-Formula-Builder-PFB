%% search_formula.lp
%% This ASP program inverts the standard procedure by starting from the answer sets, and Strong Equivalent properties.
%% It uses brute force to calculate an encoding represented as thruth tables in G3 (HT).

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
%% Include a (incomplete) list of answer sets to satisfy
#include "answer_sets.lp".

%% Guess Approach
%% The atom theory is any function of 2 arguments
 1 { theory(X,Y,Z) : value(Z) } 1 :- value(X), value(Y).

%% Display
#show theory/3.
