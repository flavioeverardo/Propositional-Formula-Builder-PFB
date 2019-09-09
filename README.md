# Propositional-Formula-Builder-PFB
A very simple and initial implementation to construct propositional formulas from an interpretation in Gödel 3-value (G3) or Here-and-There (HT) logics

PFB: Search either for answer sets or for a formula that satisfies a given list of input answer sets with clingo 5 and Python.
Both approaches follows G3 (HT) Properties to prove Strong Equivalence.

Search for:
1) Answer sets satisfying a given formula and Strong Equivalent Properties.
```
python pfb.py --search="answer sets" --formula="or(X,Y,R)"
```
2) A program that satisfies given answer sets and Strong Equivalent Properties.
```
python soft_eng.py --search="program"
```