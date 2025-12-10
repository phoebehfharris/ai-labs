:- discontiguous initially/1, initiates/3, terminates/3.

holds(F,[]) :- initially(F).
holds(F,[E|Es]) :- holds(F,Es) -> not(terminates(E,F,Es)) ; initiates(E,F,Es).

fluent(F) :- member(F,[conditional, detached, satisfied, violated, expired]).
event(E) :- member(E,[antecedent, consequent, timeout, other]).

initially(conditional).

initiates(consequent, satisfied, Es) :- holds(conditional, Es).
terminates(consequent, conditional, Es) :- holds(conditional, Es).

initiates(consequent, satisfied, Es) :- holds(detached, Es).
terminates(consequent, detached, Es) :- holds(detached, Es).

% ...Please fill in the rest!
initiates(antecedent, detached, Es) :- holds(conditional, Es).
terminates(antecedent, conditional, Es) :- holds(conditional, Es).

initiates(timeout, violated, Es) :- holds(detached, Es).
terminates(timeout, detached, Es) :- holds(detached, Es).

initiates(timeout, expired, Es) :- holds(conditional, Es).
terminates(timeout, conditional, Es) :- holds(conditional, Es).
