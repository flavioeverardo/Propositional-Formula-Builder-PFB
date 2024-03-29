# Propositional-Formula-Builder-PFB
A very simple and initial implementation to construct propositional formulas from an interpretation in Gödel 3-value (G3) or Here-and-There (HT) logics.

PFB: Search either for answer sets or for a formula that satisfies a given list of input answer sets with clingo 5 and Python.</br>
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

# Dependencies
- Python 2.7
- clingo (5.4) with Python support. [clingo @ Potassco.org](https://www.potassco.org/clingo)

# What else is in the box?
search_answer_sets.lp: ASP driver for (1). </br>
search_formula.lp : ASP driver for (2). </br>

answer_sets.lp : Input answer sets that a guessed formula must satisfy. </br>
g3_persistent.lp : Checking persistency in G3. </br>
logical_operators.lp : And, Or, Negation and Implication operators in G3. </br>
strong_equiv_properties.lp : Input Strong Equivalence properties. </br>
theory_completion.lp : Theory completion to characterize ASP in G3. </br>

# ToDO:
1. Convert output formula to normal-form. </br>
2. Add more G3 Interpretations. </br>
3. Test input for more complex formulas. </br>
