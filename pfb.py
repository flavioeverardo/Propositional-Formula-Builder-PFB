"""
Program Builder: Search either for answer sets or for a formula that satisfies a given list of answer sets with clingo 5 and Python. 
Both approaches follows G3 (HT) Properties to prove Strong Equivalence.
"""

# Imports
import sys
import clingo
import argparse
import random
import textwrap
import os
import contextlib

""" 
Parse Arguments 
"""
def parse_params():
    parser = argparse.ArgumentParser(prog='pfb.py',
                                     formatter_class=argparse.RawTextHelpFormatter,
                                     description=textwrap.dedent('''\
Search for:
1) Answer sets satisfying a given formula and Strong Equivalent Properties or
2) A program that satisfies given answer sets and Strong Equivalent Properties.
Default command-line: python pfb.py --search="formula" --formula="or(X,Y,R)"
                                     '''))

    ## Input related to uniform solving and sampling
    basic_args = parser.add_argument_group("Basic Options")

    parser.add_argument("--search", type=str, default="program", choices=["program", "answer sets"],
                        help="Search for either a program or for answer sets from a given formula. Default=program")
                        
    parser.add_argument("--formula", type=str, default="or(X,Y,R)",
                        help="Formula of 2 variables X and Y and an result R. This parameter is triggerd if --search=answer_sets.")

    return parser.parse_args()


"""
Checks consistency wrt. related command line args.
"""
def check_input(arguments):
    
    ## Check for errors
    if arguments.formula == "":
        raise ValueError("""Formula cannot be empty""")    
    

""" 
Main function
"""
def main():

    ## Parse input data
    args = parse_params()
    ## Check for input errors
    check_input(args)

    ## Input
    search  = args.search
    formula = args.formula

    models = [] # answer sets
    programs = [] # programs after reconstruction of G3 Tables

    ## Dictionary of formulas
    """
    Convert G3 output to formula
    x  y  v
    0, 2, 2 -> y ^ not x
    1, 2, 2 -> y ^ not not x
    2, 0, 2 -> x ^ not y
    2, 1, 2 -> x ^ not not y
    2, 2, 2 -> x ^ y
    """
    formulas = {
        (0, 2, 2) : "y ^ not x",
        (1, 2, 2) : "y ^ not not x",
        (2, 0, 2) : "x ^ not y",
        (2, 1, 2) : "y ^ not not x",
        (2, 2, 2) : "x ^ y"
    }

    ## Create clingo object and load instances
    ## Add arguments
    clingo_args = ["--sign-def=rnd",
                   "--sign-fix",
                   "--rand-freq=1",
                   "--seed=%s"%random.randint(0,32767),
                   "--restart-on-model",
                   "--enum-mode=record"]
    control = clingo.Control(clingo_args)

    if search == "program":
        control.load("lp/search_formula.lp")
    else:
        print "Formula:"
        print " ", formula
        control.load("lp/search_answer_sets.lp")
        ## Add formula
        rule = "op(X,Y,R) :- %s."%formula
        print "Adding formula to program:"
        print " ", rule
        control.add("base", [], rule)

    ## Number of answers
    control.configuration.solve.models = 0

    ## Ground
    print("Grounding...")
    control.ground([("base", [])])
    ## Solve
    print("Solving...")
    solve_result = control.solve(None, lambda model: models.append(model.symbols(shown=True)))

    if str(solve_result) == "SAT":
        print("%s, Exhausted: %s"%(solve_result,solve_result.exhausted))
        print("All answer sets\n %s"%models)
        print("")
        for answer in models:
            answer_number = models.index(answer)+1
            print("Answer: %s"%answer_number)
            print(answer)
            if args.search == "program":
                prg = []
                for theory in answer:
                    if int(str(theory.arguments[2])) == 2:
                        a0 = int(str(theory.arguments[0]))
                        a1 = int(str(theory.arguments[1]))
                        a2 = int(str(theory.arguments[2]))
                    
                        prg.append(formulas[(a0,a1,a2)])
                programs.append(prg)

        if args.search == "program":
            for program in programs:
                print program
                
    else:
        print("%s, Exhausted: %s"%(solve_result,solve_result.exhausted))

"""
Main function
"""
if __name__ == '__main__':
    sys.exit(main())					      
